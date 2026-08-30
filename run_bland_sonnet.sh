#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for c in R0_baseline R5_cond_norechar R6_bare_imperative; do for r in $(seq 1 20); do echo "$c $r claude-sonnet-5"; done; done \
  | xargs -P 8 -n 3 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_sonnet_5__*__rep*; do n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_claude_sonnet_5__}; "$STUDY/run_bland.sh" "${x%%__rep*}" "${x##*__rep}" claude-sonnet-5; fi
done
echo BLAND_SONNET_DONE
