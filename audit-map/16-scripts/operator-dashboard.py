#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import os
import shlex
import subprocess
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent.parent
AUDIT_MAP = REPO_ROOT / "audit-map"
STATUS_ROOT = AUDIT_MAP / "29-status"
CHECKPOINT_ROOT = AUDIT_MAP / "30-checkpoints"
LOG_ROOT = AUDIT_MAP / "22-logs"
QUEUE_ROOT = AUDIT_MAP / "31-queues"
REPORT_ROOT = AUDIT_MAP / "32-reports"
ACCOUNT_ROOT = AUDIT_MAP / "25-accounts-routing"
REPORT_FILE = REPORT_ROOT / "operator-dashboard.md"
DEFAULT_STALL_SECONDS = int(os.environ.get("AUDIT_OPERATOR_STALL_SECONDS", "1200"))


def now_utc() -> dt.datetime:
    return dt.datetime.now(dt.timezone.utc)


def parse_env_file(path: Path) -> dict[str, str]:
    data: dict[str, str] = {}
    if not path.exists():
        return data
    for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
        if "=" not in raw or raw.startswith("#"):
            continue
        key, value = raw.split("=", 1)
        try:
            parts = shlex.split(value, posix=True)
            data[key] = parts[0] if parts else ""
        except ValueError:
            data[key] = value
    return data


def parse_iso(value: str | None) -> dt.datetime | None:
    if not value:
        return None
    try:
        if value.endswith("Z"):
            value = value[:-1] + "+00:00"
        return dt.datetime.fromisoformat(value).astimezone(dt.timezone.utc)
    except ValueError:
        return None


def fmt_dt(value: str | None) -> str:
    parsed = parse_iso(value)
    if not parsed:
        return value or ""
    return parsed.strftime("%Y-%m-%d %H:%M UTC")


def fmt_age(seconds: float | None) -> str:
    if seconds is None:
        return ""
    seconds = int(seconds)
    hours, remainder = divmod(seconds, 3600)
    minutes, secs = divmod(remainder, 60)
    if hours:
        return f"{hours}h {minutes}m"
    if minutes:
        return f"{minutes}m {secs}s"
    return f"{secs}s"


def first_queue_entries(limit: int = 8) -> list[dict[str, str]]:
    queue_file = QUEUE_ROOT / "pending.queue"
    entries: list[dict[str, str]] = []
    if not queue_file.exists():
        return entries
    for raw in queue_file.read_text(encoding="utf-8", errors="replace").splitlines():
        if not raw or raw.startswith("#"):
            continue
        parts = raw.split("\t")
        parts += [""] * (4 - len(parts))
        entries.append(
            {
                "pass_name": parts[0],
                "context": parts[1],
                "task_class": parts[2],
                "prompt_file": parts[3],
            }
        )
        if len(entries) >= limit:
            break
    return entries


def tmux_present(session_name: str) -> str:
    if not session_name:
        return "unknown"
    proc = subprocess.run(
        ["tmux", "has-session", "-t", session_name],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
    )
    if proc.returncode == 0:
        return "present"
    output = f"{proc.stdout}\n{proc.stderr}"
    if "Operation not permitted" in output or "Permission denied" in output:
        return "inaccessible"
    return "missing"


def file_mtime(path: Path) -> float | None:
    try:
        return path.stat().st_mtime
    except FileNotFoundError:
        return None


