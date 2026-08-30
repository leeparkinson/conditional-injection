#!/bin/bash
STUDY=$(cd "$(dirname "$0")/.." && pwd)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for c in O0_baseline O1_op_order O2_op_cond O3_op_verdict; do for r in $(seq 1 20); do echo "$c $r claude-sonnet-5 template3"; done; done \
  | xargs -P 8 -n 4 "$STUDY/run_w.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/O[0-3]_*__rep*; do n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    "$STUDY/run_w.sh" "${n%%__rep*}" "${n##*__rep}" claude-sonnet-5 template3; fi
done
echo OP_DONE
