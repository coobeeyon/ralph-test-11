#!/usr/bin/env bash
# Summarize the latest run log using Claude with structured output.
# Usage: summary.sh [log-file]
#   If no log-file given, reads logs/latest.jsonl symlink.
#
# Outputs:
#   - Markdown summary to logs/summaries/<run>.md
#   - Prints summary to stdout
#   - Exit code 0 = more work to do, 1 = all done
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
project_dir="$(cd "$script_dir/.." && pwd)"
log_dir="$project_dir/logs"
summary_dir="$log_dir/summaries"
mkdir -p "$summary_dir"

log_file="${1:-$log_dir/latest.jsonl}"
log_name="$(basename "$log_file" .jsonl)"
summary_file="$summary_dir/${log_name}.md"

schema='{"type":"object","properties":{"continue":{"type":"boolean","description":"true if there is more work to do, false if spec is fully implemented"},"summary":{"type":"string","description":"Markdown summary of what happened in this run"}},"required":["continue","summary"]}'

output=$(claude -p \
  --allowedTools 'Read' \
  --output-format json --json-schema "$schema" \
  "Read the log file at $log_file. Determine:
1. What tasks were worked on
2. What was accomplished (files created/modified, commits)
3. Whether the run succeeded or failed (and why)
4. Whether there is MORE work remaining (open tasks, unfinished spec items)

Set continue=true if there are open tasks or unfinished work.
Set continue=false if the spec appears fully implemented and all tasks are closed.")

structured=$(echo "$output" | jq '.structured_output')
summary=$(echo "$structured" | jq -r '.summary')
should_continue=$(echo "$structured" | jq -r '.continue')

# Write markdown summary
echo "$summary" > "$summary_file"

# Print to stdout
echo "$summary"
echo ""
echo "Summary saved: $summary_file"

# Exit code signals the loop
if [ "$should_continue" = "false" ]; then
  echo "Agent reports: all work complete."
  exit 1
fi