def session_statuses() -> list[dict[str, str]]:
    sessions: list[dict[str, str]] = []
    for path in sorted(STATUS_ROOT.glob("*.status")):
        if path.name.startswith("arctic-slot-"):
            continue
        if path.name.startswith("route-health-"):
            continue
        if path.name.startswith("provider-rotation-"):
            continue
        if path.name == "caveman.status":
            continue
        data = parse_env_file(path)
        checkpoint_path = CHECKPOINT_ROOT / f"{path.stem}.checkpoint"
        checkpoint = parse_env_file(checkpoint_path)
        if "session_name" not in data:
            data["session_name"] = path.stem
        if "pass_name" not in data and "pass_name" in checkpoint:
            data["pass_name"] = checkpoint["pass_name"]
        if "context" not in data and "context" in checkpoint:
            data["context"] = checkpoint["context"]
        if "workdir" not in data and "workdir" in checkpoint:
            data["workdir"] = checkpoint["workdir"]
        if "provider" not in data and "current_provider" in checkpoint:
            data["provider"] = checkpoint["current_provider"]
        if "account" not in data and "current_account" in checkpoint:
            data["account"] = checkpoint["current_account"]
        if "model" not in data and "current_model" in checkpoint:
            data["model"] = checkpoint["current_model"]
        if "state" not in data and "last_event" in checkpoint:
            data["state"] = checkpoint["last_event"]
        if "checkpoint_file" not in data:
            data["checkpoint_file"] = str(checkpoint_path)
        if "log_file" not in data:
            data["log_file"] = str(LOG_ROOT / f"{data['session_name']}.log")
        if "pass_name" not in data:
            continue
        data["_status_path"] = str(path)
        log_file = Path(data.get("log_file") or "")
        checkpoint_file = Path(data.get("checkpoint_file") or "")
        last_message_file = REPORT_ROOT / f"{data['session_name']}.last-message.md"
        mtimes = [value for value in [file_mtime(path), file_mtime(log_file), file_mtime(checkpoint_file), file_mtime(last_message_file)] if value]
        last_activity_epoch = max(mtimes) if mtimes else None
        data["_last_activity_epoch"] = str(last_activity_epoch or "")
        data["_tmux_state_live"] = tmux_present(data.get("session_name", ""))
        if last_activity_epoch:
            idle_seconds = now_utc().timestamp() - last_activity_epoch
            data["_idle_seconds"] = str(int(idle_seconds))
            if data.get("state") == "running" and idle_seconds >= DEFAULT_STALL_SECONDS:
                data["_suspected_stall"] = "yes"
            else:
                data["_suspected_stall"] = "no"
        else:
            data["_idle_seconds"] = ""
            data["_suspected_stall"] = "no"
        sessions.append(data)
    sessions.sort(key=lambda item: item.get("created_at", ""))
    return sessions


def active_pass(sessions: list[dict[str, str]]) -> dict[str, str] | None:
    live = [s for s in sessions if s.get("state") in {"running", "starting", "queued"} and s.get("pass_name") != "night-run-orchestrator" and s.get("pass_name") != "usage-refresh-orchestrator"]
    if live:
        live.sort(key=lambda item: (item.get("state") != "running", item.get("created_at", "")))
        return live[0]
    blocked = [s for s in sessions if s.get("state") in {"stale", "manual_action_required", "failed"} and s.get("pass_name") != "night-run-orchestrator" and s.get("pass_name") != "usage-refresh-orchestrator"]
    if not blocked:
        return None
    blocked.sort(key=lambda item: item.get("updated_at", ""), reverse=True)
    return blocked[0]


def next_route_for_queue_head(queue_entries: list[dict[str, str]]) -> dict[str, str]:
    if not queue_entries:
        return {}
    pass_name = queue_entries[0]["pass_name"]
    proc = subprocess.run(
        ["bash", "audit-map/16-scripts/select-execution-route.sh", pass_name],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
    )
    route: dict[str, str] = {"_rc": str(proc.returncode)}
    for line in proc.stdout.splitlines():
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        try:
            parts = shlex.split(value, posix=True)
            route[key] = parts[0] if parts else ""
        except ValueError:
            route[key] = value
    route["_stderr"] = proc.stderr.strip()
    return route


def slot_rows() -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for path in sorted(STATUS_ROOT.glob("arctic-slot-*.status")):
        data = parse_env_file(path)
        data["_slot"] = data.get("slot") or path.stem.replace("arctic-slot-", "")
        rows.append(data)
    return rows


