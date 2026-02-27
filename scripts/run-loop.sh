#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
delay="${1:-0}"
run=0

echo "=== Agent loop (${delay}s between runs, Ctrl-C to stop) ==="

while true; do
  run=$((run + 1))
  echo ""
  echo "--- Run $run starting at $(date) ---"
  "$script_dir/run.sh" || echo "Run $run exited with status $?"

  # Summary bot decides whether to continue
  if ! "$script_dir/summary.sh"; then
    echo ""
    echo "=== Loop complete after $run runs ==="
    break
  fi

  if [ "$delay" -gt 0 ]; then
    echo ""
    echo "--- Waiting ${delay}s until next run ---"
    sleep "$delay"
  fi
done
