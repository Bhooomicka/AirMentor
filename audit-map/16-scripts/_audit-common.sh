#!/usr/bin/env bash
set -euo pipefail

audit_repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
}

AUDIT_REPO_ROOT="${AUDIT_REPO_ROOT:-$(audit_repo_root)}"
AUDIT_MAP_ROOT="$AUDIT_REPO_ROOT/audit-map"
AUDIT_LOG_ROOT="$AUDIT_MAP_ROOT/22-logs"
AUDIT_STATUS_ROOT="$AUDIT_MAP_ROOT/29-status"
AUDIT_CHECKPOINT_ROOT="$AUDIT_MAP_ROOT/30-checkpoints"
AUDIT_QUEUE_ROOT="$AUDIT_MAP_ROOT/31-queues"
AUDIT_TMUX_ROOT="$AUDIT_MAP_ROOT/26-tmux"
AUDIT_REPORT_ROOT="$AUDIT_MAP_ROOT/32-reports"
AUDIT_ACCOUNT_ROOT="$AUDIT_MAP_ROOT/25-accounts-routing"
AUDIT_SNAPSHOT_ROOT="$AUDIT_MAP_ROOT/18-snapshots"
AUDIT_ACCOUNT_SNAPSHOT_ROOT="$AUDIT_SNAPSHOT_ROOT/accounts"
ARCTIC_SLOT_MAP_FILE="$AUDIT_ACCOUNT_ROOT/slot-map.tsv"
ARCTIC_SLOT_DATA_ROOT="${HOME}/.local/share/air-mentor-audit/arctic-slots"
ARCTIC_SLOT_CONFIG_ROOT="${HOME}/.config/air-mentor-audit/arctic-slots"

ensure_audit_dirs() {
  mkdir -p \
    "$AUDIT_LOG_ROOT" \
    "$AUDIT_STATUS_ROOT" \
    "$AUDIT_CHECKPOINT_ROOT" \
    "$AUDIT_QUEUE_ROOT" \
    "$AUDIT_TMUX_ROOT" \
    "$AUDIT_REPORT_ROOT" \
    "$AUDIT_ACCOUNT_ROOT" \
    "$AUDIT_ACCOUNT_SNAPSHOT_ROOT"
}

timestamp_utc() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

compact_timestamp() {
  date -u +%Y%m%dT%H%M%SZ
}

slugify() {
  local input="${*:-}"
  printf '%s' "$input" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-'
}

project_slug() {
  slugify "$(basename "$AUDIT_REPO_ROOT")"
}

session_name_for() {
  local context="${1:-local}"
  local pass_name="${2:-job}"
  printf 'audit-%s-%s-%s' "$(project_slug)" "$(slugify "$context")" "$(slugify "$pass_name")"
}

status_path_for() {
  printf '%s/%s.status\n' "$AUDIT_STATUS_ROOT" "$1"
}

checkpoint_path_for() {
  printf '%s/%s.checkpoint\n' "$AUDIT_CHECKPOINT_ROOT" "$1"
}

log_path_for() {
  printf '%s/%s.log\n' "$AUDIT_LOG_ROOT" "$1"
}

command_path_for() {
  printf '%s/%s.command.sh\n' "$AUDIT_QUEUE_ROOT" "$1"
}

prompt_bundle_path_for() {
  printf '%s/%s.prompt.md\n' "$AUDIT_QUEUE_ROOT" "$1"
}

last_message_path_for() {
  printf '%s/%s.last-message.md\n' "$AUDIT_REPORT_ROOT" "$1"
}

write_env_file() {
  local file="$1"
  shift
  : >"$file"
  while [ "$#" -gt 0 ]; do
    local key="$1"
    local value="$2"
    shift 2
    printf '%s=%q\n' "$key" "$value" >>"$file"
  done
}

upsert_env() {
  local file="$1"
  local key="$2"
  local value="$3"
  local dir=""
  local base=""
  local tmp=""
  dir="$(dirname "$file")"
  base="$(basename "$file")"
  touch "$file"
  tmp="$(mktemp "$dir/${base}.XXXXXX.tmp")"
  grep -v "^${key}=" "$file" >"$tmp" || true
  printf '%s=%q\n' "$key" "$value" >>"$tmp"
  mv "$tmp" "$file"
}

read_env_value() {
  local file="$1"
  local key="$2"
  local line
  line="$(grep -E "^${key}=" "$file" | tail -n 1 || true)"
  [ -n "$line" ] || return 1
  line="${line#*=}"
  eval "printf '%s' $line"
}

session_name_from_status_file() {
  local status_file="${1:-}"
  local stem=""
  stem="$(basename "${status_file:-}" .status 2>/dev/null || true)"
  [ -n "$stem" ] || return 1
  printf '%s\n' "$stem"
}