def render_markdown(sessions: list[dict[str, str]], queue_entries: list[dict[str, str]], route: dict[str, str]) -> str:
    active = active_pass(sessions)
    lines: list[str] = []
    lines.append("# Operator Dashboard\n")
    lines.append(f"Generated: {now_utc().strftime('%Y-%m-%d %H:%M:%S UTC')}\n")

    lines.append("## Active Pass\n")
    if active:
        lines.extend(
            [
                f"- pass: `{active.get('pass_name','')}`",
                f"- state: `{active.get('state','')}`",
                f"- provider: `{active.get('provider','')}`",
                f"- model: `{active.get('model','')}`",
                f"- slot: `{active.get('route_selected_slot') or active.get('account') or 'native'}`",
                f"- route attempt: `{active.get('route_attempt','')}`",
                f"- tmux: `{active.get('_tmux_state_live','')}`",
                f"- last visible activity age: `{fmt_age(float(active['_idle_seconds'])) if active.get('_idle_seconds') else ''}`",
                f"- supervisor: `{active.get('execution_supervisor_state','')}`",
                f"- suspected stall: `{active.get('_suspected_stall','no')}`",
                "",
            ]
        )
    else:
        lines.append("- No active pass detected.\n")

    lines.append("## Queue Preview\n")
    if queue_entries:
        for index, entry in enumerate(queue_entries, start=1):
            lines.append(f"{index}. `{entry['pass_name']}` (`{entry['context'] or 'local'}` / `{entry['task_class'] or 'unknown'}`)")
    else:
        lines.append("- Queue empty.")
    lines.append("")

    lines.append("## Next Route Decision\n")
    if route:
        lines.extend(
            [
                f"- route state: `{route.get('route_state','')}`",
                f"- provider: `{route.get('selected_provider','')}`",
                f"- model: `{route.get('selected_model','')}`",
                f"- slot: `{route.get('selected_slot','') or route.get('selected_account','')}`",
                f"- reason: {route.get('route_reason','')}",
                "",
            ]
        )
    else:
        lines.append("- No queued pass to evaluate.\n")

    lines.append("## Detached Sessions\n")
    lines.append("| Session | State | Provider | Model | Route Attempt | Idle | tmux | Suspected Stall |")
    lines.append("| --- | --- | --- | --- | --- | --- | --- | --- |")
    for item in sessions:
        lines.append(
            "| `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` |".format(
                item.get("session_name", ""),
                item.get("state", ""),
                item.get("provider", ""),
                item.get("model", ""),
                item.get("route_attempt", ""),
                fmt_age(float(item["_idle_seconds"])) if item.get("_idle_seconds") else "",
                item.get("_tmux_state_live", ""),
                item.get("_suspected_stall", "no"),
            )
        )
    lines.append("")

    lines.append("## Slot Reset Windows\n")
    lines.append("| Slot | Provider | Account | Access | Route State | Exec State | Last Probe Failure | Execution Model | Primary % | Primary Reset | Secondary % | Secondary Reset | Cooldown |")
    lines.append("| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |")
    for item in slot_rows():
        lines.append(
            "| `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` | `{}` |".format(
                item.get("_slot", ""),
                item.get("provider", ""),
                item.get("account_label", ""),
                item.get("usage_access_status", ""),
                item.get("execution_route_state", ""),
                item.get("execution_verification_state", ""),
                item.get("execution_last_probe_failure_class", ""),
                item.get("execution_model", ""),
                item.get("usage_limit_primary_percent", ""),
                fmt_dt(item.get("usage_limit_primary_reset_at")),
                item.get("usage_limit_secondary_percent", ""),
                fmt_dt(item.get("usage_limit_secondary_reset_at")),
                " ".join(
                    part
                    for part in [item.get("cooldown_state", ""), fmt_dt(item.get("cooldown_next_eligible_at"))]
                    if part
                ),
            )
        )
    lines.append("")

    warnings = [s for s in sessions if s.get("_suspected_stall") == "yes"]
    lines.append("## Warnings\n")
    warnings.extend([s for s in sessions if s.get("state") == "stale"])
    seen = set()
    deduped = []
    for item in warnings:
        key = item.get("session_name", "")
        if key in seen:
            continue
        seen.add(key)
        deduped.append(item)
    if deduped:
        for item in deduped:
            lines.append(
                f"- `{item.get('session_name','')}` needs attention: state=`{item.get('state','')}`, idle=`{fmt_age(float(item['_idle_seconds'])) if item.get('_idle_seconds') else ''}`, provider=`{item.get('provider','')}`, model=`{item.get('model','')}`"
            )
    else:
        lines.append("- No sessions currently breach the stall threshold.")
    lines.append("")

    return "\n".join(lines)


