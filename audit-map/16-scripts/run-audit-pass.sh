#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_audit-common.sh"

usage() {
  echo "Usage: $0 <pass-name> [--context <context>] [--prompt-file <file>] [--task-class <class>] [--model <slug>] [--reasoning-effort <low|medium|high|xhigh>] [--search 0|1] [--extra-instruction <text>] [--provider-mode <native-only|auto>] [--require-provider <provider>] [--wait-for-provider 0|1] [--wait-timeout-seconds <n>] [--wait-poll-seconds <n>]" >&2
  exit 64
}

pass_name="${1:-}"
[ -n "$pass_name" ] || usage
shift || true

context="local"
prompt_file=""
task_class_override=""
model=""
reasoning_override=""
search_override=""
extra_instruction=""
provider_mode="auto"
require_provider=""
wait_for_provider="0"
wait_timeout_seconds="1800"
wait_poll_seconds="60"
max_route_attempts="${AUDIT_MAX_ROUTE_ATTEMPTS:-0}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --context) context="${2:-}"; shift 2 ;;
    --prompt-file) prompt_file="${2:-}"; shift 2 ;;
    --task-class) task_class_override="${2:-}"; shift 2 ;;
    --model) model="${2:-}"; shift 2 ;;
    --reasoning-effort) reasoning_override="${2:-}"; shift 2 ;;
    --search) search_override="${2:-}"; shift 2 ;;
    --extra-instruction) extra_instruction="${2:-}"; shift 2 ;;
    --provider-mode) provider_mode="${2:-}"; shift 2 ;;
    --require-provider) require_provider="${2:-}"; shift 2 ;;
    --wait-for-provider) wait_for_provider="${2:-}"; shift 2 ;;
    --wait-timeout-seconds) wait_timeout_seconds="${2:-}"; shift 2 ;;
    --wait-poll-seconds) wait_poll_seconds="${2:-}"; shift 2 ;;
    *) usage ;;
  esac
done

eval "$("$SCRIPT_DIR/task-classify-route.sh" "$pass_name")"
task_class="${task_class_override:-$task_class}"
model="${model:-$recommended_model}"
reasoning_effort="${reasoning_override:-$reasoning_effort}"
enable_web_search="${search_override:-$enable_web_search}"
caveman_active="0"
caveman_mode="off"
caveman_force_all="0"
selected_account_label=""
session_name="$(session_name_for "$context" "$pass_name")"

if is_caveman_enabled; then
  caveman_force_all="$(read_env_value "$(caveman_state_file)" force_all 2>/dev/null || printf '0')"
fi

if is_caveman_enabled && { [ "$caveman_force_all" = "1" ] || { [ "$supports_caveman" = "1" ] && [ "$risk_class" != "high" ]; }; }; then
  caveman_active="1"
  caveman_mode="$(read_env_value "$(caveman_state_file)" mode 2>/dev/null || printf 'full')"
fi

if [ "$caveman_active" = "1" ]; then
  set +e
  caveman_verify_output="$(bash "$SCRIPT_DIR/verify-caveman-all-paths.sh" --expected-mode "$caveman_mode" 2>&1)"
  caveman_verify_rc="$?"
  set -e
  if [ "$caveman_verify_rc" -ne 0 ]; then
    record_manual_action "Caveman deterministic verification failed" "Pass '$pass_name' requested caveman mode '$caveman_mode' but one or more required paths are not configured. Run 'bash audit-map/16-scripts/caveman-enable-everywhere.sh $caveman_mode' and retry."
    printf '%s\n' "$caveman_verify_output" >&2
    exit 65
  fi
fi

eval "$("$SCRIPT_DIR/check-model-budget.sh" "$pass_name" "$model")"
if [ "$budget_state" = "stop" ]; then
  resume_command="bash audit-map/16-scripts/run-audit-pass.sh $pass_name --context $context --model $model --reasoning-effort $reasoning_effort"
  record_pass_blocker "$pass_name" "$context" "$task_class" "manual_action_required" "$note" "$resume_command" "$model" "native-codex" "native-codex-session"
  bash "$SCRIPT_DIR/emit-cost-warning.sh" "$note"
  exit 65