infer_context_and_pass_from_session_name() {
  local session_name="${1:-}"
  local prefix=""
  local tail=""
  local context=""

  prefix="audit-$(project_slug)-"
  case "$session_name" in
    "${prefix}"*)
      tail="${session_name#"$prefix"}"
      ;;
    *)
      return 1
      ;;
  esac

  for context in bootstrap live overnight local; do
    case "$tail" in
      "${context}"-*)
        printf 'context=%q\n' "$context"
        printf 'pass_name=%q\n' "${tail#"$context"-}"
        return 0
        ;;
    esac
  done

  return 1
}

sanitize_env_file() {
  local file="${1:-}"
  local tmp=""
  local dir=""
  local base=""
  [ -f "$file" ] || return 0
  dir="$(dirname "$file")"
  base="$(basename "$file")"
  tmp="$(mktemp "$dir/${base}.XXXXXX.tmp")"
  awk '/^[A-Za-z_][A-Za-z0-9_]*=/' "$file" >"$tmp"
  mv "$tmp" "$file"
}

repair_session_status_file() {
  local status_file="${1:-}"
  local checkpoint_file="${2:-}"
  local session_name=""
  local pass_name=""
  local context=""
  local state=""
  local workdir=""
  local log_file=""
  local command_file=""
  local model=""
  local provider=""
  local account=""
  local created_at=""
  local updated_at=""
  local inferred=""

  [ -f "$status_file" ] || return 1
  sanitize_env_file "$status_file"
  [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ] && sanitize_env_file "$checkpoint_file"

  session_name="$(read_env_value "$status_file" session_name 2>/dev/null || true)"
  [ -n "$session_name" ] || session_name="$(session_name_from_status_file "$status_file" 2>/dev/null || true)"
  [ -n "$session_name" ] || return 1

  pass_name="$(read_env_value "$status_file" pass_name 2>/dev/null || true)"
  context="$(read_env_value "$status_file" context 2>/dev/null || true)"
  if [ -z "$pass_name" ] || [ -z "$context" ]; then
    if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
      [ -n "$pass_name" ] || pass_name="$(read_env_value "$checkpoint_file" pass_name 2>/dev/null || true)"
      [ -n "$context" ] || context="$(read_env_value "$checkpoint_file" context 2>/dev/null || true)"
    fi
  fi
  if [ -z "$pass_name" ] || [ -z "$context" ]; then
    inferred="$(infer_context_and_pass_from_session_name "$session_name" 2>/dev/null || true)"
    if [ -n "$inferred" ]; then
      eval "$inferred"
    fi
  fi

  state="$(read_env_value "$status_file" state 2>/dev/null || true)"
  if [ -z "$state" ] && [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
    state="$(read_env_value "$checkpoint_file" last_event 2>/dev/null || true)"
  fi
  [ -n "$state" ] || state="unknown"

  workdir="$(read_env_value "$status_file" workdir 2>/dev/null || true)"
  [ -n "$workdir" ] || workdir="$(read_env_value "$checkpoint_file" workdir 2>/dev/null || true)"
  [ -n "$workdir" ] || workdir="$AUDIT_REPO_ROOT"

  log_file="$(read_env_value "$status_file" log_file 2>/dev/null || true)"
  [ -n "$log_file" ] || log_file="$(log_path_for "$session_name")"
  command_file="$(read_env_value "$status_file" command_file 2>/dev/null || true)"
  [ -n "$command_file" ] || command_file="$(command_path_for "$session_name")"

  model="$(read_env_value "$status_file" model 2>/dev/null || true)"
  [ -n "$model" ] || model="$(read_env_value "$checkpoint_file" current_model 2>/dev/null || true)"
  provider="$(read_env_value "$status_file" provider 2>/dev/null || true)"
  [ -n "$provider" ] || provider="$(read_env_value "$checkpoint_file" current_provider 2>/dev/null || true)"
  account="$(read_env_value "$status_file" account 2>/dev/null || true)"
  [ -n "$account" ] || account="$(read_env_value "$checkpoint_file" current_account 2>/dev/null || true)"

  created_at="$(read_env_value "$status_file" created_at 2>/dev/null || true)"
  [ -n "$created_at" ] || created_at="$(read_env_value "$checkpoint_file" last_checkpoint_at 2>/dev/null || true)"
  [ -n "$created_at" ] || created_at="$(timestamp_utc)"
  updated_at="$(read_env_value "$status_file" updated_at 2>/dev/null || true)"
  [ -n "$updated_at" ] || updated_at="$(timestamp_utc)"

  upsert_env "$status_file" session_name "$session_name"
  [ -n "$pass_name" ] && upsert_env "$status_file" pass_name "$pass_name"
  [ -n "$context" ] && upsert_env "$status_file" context "$context"
  upsert_env "$status_file" workdir "$workdir"
  upsert_env "$status_file" state "$state"
  [ -n "$model" ] && upsert_env "$status_file" model "$model"
  [ -n "$provider" ] && upsert_env "$status_file" provider "$provider"
  [ -n "$account" ] && upsert_env "$status_file" account "$account"
  upsert_env "$status_file" log_file "$log_file"
  upsert_env "$status_file" command_file "$command_file"
  [ -n "$checkpoint_file" ] && upsert_env "$status_file" checkpoint_file "$checkpoint_file"
  upsert_env "$status_file" created_at "$created_at"
  upsert_env "$status_file" updated_at "$updated_at"
}

status_mark() {
  local file="$1"
  local state="$2"
  upsert_env "$file" state "$state"
  upsert_env "$file" updated_at "$(timestamp_utc)"
}

manual_action_file() {
  printf '%s/manual-action-required.md\n' "$AUDIT_ACCOUNT_ROOT"
}

record_manual_action() {
  local title="$1"
  local detail="$2"
  ensure_audit_dirs
  {
    printf '\n## %s (%s)\n\n' "$title" "$(timestamp_utc)"
    printf -- '- %s\n' "$detail"
  } >>"$(manual_action_file)"
}

record_pass_blocker() {
  local pass_name="$1"
  local context="$2"
  local task_class="$3"
  local state="$4"
  local reason="$5"
  local resume_command="$6"
  local model="${7:-}"
  local provider="${8:-unknown}"
  local account="${9:-unknown}"
  local session_name
  local status_file
  local checkpoint_file
  local now

  ensure_audit_dirs
  session_name="$(session_name_for "$context" "$pass_name")"
  status_file="$(status_path_for "$session_name")"
  checkpoint_file="$(checkpoint_path_for "$session_name")"
  now="$(timestamp_utc)"

  write_env_file "$status_file" \
    session_name "$session_name" \
    pass_name "$pass_name" \
    context "$context" \
    task_class "$task_class" \
    workdir "$AUDIT_REPO_ROOT" \
    state "$state" \
    model "$model" \
    provider "$provider" \
    account "$account" \
    created_at "$now" \
    updated_at "$now" \
    route_reason "$reason" \
    resume_command "$resume_command"

  write_env_file "$checkpoint_file" \
    pass_name "$pass_name" \
    context "$context" \
    session_name "$session_name" \
    last_event "$state" \
    last_checkpoint_at "$now" \
    workdir "$AUDIT_REPO_ROOT" \
    state "$state" \
    stop_reason "$reason" \
    resume_command "$resume_command"
}

caveman_state_file() {
  printf '%s/caveman.status\n' "$AUDIT_STATUS_ROOT"
}

is_caveman_enabled() {
  local file
  file="$(caveman_state_file)"
  [ -f "$file" ] || return 1
  [ "$(read_env_value "$file" enabled 2>/dev/null || true)" = "1" ]
}

arctic_slot_slug() {
  local slot="${1:-default}"
  slugify "$slot"
}

slot_map_field() {
  local slot
  local field_index
  slot="$(arctic_slot_slug "${1:-default}")"
  field_index="${2:-}"
  [ -n "$field_index" ] || return 1
  [ -f "$ARCTIC_SLOT_MAP_FILE" ] || return 1
  awk -F '\t' -v target="$slot" -v col="$field_index" 'NR > 1 && $1 == target { print $col; exit }' "$ARCTIC_SLOT_MAP_FILE"
}

list_slots_from_map() {
  [ -f "$ARCTIC_SLOT_MAP_FILE" ] || return 1
  awk -F '\t' 'NR > 1 && $1 != "" { print $1 }' "$ARCTIC_SLOT_MAP_FILE"
}

list_slot_specs_from_map() {
  [ -f "$ARCTIC_SLOT_MAP_FILE" ] || return 1
  awk -F '\t' 'NR > 1 && $1 != "" && $2 != "" { printf "%s:%s\n", $2, $1 }' "$ARCTIC_SLOT_MAP_FILE"
}

canonical_account_label_for_slot() {
  slot_map_field "$1" 3
}

identity_hint_for_slot() {
  slot_map_field "$1" 4
}

auth_source_key_for_slot() {
  slot_map_field "$1" 5
}

provider_for_slot() {
  local slot
  slot="$(arctic_slot_slug "${1:-default}")"
  if slot_map_field "$slot" 2 >/dev/null 2>&1; then
    slot_map_field "$slot" 2
    return 0
  fi
  case "$slot" in
    anthropic-*) printf 'anthropic' ;;
    antigravity-*) printf 'antigravity' ;;
    codex-*) printf 'codex' ;;
    google-*) printf 'google' ;;
    copilot-*) printf 'github-copilot' ;;
    *) return 1 ;;
  esac
}