def color(text: str, code: str, enabled: bool) -> str:
    return f"\033[{code}m{text}\033[0m" if enabled else text


def render_console(sessions: list[dict[str, str]], queue_entries: list[dict[str, str]], route: dict[str, str], ansi: bool) -> str:
    active = active_pass(sessions)
    lines: list[str] = []
    lines.append(color("AirMentor Operator Dashboard", "1;36", ansi))
    lines.append(f"Generated: {now_utc().strftime('%Y-%m-%d %H:%M:%S UTC')}")
    lines.append("")
    if active:
        state = active.get("state", "")
        state_color = "1;31" if active.get("_suspected_stall") == "yes" or state in {"stale", "failed", "manual_action_required"} else ("1;32" if state == "running" else "1;33")
        lines.append(color("Active Pass", "1;34", ansi))
        lines.append(f"  pass       {active.get('pass_name','')}")
        lines.append(f"  state      {color(state, state_color, ansi)}")
        lines.append(f"  provider   {active.get('provider','')}")
        lines.append(f"  model      {active.get('model','')}")
        lines.append(f"  slot       {active.get('route_selected_slot') or active.get('account') or 'native'}")
        lines.append(f"  attempt    {active.get('route_attempt','')}")
        lines.append(f"  tmux       {active.get('_tmux_state_live','')}")
        lines.append(f"  idle       {fmt_age(float(active['_idle_seconds'])) if active.get('_idle_seconds') else ''}")
        lines.append(f"  supervisor {active.get('execution_supervisor_state','')}")
        lines.append(f"  suspected  {active.get('_suspected_stall','no')}")
    else:
        lines.append(color("Active Pass", "1;34", ansi))
        lines.append("  none")
    lines.append("")
    lines.append(color("Queue", "1;34", ansi))
    if queue_entries:
        for idx, entry in enumerate(queue_entries[:6], start=1):
            lines.append(f"  {idx}. {entry['pass_name']} [{entry['context'] or 'local'} / {entry['task_class'] or 'unknown'}]")
    else:
        lines.append("  empty")
    lines.append("")
    lines.append(color("Next Route", "1;34", ansi))
    if route:
        lines.append(f"  state      {route.get('route_state','')}")
        lines.append(f"  provider   {route.get('selected_provider','')}")
        lines.append(f"  model      {route.get('selected_model','')}")
        lines.append(f"  slot       {route.get('selected_slot','') or route.get('selected_account','')}")
        lines.append(f"  reason     {route.get('route_reason','')}")
    else:
        lines.append("  none")
    lines.append("")
    lines.append(color("Slots", "1;34", ansi))
    for item in slot_rows():
        cooldown = " ".join(part for part in [item.get("cooldown_state", ""), fmt_dt(item.get("cooldown_next_eligible_at"))] if part)
        failure = item.get("execution_last_probe_failure_class", "")
        if not failure and item.get("execution_route_state") == "verified":
            failure = "ok"
        elif not failure:
            failure = item.get("usage_access_status", "")
        lines.append(
            "  {slot:<24} {provider:<14} p={primary:<5} s={secondary:<5} route={route_state:<18} exec={exec_state:<9} fail={failure:<18} cooldown={cooldown}".format(
                slot=item.get("_slot", "")[:24],
                provider=item.get("provider", "")[:14],
                primary=item.get("usage_limit_primary_percent", "")[:5],
                secondary=item.get("usage_limit_secondary_percent", "")[:5],
                route_state=item.get("execution_route_state", "")[:18],
                exec_state=item.get("execution_verification_state", "")[:9],
                failure=failure[:18],
                cooldown=cooldown or "clear",
            )
        )
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write-only", action="store_true")
    parser.add_argument("--no-ansi", action="store_true")
    args = parser.parse_args()

    REPORT_ROOT.mkdir(parents=True, exist_ok=True)
    sessions = session_statuses()
    queue_entries = first_queue_entries()
    route = next_route_for_queue_head(queue_entries)
    REPORT_FILE.write_text(render_markdown(sessions, queue_entries, route), encoding="utf-8")
    if not args.write_only:
        sys.stdout.write(render_console(sessions, queue_entries, route, ansi=not args.no_ansi))
        sys.stdout.write(f"\nReport: {REPORT_FILE}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