fi

[ "$budget_state" = "warn" ] && bash "$SCRIPT_DIR/emit-cost-warning.sh" "$note"

selected_provider="native-codex"
selected_slot=""
selected_account="native-codex-session"
route_args=(bash "$SCRIPT_DIR/select-execution-route.sh" "$pass_name")
[ -n "$model" ] && route_args+=(--requested-model "$model")
[ -n "$require_provider" ] && route_args+=(--require-provider "$require_provider")

if [ "$provider_mode" = "auto" ] || [ -n "$require_provider" ]; then
  if [ "$wait_for_provider" = "1" ]; then
    wait_args=(bash "$SCRIPT_DIR/wait-for-provider-readiness.sh" "$pass_name" --timeout-seconds "$wait_timeout_seconds" --poll-seconds "$wait_poll_seconds")
    [ -n "$model" ] && wait_args+=(--requested-model "$model")
    [ -n "$require_provider" ] && wait_args+=(--require-provider "$require_provider")
    set +e
    route_output="$("${wait_args[@]}")"
    route_rc="$?"
    set -e
    eval "$route_output"
    if [ "$route_rc" -ne 0 ] && [ "${route_state:-manual_required}" != "ready" ]; then
      resume_command="bash audit-map/16-scripts/select-execution-route.sh $pass_name${model:+ --requested-model $model}${require_provider:+ --require-provider $require_provider}"
      record_pass_blocker "$pass_name" "$context" "$task_class" "manual_action_required" "${route_reason:-Execution route not ready}" "$resume_command" "$model" "${selected_provider:-unknown}" "${selected_account:-unknown}"
      record_manual_action "Execution route not ready" "Pass '$pass_name' could not start automatically. Reason: ${route_reason:-unknown}. Resume with '$resume_command'."
      exit 65
    fi
  else
    eval "$("${route_args[@]}")"
    if [ "$route_state" != "ready" ]; then
      resume_command="bash audit-map/16-scripts/select-execution-route.sh $pass_name${model:+ --requested-model $model}${require_provider:+ --require-provider $require_provider}"
      record_pass_blocker "$pass_name" "$context" "$task_class" "manual_action_required" "$route_reason" "$resume_command" "$model" "${selected_provider:-unknown}" "${selected_account:-unknown}"
      record_manual_action "Execution route not ready" "Pass '$pass_name' could not start automatically. Reason: $route_reason. Run '$resume_command'."
      exit 65
    fi
  fi
  selected_provider="${selected_provider:-native-codex}"
  model="${selected_model:-$model}"
fi

prompt_file="${prompt_file:-$AUDIT_MAP_ROOT/20-prompts/${pass_name}.md}"
[ -f "$prompt_file" ] || { echo "Prompt file not found: $prompt_file" >&2; exit 66; }
bootstrap_prompt="$AUDIT_MAP_ROOT/20-prompts/environment/main-analysis-agent-bootstrap.md"
[ -f "$bootstrap_prompt" ] || { echo "Bootstrap prompt not found: $bootstrap_prompt" >&2; exit 66; }
closure_prompt="$AUDIT_MAP_ROOT/20-prompts/exhaustive-closure-campaign.md"
[ -f "$closure_prompt" ] || { echo "Closure prompt not found: $closure_prompt" >&2; exit 66; }
absolute_closure_prompt="$AUDIT_MAP_ROOT/20-prompts/absolute-forensic-closure-campaign.md"
[ -f "$absolute_closure_prompt" ] || { echo "Absolute closure prompt not found: $absolute_closure_prompt" >&2; exit 66; }
validation_prompt="$AUDIT_MAP_ROOT/20-prompts/adversarial-validation-campaign.md"
include_validation_prompt="0"
case "$pass_name" in
  claim-verification-pass|unknown-omission-pass|residual-gap-closure-pass|closure-readiness-pass)
    include_validation_prompt="1"
    [ -f "$validation_prompt" ] || { echo "Validation prompt not found: $validation_prompt" >&2; exit 66; }
    ;;
esac