arctic_slot_data_home() {
  local slot
  slot="$(arctic_slot_slug "${1:-default}")"
  printf '%s/%s/data\n' "$ARCTIC_SLOT_DATA_ROOT" "$slot"
}

arctic_slot_config_home() {
  local slot
  slot="$(arctic_slot_slug "${1:-default}")"
  printf '%s/%s/config\n' "$ARCTIC_SLOT_CONFIG_ROOT" "$slot"
}

ensure_arctic_slot_dirs() {
  local slot="${1:-default}"
  mkdir -p \
    "$(arctic_slot_data_home "$slot")" \
    "$(arctic_slot_config_home "$slot")"
}

run_arctic_for_slot() {
  local slot="${1:-default}"
  shift || true
  ensure_arctic_slot_dirs "$slot"
  XDG_DATA_HOME="$(arctic_slot_data_home "$slot")" \
  XDG_CONFIG_HOME="$(arctic_slot_config_home "$slot")" \
  ARCTIC_SLOT_ID="$(arctic_slot_slug "$slot")" \
    arctic "$@"
}

provider_model_slug() {
  local provider="${1:-}"
  local model="${2:-}"
  if [ -z "$model" ]; then
    printf ''
    return 0
  fi
  case "$model" in
    */*)
      printf '%s' "${model#*/}"
      ;;
    *)
      printf '%s' "$model"
      ;;
  esac
}

