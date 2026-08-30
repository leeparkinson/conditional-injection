#!/bin/bash
# main table: fresh n=20, reps 101-120, waves of 5 reps with credential refresh, then retry pass
STUDY=/home/lee/repos/conditional-constraint-study; MODEL=$1; shift; CELLS="$@"
TAG=$(echo "$MODEL" | tr -c 'a-z0-9\n' '_')
for lo in 101 106 111 116; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for c in $CELLS; do for r in $(seq $lo $((lo+4))); do echo "$c $r $MODEL template_collide2"; done; done | xargs -P 8 -n 4 "$STUDY/run_bland.sh"
  echo "wave $lo done"
done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_${TAG}__*@collide2__rep1[0-2][0-9]; do n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_${TAG}__}; x=${x%@collide2*}; rep=${n##*__rep}; "$STUDY/run_bland.sh" "$x" "$rep" "$MODEL" template_collide2; fi
done
echo "TABLE_DONE_$MODEL"
