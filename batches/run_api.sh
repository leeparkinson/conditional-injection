#!/bin/bash
# Thread A: second constraint family — public-API signature rule (template_api, task_api.md).
# AP0 baseline / AP1 strong order / AP2 verdict / AP3 conditional / AP4 false-antecedent conditional,
# Opus + Sonnet, exploratory n=5, reps 501-505 (see run_followups1.sh for the rep-range rule).
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for m in claude_opus_5 claude_sonnet_5; do for c in AP0_api_baseline AP1_api_order_strong AP2_api_verdict AP3_api_cond AP4_api_cond_false; do
  for r in 501 502 503 504 505; do [ -d "$STUDY/probe_runs/BLAND_${m}__${c}@api__rep$r" ] && { echo "CLASH $m $c rep$r"; clash=1; }; done
done; done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for MODEL in claude-opus-5 claude-sonnet-5; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for c in AP0_api_baseline AP1_api_order_strong AP2_api_verdict AP3_api_cond AP4_api_cond_false; do
    for r in 501 502 503 504 505; do echo "$c $r $MODEL template_api task_api.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done
# one retry pass (auth blips / empty runs)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__AP*__rep50[1-5] "$STUDY"/probe_runs/BLAND_claude_sonnet_5__AP*__rep50[1-5]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}
    probe=${x%%__rep*}; probe=${probe%%@*}; rep=${n##*__rep}
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" template_api task_api.md
  fi
done
echo API_DONE