provider_model_ref() {
  local provider="${1:-}"
  local model="${2:-}"
  local slug=""
  slug="$(provider_model_slug "$provider" "$model")"
  if [ -z "$slug" ]; then
    printf ''
  elif [ -z "$provider" ] || [ "$provider" = "native-codex" ]; then
    printf '%s' "$slug"
  else
    printf '%s/%s' "$provider" "$slug"
  fi
}

provider_model_rank() {
  local provider="${1:-}"
  local model="${2:-}"
  model="$(provider_model_slug "$provider" "$model")"
  case "$provider" in
    anthropic)
      case "$model" in
        claude-opus-4.6|claude-opus-4-6) printf '100' ;;
        claude-opus-4.5|claude-opus-4-5|claude-opus-4-5-thinking) printf '98' ;;
        claude-sonnet-4.6|claude-sonnet-4-6) printf '94' ;;
        claude-sonnet-4.5|claude-sonnet-4-5|claude-sonnet-4-5-thinking) printf '92' ;;
        claude-haiku-4.5|claude-haiku-4-5|claude-haiku-4-5-20251001) printf '86' ;;
        claude-3.7-sonnet|claude-3-7-sonnet|claude-3-7-sonnet-20250219) printf '88' ;;
        *) printf '0' ;;
      esac
      ;;
    antigravity)
      case "$model" in
        claude-opus-4.6|claude-opus-4-6) printf '100' ;;
        claude-opus-4.5|claude-opus-4-5|claude-opus-4-5-thinking) printf '98' ;;
        claude-sonnet-4.6|claude-sonnet-4-6) printf '94' ;;
        claude-sonnet-4.5|claude-sonnet-4-5|claude-sonnet-4-5-thinking) printf '92' ;;
        gpt-5.4) printf '100' ;;
        gpt-5.4-mini) printf '96' ;;
        gpt-5.3-codex) printf '92' ;;
        gemini-3.1-pro-preview) printf '96' ;;
        gemini-3.1-pro-preview-customtools) printf '94' ;;
        gemini-3-pro-preview) printf '93' ;;
        gemini-3-flash) printf '92' ;;
        gemini-3-pro-high) printf '90' ;;
        gemini-3-pro-low) printf '88' ;;
        gpt-5.2-codex) printf '88' ;;
        gpt-5.2) printf '86' ;;
        *) printf '0' ;;
      esac
      ;;
    codex)
      case "$model" in
        gpt-5.4) printf '100' ;;
        gpt-5.4-mini) printf '96' ;;
        gpt-5.3-codex) printf '92' ;;
        gpt-5.2-codex) printf '88' ;;
        gpt-5.2) printf '86' ;;
        gpt-5.1-codex-max) printf '82' ;;
        gpt-5.1-codex) printf '80' ;;
        gpt-5.1-codex-mini) printf '74' ;;
        *) printf '0' ;;
      esac
      ;;
    google)
      case "$model" in
        gemini-3.1-pro-preview) printf '100' ;;
        gemini-3.1-pro-preview-customtools) printf '98' ;;
        gemini-3-pro-preview) printf '94' ;;
        gemini-2.5-pro) printf '90' ;;
        gemini-2.5-pro-preview-06-05) printf '88' ;;
        gemini-2.5-pro-preview-05-06) printf '86' ;;
        gemini-1.5-pro) printf '60' ;;
        *) printf '0' ;;
      esac
      ;;
    github-copilot)
      case "$model" in
        gpt-5.4) printf '100' ;;
        claude-opus-4.6) printf '98' ;;
        claude-opus-4.5) printf '96' ;;
        gpt-5.4-mini) printf '94' ;;
        gpt-5.3-codex) printf '92' ;;
        gemini-3.1-pro-preview) printf '90' ;;
        gemini-3-pro-preview) printf '88' ;;
        gemini-2.5-pro) printf '86' ;;
        claude-sonnet-4.6) printf '84' ;;
        claude-sonnet-4.5) printf '82' ;;
        *) printf '0' ;;
      esac
      ;;
    *)
      printf '0' ;;
  esac
}

