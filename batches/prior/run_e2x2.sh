#!/bin/bash
# Thread E 2x2 (task 4109, user-approved n=20): provenance x rationale, reps 621-640, Opus.
# Four corners + the factual control (template_collide2_p2) rerun in-batch as the anchor.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for t in collide2_p2 collide2_p2x_ar collide2_p2x_an collide2_p2x_ur collide2_p2x_un; do
  for r in $(seq 621 640); do [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@${t}__rep$r" ] && { echo "CLASH $t rep$r"; clash=1; }; done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for lo in 621 631; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for t in template_collide2_p2 template_collide2_p2x_ar template_collide2_p2x_an template_collide2_p2x_ur template_collide2_p2x_un; do
    for r in $(seq $lo $((lo+9))); do echo "G_collide2_baseline $r claude-opus-5 $t task_p2.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@collide2_p2*__rep6[23][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_claude_opus_5__}; probe=${x%%@*}; rep=${n##*__rep}
    tag=${x#*@}; tag=${tag%%__rep*}
    "$STUDY/run_bland.sh" "$probe" "$rep" claude-opus-5 "template_$tag" task_p2.md
  fi
done
echo E2X2_DONE
