#!/usr/bin/env bash
# Launch the task-runner as a prime agent for the given TASK-###.
# The task-runner writes its result to state/queues/task-runner-reports/TASK-###.yaml.
#
# Usage: ./scripts/run-task.sh TASK-042

set -euo pipefail

TASK_ID="${1:-}"

if [[ -z "$TASK_ID" ]]; then
  echo "Usage: $0 TASK-###" >&2
  exit 1
fi

if [[ ! "$TASK_ID" =~ ^TASK-[0-9]+$ ]]; then
  echo "Error: invalid task ID '$TASK_ID' — expected format TASK-###" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Locate the task file — name may include a title slug after the ID
TASK_FILE=$(find "$REPO_ROOT/wiki/tasks/ready" -maxdepth 1 \
  \( -name "${TASK_ID}.md" -o -name "${TASK_ID}-*.md" \) 2>/dev/null | head -1)

if [[ -z "$TASK_FILE" ]]; then
  echo "Error: no ready task file found for $TASK_ID in wiki/tasks/ready/" >&2
  exit 1
fi

ROLE_FILE="$REPO_ROOT/.claude/agents/task-runner.md"

if [[ ! -f "$ROLE_FILE" ]]; then
  echo "Error: task-runner role file not found at $ROLE_FILE" >&2
  exit 1
fi

RESULT_FILE="$REPO_ROOT/state/queues/task-runner-reports/${TASK_ID}.yaml"
CODE_ROOT="$REPO_ROOT/worktree-set"

# Strip YAML frontmatter from the role file (frontmatter is agent registry metadata,
# not prompt content; it also starts with --- which the CLI misparses as flags).
ROLE_BODY=$(awk 'BEGIN{n=0} /^---/{n++; if(n==2){body=1}; next} body{print}' "$ROLE_FILE")

# Compose the prompt: role body followed by the task pointer
PROMPT="${ROLE_BODY}

---

Your target task is: $TASK_ID
Task file path: $TASK_FILE

Wiki root (for wiki/, state/, raw/): $REPO_ROOT
Code root (all target repos live here — never look outside this): $CODE_ROOT

Repos available under code root:
  TBD  → $CODE_ROOT/TBD

Begin the pre-session checklist now."

echo "Launching task-runner for $TASK_ID..."
echo "Task file: $TASK_FILE"
echo ""

cd "$REPO_ROOT"
printf '%s\n' "$PROMPT" | claude --model sonnet -p --dangerously-skip-permissions
EXIT_CODE=$?

echo ""
if [[ -f "$RESULT_FILE" ]]; then
  echo "=== Task Runner Result ==="
  cat "$RESULT_FILE"
else
  echo "Warning: result file not written at $RESULT_FILE" >&2
fi

exit $EXIT_CODE