minimum_execution_rank_for_provider() {
  local provider="${1:-}"
  case "$provider" in
    anthropic) printf '92' ;;
    antigravity) printf '92' ;;
    codex) printf '92' ;;
    google) printf '90' ;;
    github-copilot) printf '86' ;;
    *) printf '0' ;;
  esac
}

provider_execution_probe_candidates() {
  local provider="${1:-}"
  case "$provider" in
    anthropic)
      printf '%s\n' \
        claude-haiku-4-5 \
        claude-sonnet-4-5 \
        claude-sonnet-4-6 \
        claude-opus-4-6 \
        claude-opus-4-5 \
        claude-opus-4-1 \
        claude-3-7-sonnet-20250219
      ;;
    antigravity)
      printf '%s\n' \
        claude-opus-4.6 \
        claude-opus-4.5 \
        claude-opus-4-5-thinking \
        claude-sonnet-4.6 \
        claude-sonnet-4.5 \
        claude-sonnet-4-5-thinking \
        gemini-3-flash \
        gemini-3.1-pro-preview \
        gemini-3.1-pro-preview-customtools \
        gemini-3-pro-preview \
        gpt-5.4 \
        gpt-5.4-mini \
        gpt-5.3-codex \
        gemini-3-pro-high \
        gemini-3-pro-low
      ;;
    codex)
      printf '%s\n' \
        gpt-5.4 \
        gpt-5.4-mini \
        gpt-5.3-codex
      ;;
    google)
      printf '%s\n' \
        gemini-3.1-pro-preview \
        gemini-3-pro-preview \
        gemini-2.5-pro
      ;;
    github-copilot)
      printf '%s\n' \
        gpt-5.4 \
        gemini-3.1-pro-preview \
        gpt-4.1 \
        gpt-5.4-mini
      ;;
    *)
      return 1
      ;;
  esac
}

arctic_auth_list_output() {
  local slot="${1:-}"
  command -v arctic >/dev/null 2>&1 || return 1
  if [ -n "$slot" ]; then
    run_arctic_for_slot "$slot" auth list 2>/dev/null || true
  else
    arctic auth list 2>/dev/null || true
  fi
}

arctic_has_credentials() {
  local slot="${1:-}"
  local output
  output="$(arctic_auth_list_output "$slot")"
  [ -n "$output" ] || return 1
  ! printf '%s' "$output" | grep -q '0 credentials'
}

account_snapshot_dir_for_slot() {
  local slot
  slot="$(arctic_slot_slug "${1:-default}")"
  printf '%s/%s\n' "$AUDIT_ACCOUNT_SNAPSHOT_ROOT" "$slot"
}

switch_history_file() {
  printf '%s/switch-history.md\n' "$AUDIT_ACCOUNT_ROOT"
}

escape_md_table_cell() {
  local value="${1:-}"
  printf '%s' "$value" | tr '\n' ' ' | sed -e 's/|/\\|/g' -e 's/[[:space:]][[:space:]]*/ /g'
}

append_switch_history() {
  local from_context
  local to_context
  local reason
  local status
  local file

  from_context="$(escape_md_table_cell "${1:-unknown}")"
  to_context="$(escape_md_table_cell "${2:-unknown}")"
  reason="$(escape_md_table_cell "${3:-unspecified}")"
  status="$(escape_md_table_cell "${4:-Recorded}")"
  file="$(switch_history_file)"

  ensure_audit_dirs
  if [ ! -f "$file" ]; then
    {
      printf '# Switch History\n\n'
      printf '| Date | From | To | Reason | Status |\n'
      printf '| --- | --- | --- | --- | --- |\n'
    } >"$file"
  fi

  printf '| %s | %s | %s | %s | %s |\n' \
    "$(timestamp_utc)" \
    "$from_context" \
    "$to_context" \
    "$reason" \
    "$status" >>"$file"
}

rotation_cursor_file_for() {
  local provider
  provider="$(slugify "${1:-provider}")"
  printf '%s/provider-rotation-%s.state\n' "$AUDIT_STATUS_ROOT" "$provider"
}

read_rotation_cursor() {
  local provider
  local file
  provider="${1:-}"
  [ -n "$provider" ] || return 1
  file="$(rotation_cursor_file_for "$provider")"
  [ -f "$file" ] || return 1
  read_env_value "$file" last_slot
}

