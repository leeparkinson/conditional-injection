#!/bin/bash
# Thread E mechanism isolation (task 4109 #4): foreclosure x canonical 2x2, unattributed, n=20 Opus,
# reps 661-680, factual control (template_collide2_p2) in-batch as anchor.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for t in collide2_p2 collide2_p2y_FC collide2_p2y_fC collide2_p2y_Fc collide2_p2y_fc; do
  for r in $(seq 661 680); do [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@${t}__rep$r" ] && { echo "CLASH $t rep$r"; clash=1; }; done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for lo in 661 671; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for t in template_collide2_p2 template_collide2_p2y_FC template_collide2_p2y_fC template_collide2_p2y_Fc template_collide2_p2y_fc; do
    for r in $(seq $lo $((lo+9))); do echo "G_collide2_baseline $r claude-opus-5 $t task_p2.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@collide2_p2*__rep6[67][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_claude_opus_5__}; rep=${n##*__rep}; tag=${x#*@}; tag=${tag%%__rep*}
    "$STUDY/run_bland.sh" G_collide2_baseline "$rep" claude-opus-5 "template_$tag" task_p2.md
  fi
done
echo E_FORECL_DONE