prompt_bundle="$(prompt_bundle_path_for "$session_name")"
last_message_file="$(last_message_path_for "$session_name")"
status_file="$(status_path_for "$session_name")"
checkpoint_file="$(checkpoint_path_for "$session_name")"

{
  printf 'AirMentor audit OS pass: %s\n\n' "$pass_name"
  printf 'Read these files first:\n'
  printf -- '- audit-map/index.md\n'
  printf -- '- audit-map/24-agent-memory/known-facts.md\n'
  printf -- '- audit-map/14-reconciliation/contradiction-matrix.md\n'
  printf -- '- audit-map/23-coverage/coverage-ledger.md\n\n'
  printf 'Pass context:\n'
  printf -- '- context: %s\n' "$context"
  printf -- '- task class: %s\n' "$task_class"
  printf -- '- risk class: %s\n' "$risk_class"
  printf -- '- model: %s\n' "$model"
  printf -- '- reasoning effort: %s\n\n' "$reasoning_effort"
  printf -- '- execution provider: %s\n' "$selected_provider"
  printf -- '- execution account: %s\n' "$selected_account"
  printf -- '- execution account label: %s\n' "${selected_account_label:-n/a}"
  printf -- '- execution slot: %s\n\n' "${selected_slot:-native}"
  if [ "$caveman_active" = "1" ]; then
    printf 'Caveman policy is active for this pass in mode `%s`. Use only low-risk terseness; technical accuracy, evidence capture, and file updates remain mandatory.\n\n' "$caveman_mode"
  fi
  if [ -n "$extra_instruction" ]; then
    printf 'Extra instruction:\n%s\n\n' "$extra_instruction"
  fi
  printf 'Always persist important results into audit-map files before ending.\n\n'
  cat "$bootstrap_prompt"
  printf '\n\n'
  cat "$closure_prompt"
  printf '\n\n'
  cat "$absolute_closure_prompt"
  printf '\n\n'
  if [ "$include_validation_prompt" = "1" ]; then
    cat "$validation_prompt"
    printf '\n\n'
  fi
  cat "$prompt_file"
  printf '\n'
} >"$prompt_bundle"

execution_args=(
  bash "$SCRIPT_DIR/execute-pass-with-failover.sh"
  --pass "$pass_name"
  --context "$context"
  --prompt-bundle "$prompt_bundle"
  --last-message-file "$last_message_file"
  --provider "$selected_provider"
  --account "$selected_account"
  --model "$model"
  --reasoning-effort "$reasoning_effort"
  --search "$enable_web_search"
  --provider-mode "$provider_mode"
  --wait-timeout-seconds "$wait_timeout_seconds"
  --wait-poll-seconds "$wait_poll_seconds"
  --max-attempts "$max_route_attempts"
  --status-file "$status_file"
  --checkpoint-file "$checkpoint_file"
)
[ -n "$selected_slot" ] && execution_args+=(--slot "$selected_slot")
[ -n "$require_provider" ] && execution_args+=(--require-provider "$require_provider")
command_string="$(join_command "${execution_args[@]}")"

launch_output="$(
  bash "$SCRIPT_DIR/tmux-start-job.sh" \
    --pass "$pass_name" \
    --context "$context" \
    --task-class "$task_class" \
    --workdir "$AUDIT_REPO_ROOT" \
    --model "$model" \
    --provider "$selected_provider" \
    --account "$selected_account" \
    --caveman-active "$caveman_active" \
    --caveman-mode "$caveman_mode" \
    --command "$command_string"
)"
printf '%s\n' "$launch_output"

if [ "$selected_provider" = "native-codex" ]; then
  write_rotation_cursor "$selected_provider" "${selected_account:-native-codex-session}" || true
elif [ -n "${selected_slot:-}" ]; then
  write_rotation_cursor "$selected_provider" "$selected_slot" || true
  write_rotation_cursor "alternate-global" "$selected_slot" || true
  mark_slot_route_selected "$selected_slot" "$pass_name" "$selected_provider" "$selected_account" "$model" || true
  append_switch_history "native-codex:native-codex-session" "${selected_provider}:${selected_slot}" "Pass '$pass_name' started on a verified alternate route. ${route_reason:-Selected alternate route.}" "Started"
fi