write_rotation_cursor() {
  local provider
  local slot
  local file

  provider="${1:-}"
  slot="${2:-}"
  [ -n "$provider" ] || return 1
  [ -n "$slot" ] || return 1

  file="$(rotation_cursor_file_for "$provider")"
  ensure_audit_dirs
  write_env_file "$file" \
    provider "$provider" \
    last_slot "$slot" \
    updated_at "$(timestamp_utc)"
}

mark_slot_route_selected() {
  local slot="${1:-}"
  local pass_name="${2:-}"
  local provider="${3:-}"
  local account="${4:-}"
  local model="${5:-}"
  local status_file=""

  [ -n "$slot" ] || return 0
  status_file="$(status_path_for_slot "$slot")"
  [ -f "$status_file" ] || return 0
  upsert_env "$status_file" route_last_selected_at "$(timestamp_utc)"
  [ -n "$pass_name" ] && upsert_env "$status_file" route_last_selected_pass "$pass_name"
  [ -n "$provider" ] && upsert_env "$status_file" route_last_selected_provider "$provider"
  [ -n "$account" ] && upsert_env "$status_file" route_last_selected_account "$account"
  [ -n "$model" ] && upsert_env "$status_file" route_last_selected_model "$model"
  upsert_env "$status_file" updated_at "$(timestamp_utc)"
}

status_path_for_slot() {
  local slot
  slot="$(arctic_slot_slug "${1:-default}")"
  printf '%s/arctic-slot-%s.status\n' "$AUDIT_STATUS_ROOT" "$slot"
}

provider_health_file_for() {
  local provider
  provider="$(slugify "${1:-provider}")"
  printf '%s/route-health-%s.status\n' "$AUDIT_STATUS_ROOT" "$provider"
}

iso_to_epoch() {
  local iso="${1:-}"
  [ -n "$iso" ] || return 1
  date -d "$iso" +%s 2>/dev/null
}

cooldown_active_in_file() {
  local file="${1:-}"
  local cooldown_state=""
  local next_eligible_at=""
  local next_epoch=""
  local now_epoch=""

  [ -n "$file" ] || return 1
  [ -f "$file" ] || return 1
  cooldown_state="$(read_env_value "$file" cooldown_state 2>/dev/null || true)"
  [ "$cooldown_state" != "clear" ] || return 1
  next_eligible_at="$(read_env_value "$file" cooldown_next_eligible_at 2>/dev/null || true)"
  [ -n "$next_eligible_at" ] || next_eligible_at="$(read_env_value "$file" usage_limit_primary_reset_at 2>/dev/null || true)"
  [ -n "$next_eligible_at" ] || return 1
  next_epoch="$(iso_to_epoch "$next_eligible_at" 2>/dev/null || true)"
  [ -n "$next_epoch" ] || return 1
  now_epoch="$(date +%s)"
  [ "$next_epoch" -gt "$now_epoch" ]
}

set_cooldown_in_file() {
  local file="${1:-}"
  local state="${2:-cooling-down}"
  local reason="${3:-}"
  local next_eligible_at="${4:-}"
  local source="${5:-observed}"

  [ -n "$file" ] || return 1
  touch "$file"
  upsert_env "$file" cooldown_state "$state"
  upsert_env "$file" cooldown_reason "$reason"
  upsert_env "$file" cooldown_next_eligible_at "$next_eligible_at"
  upsert_env "$file" cooldown_source "$source"
  upsert_env "$file" cooldown_updated_at "$(timestamp_utc)"
}

clear_cooldown_in_file() {
  local file="${1:-}"
  [ -n "$file" ] || return 1
  touch "$file"
  upsert_env "$file" cooldown_state "clear"
  upsert_env "$file" cooldown_reason ""
  upsert_env "$file" cooldown_next_eligible_at ""
  upsert_env "$file" cooldown_source ""
  upsert_env "$file" cooldown_updated_at "$(timestamp_utc)"
}

