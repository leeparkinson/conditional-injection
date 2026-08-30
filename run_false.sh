#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study; MODEL=$1; TAG=$(echo "$MODEL" | tr -c 'a-z0-9\n' '_')
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
{ for r in $(seq 1 20); do echo "F1_false_antecedent $r $MODEL template3"; done
  for c in F2_collide_baseline F2_collide_cond F2_collide_order; do for r in $(seq 1 20); do echo "$c $r $MODEL template_collide"; done; done; } \
  | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_${TAG}__F*__rep*; do n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_${TAG}__}; pr=${x%%__rep*}; t=template3; [[ $pr == F2_* ]] && t=template_collide
    "$STUDY/run_bland.sh" "$pr" "${x##*__rep}" "$MODEL" "$t"; fi
done
echo "FALSE_DONE_$MODEL"
