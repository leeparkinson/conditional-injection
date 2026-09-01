#!/bin/bash
# Thread E adjudication (task 4109): re-run the EXACT wave-2 templates that disagreed with the 2x2,
# at fresh reps 641-660, to decide if p2norm's 11/20 replicates or was a batch artifact. Opus, n=20.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for t in collide2_p2 collide2_p2norm collide2_p2lic; do
  for r in $(seq 641 660); do [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@${t}__rep$r" ] && { echo "CLASH $t rep$r"; clash=1; }; done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for lo in 641 651; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for t in template_collide2_p2 template_collide2_p2norm template_collide2_p2lic; do
    for r in $(seq $lo $((lo+9))); do echo "G_collide2_baseline $r claude-opus-5 $t task_p2.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@collide2_p2*__rep6[45][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_claude_opus_5__}; rep=${n##*__rep}; tag=${x#*@}; tag=${tag%%__rep*}
    "$STUDY/run_bland.sh" G_collide2_baseline "$rep" claude-opus-5 "template_$tag" task_p2.md
  fi
done
echo E_REPL_DONE