update_slot_execution_route_state() {
  local file="${1:-}"
  local provider=""
  local usage_access_status=""
  local execution_verification_state=""
  local execution_last_probe_failure_class=""
  local execution_model=""
  local execution_route_state="unverified"
  local execution_route_reason=""
  local model_rank="0"
  local min_rank="0"

  [ -n "$file" ] || return 1
  [ -f "$file" ] || return 1

  provider="$(read_env_value "$file" provider 2>/dev/null || true)"
  usage_access_status="$(read_env_value "$file" usage_access_status 2>/dev/null || true)"
  execution_verification_state="$(read_env_value "$file" execution_verification_state 2>/dev/null || true)"
  execution_last_probe_failure_class="$(read_env_value "$file" execution_last_probe_failure_class 2>/dev/null || true)"
  execution_model="$(read_env_value "$file" execution_model 2>/dev/null || true)"
  model_rank="$(provider_model_rank "$provider" "$execution_model")"
  min_rank="$(minimum_execution_rank_for_provider "$provider")"

  if printf '%s' "$usage_access_status" | grep -Eqi 'blocked|limit reached'; then
    execution_route_state="quota-blocked"
    execution_route_reason="${usage_access_status:-Provider usage view reported the slot as blocked.}"
  elif cooldown_active_in_file "$file"; then
    execution_route_state="cooling-down"
    execution_route_reason="$(read_env_value "$file" cooldown_reason 2>/dev/null || true)"
  elif [ "$execution_verification_state" = "verified" ] && [ "$model_rank" -ge "$min_rank" ]; then
    execution_route_state="verified"
    execution_route_reason="Execution smoke is verified on ${execution_model:-a supported model}."
  elif [ "$execution_verification_state" = "verified" ] && [ "$model_rank" -lt "$min_rank" ]; then
    execution_route_state="below-model-floor"
    execution_route_reason="Execution model '${execution_model:-unknown}' is below the enforced floor for provider '${provider:-unknown}'."
  elif [ "$execution_last_probe_failure_class" = "provider-rejected" ]; then
    execution_route_state="provider-rejected"
    execution_route_reason="Provider rejected the last execution probe."
  elif [ "$execution_last_probe_failure_class" = "provider-unavailable" ]; then
    execution_route_state="provider-unavailable"
    execution_route_reason="Provider is unavailable in the current Arctic build for this slot."
  elif [ "$execution_last_probe_failure_class" = "quota-blocked" ]; then
    execution_route_state="quota-blocked"
    execution_route_reason="Last execution probe hit a quota or usage limit."
  elif [ "$execution_last_probe_failure_class" = "auth-or-entitlement" ]; then
    execution_route_state="auth-or-entitlement"
    execution_route_reason="Last execution probe failed for auth or entitlement reasons."
  elif [ "$execution_last_probe_failure_class" = "exit-clean-no-output" ]; then
    execution_route_state="silent-provider-failure"
    execution_route_reason="Provider exited cleanly without returning the expected marker."
  elif [ -n "$execution_last_probe_failure_class" ]; then
    execution_route_state="$execution_last_probe_failure_class"
    execution_route_reason="Last execution probe failed with class '${execution_last_probe_failure_class}'."
  fi

  upsert_env "$file" execution_route_state "$execution_route_state"
  upsert_env "$file" execution_route_reason "$execution_route_reason"
  upsert_env "$file" execution_route_updated_at "$(timestamp_utc)"
}

any_arctic_slot_authenticated() {
  local status_file
  for status_file in "$AUDIT_STATUS_ROOT"/arctic-slot-*.status; do
    [ -f "$status_file" ] || continue
    # shellcheck disable=SC1090
    source "$status_file"
    if [ "${state:-}" = "authenticated" ] || [ "${state:-}" = "models-verified" ]; then
      return 0
    fi
  done
  return 1
}

join_command() {
  local command=""
  printf -v command '%q ' "$@"
  printf '%s' "${command% }"
}

kill_process_tree() {
  local pid="${1:-}"
  local signal="${2:-TERM}"
  local child=""
  [ -n "$pid" ] || return 0
  kill -0 "$pid" 2>/dev/null || return 0
  while IFS= read -r child; do
    [ -n "$child" ] || continue
    kill_process_tree "$child" "$signal"
  done < <(pgrep -P "$pid" 2>/dev/null || true)
  kill "-$signal" "$pid" 2>/dev/null || true
}

require_tmux() {
  local probe_output=""
  local probe_rc="0"
  if ! command -v tmux >/dev/null 2>&1; then
    record_manual_action "tmux missing" "Install tmux, then rerun the detached job wrapper."
    echo "tmux is required for detached audit runs." >&2
    exit 69
  fi
  set +e
  probe_output="$(tmux ls 2>&1 >/dev/null)"
  probe_rc="$?"
  set -e
  if [ "$probe_rc" -ne 0 ] && printf '%s\n' "$probe_output" | grep -Eqi 'Operation not permitted|Permission denied'; then
    record_manual_action "tmux access denied" "The current shell cannot access the tmux socket. Re-run the tmux wrapper from a shell with real user-session tmux access."
    echo "tmux is installed, but this shell cannot access the tmux socket." >&2
    exit 69
  fi
}

tmux_session_state() {
  local session_name="${1:-}"
  local probe_output=""
  local probe_rc="0"

  [ -n "$session_name" ] || {
    printf 'missing'
    return 1
  }
  command -v tmux >/dev/null 2>&1 || {
    printf 'unavailable'
    return 2
  }

  set +e
  probe_output="$(tmux has-session -t "$session_name" 2>&1)"
  probe_rc="$?"
  set -e

  if [ "$probe_rc" -eq 0 ]; then
    printf 'present'
    return 0
  fi
  if printf '%s\n' "$probe_output" | grep -Eqi 'Operation not permitted|Permission denied'; then
    printf 'inaccessible'
    return 2
  fi
  printf 'missing'
  return 1
}

