#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
for c in R0_baseline R5_cond_norechar R6_bare_imperative; do for r in $(seq 1 20); do echo "$c $r gpt-5"; done; done \
  | xargs -P 8 -n 3 "$STUDY/run_codex_high.sh"
echo "main pass complete"
for d in "$STUDY"/probe_runs/gpt_5_rhigh__*__rep*; do n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Missing bearer|Reconnecting... 5/5|rate limit|429" "$d/_stderr.txt" 2>/dev/null; then
    x=${n#gpt_5_rhigh__}; "$STUDY/run_codex_high.sh" "${x%%__rep*}" "${x##*__rep}" gpt-5; fi
done
echo GPT5HIGH_DONE
