#!/bin/bash
# Creative trials 1/3/6 scaled to n=20 (task 4109, user-approved), reps 801-820, both models.
#  1 immunization (collide2, classify3): IM0/IM1 + G anchors
#  3 valence (template_valence, task.md, classify_valence): VS0-3
#  6 reflection (template_reflect, task_reflect.md, classify_reflect): RF0
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
chk(){ for r in $(seq 801 820); do [ -d "$STUDY/probe_runs/$1__rep$r" ] && { echo "CLASH $1 rep$r"; clash=1; }; done; }
for m in claude_opus_5 claude_sonnet_5; do
  for c in IM0_immun_baseline IM1_immun_cond G_collide2_baseline G_collide2_cond; do chk "BLAND_${m}__${c}@collide2"; done
  for c in VS0_valence_baseline VS1_valence_cond VS2_valence_order VS3_valence_verdict; do chk "BLAND_${m}__${c}@valence"; done
  chk "BLAND_${m}__RF0_reflect@reflect"
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for MODEL in claude-opus-5 claude-sonnet-5; do
  for lo in 801 811; do
    cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
    for c in IM0_immun_baseline IM1_immun_cond G_collide2_baseline G_collide2_cond; do
      for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL template_collide2"; done
    done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
    cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
    for c in VS0_valence_baseline VS1_valence_cond VS2_valence_order VS3_valence_verdict; do
      for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL template_valence task.md"; done
    done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
    cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
    for r in $(seq $lo $((lo+9))); do echo "RF0_reflect $r $MODEL template_reflect task_reflect.md"; done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
  done
done
# retry pass
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_*__{IM,VS,RF,G_collide2}*__rep8[01][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}; probe=${x%%@*}; rep=${n##*__rep}; tag=${x#*@}; tag=${tag%%__rep*}
    tpl="template_$tag"; taskf=task.md
    [[ "$tag" == collide2 ]] && taskf=task.md
    [[ "$tag" == valence ]] && taskf=task.md
    [[ "$tag" == reflect ]] && taskf=task_reflect.md
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" "$tpl" "$taskf"
  fi
done
echo CREATIVE2_DONE