tmux_session_present() {
  local session_name="${1:-}"
  local session_state=""
  session_state="$(tmux_session_state "$session_name" 2>/dev/null || true)"
  [ "$session_state" = "present" ]
}

tmux_session_idle_shell() {
  local session_name="${1:-}"
  local pane_command=""
  local pane_start_command=""

  [ -n "$session_name" ] || return 1
  tmux_session_present "$session_name" || return 1

  pane_command="$(tmux list-panes -t "$session_name" -F '#{pane_current_command}' 2>/dev/null | head -n 1 || true)"
  pane_start_command="$(tmux list-panes -t "$session_name" -F '#{pane_start_command}' 2>/dev/null | head -n 1 || true)"

  case "${pane_command:-}" in
    zsh|bash|sh|fish)
      [ -z "${pane_start_command:-}" ]
      ;;
    *)
      return 1
      ;;
  esac
}

reconcile_status_with_tmux() {
  local status_file="$1"
  local checkpoint_file="${2:-}"
  local session_state=""
  local session_name=""
  local state=""
  local exit_code=""
  local supervisor_state=""
  local last_execution_failure_class=""
  local terminal_failure="0"
  [ -f "$status_file" ] || return 0
  repair_session_status_file "$status_file" "$checkpoint_file" || return 0

  session_name="$(read_env_value "$status_file" session_name 2>/dev/null || true)"
  state="$(read_env_value "$status_file" state 2>/dev/null || true)"
  exit_code="$(read_env_value "$status_file" exit_code 2>/dev/null || true)"
  supervisor_state="$(read_env_value "$status_file" execution_supervisor_state 2>/dev/null || true)"
  last_execution_failure_class="$(read_env_value "$status_file" last_execution_failure_class 2>/dev/null || true)"
  session_state="$(tmux_session_state "${session_name:-}" 2>/dev/null || true)"
  if [ -n "${last_execution_failure_class:-}" ] || { [ -n "${exit_code:-}" ] && [ "${exit_code:-}" != "0" ]; }; then
    terminal_failure="1"
  fi

  case "${state:-unknown}" in
    stale)
      case "$session_state" in
        present)
          status_mark "$status_file" running
          upsert_env "$status_file" recovered_from_stale_at "$(timestamp_utc)"
          upsert_env "$status_file" tmux_visibility "present"
          if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
            upsert_env "$checkpoint_file" last_event "running"
            upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
          fi
          ;;
        missing)
          if [ "$terminal_failure" = "1" ]; then
            status_mark "$status_file" failed
            upsert_env "$status_file" finished_at "$(timestamp_utc)"
            upsert_env "$status_file" tmux_visibility "missing"
            if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
              upsert_env "$checkpoint_file" last_event "failed"
              upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
            fi
          elif [ "${exit_code:-}" = "0" ] || [ "${supervisor_state:-}" = "completed" ]; then
            status_mark "$status_file" completed
            upsert_env "$status_file" finished_at "$(timestamp_utc)"
            upsert_env "$status_file" tmux_visibility "missing"
            if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
              upsert_env "$checkpoint_file" last_event "completed"
              upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
            fi
          fi
          ;;
        inaccessible|unavailable|'')
          upsert_env "$status_file" tmux_visibility "inaccessible"
          ;;
      esac
      ;;
    queued|starting|running)
      case "$session_state" in
        present)
          upsert_env "$status_file" tmux_visibility "present"
          ;;
        inaccessible|unavailable|'')
          upsert_env "$status_file" tmux_visibility "inaccessible"
          ;;
        missing)
          if [ "$terminal_failure" = "1" ]; then
            status_mark "$status_file" failed
            upsert_env "$status_file" finished_at "$(timestamp_utc)"
            upsert_env "$status_file" tmux_visibility "missing"
            if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
              upsert_env "$checkpoint_file" last_event "failed"
              upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
            fi
          elif [ "${exit_code:-}" = "0" ] || [ "${supervisor_state:-}" = "completed" ]; then
            status_mark "$status_file" completed
            upsert_env "$status_file" finished_at "$(timestamp_utc)"
            upsert_env "$status_file" tmux_visibility "missing"
            if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
              upsert_env "$checkpoint_file" last_event "completed"
              upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
            fi
          else
            status_mark "$status_file" stale
            upsert_env "$status_file" finished_at "$(timestamp_utc)"
            upsert_env "$status_file" tmux_visibility "missing"
            if [ -n "$checkpoint_file" ] && [ -f "$checkpoint_file" ]; then
              upsert_env "$checkpoint_file" last_event "stale"
              upsert_env "$checkpoint_file" last_checkpoint_at "$(timestamp_utc)"
            fi
          fi
          ;;
      esac
      ;;
  esac
}
