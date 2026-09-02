#!/bin/bash
# Review gap-closing runs (task 4109, Fable review 2026-09-02), n=20, reps 901-920.
#  E:      p2 control, p2y_FC anchor, p2z_AF (attributed+foreclosure), p2z_RF (rationale+foreclosure) — Opus
#  Valence: VS0 control + VS4 (unambiguous antecedent) — both models
#  Reflect: RF0 on the WIP-corrected template — both models
#  Immun:   G_collide2_cond anchor + IM2 generic baseline/cond — both models
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0; chk(){ for r in $(seq 901 920); do [ -d "$STUDY/probe_runs/$1__rep$r" ] && { echo "CLASH $1 rep$r"; clash=1; }; done; }
for t in collide2_p2 collide2_p2y_FC collide2_p2z_AF collide2_p2z_RF; do chk "BLAND_claude_opus_5__G_collide2_baseline@$t"; done
for m in claude_opus_5 claude_sonnet_5; do
  for c in VS0_valence_baseline VS4_valence_cond_clear; do chk "BLAND_${m}__${c}@valence"; done
  chk "BLAND_${m}__RF0_reflect@reflect"
  for c in G_collide2_cond IM2_immun_generic_baseline IM2_immun_generic_cond; do chk "BLAND_${m}__${c}@collide2"; done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for lo in 901 911; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for t in template_collide2_p2 template_collide2_p2y_FC template_collide2_p2z_AF template_collide2_p2z_RF; do
    for r in $(seq $lo $((lo+9))); do echo "G_collide2_baseline $r claude-opus-5 $t task_p2.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
  for MODEL in claude-opus-5 claude-sonnet-5; do
    cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
    { for c in VS0_valence_baseline VS4_valence_cond_clear; do for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL template_valence task.md"; done; done
      for r in $(seq $lo $((lo+9))); do echo "RF0_reflect $r $MODEL template_reflect task_reflect.md"; done
    } | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
    cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
    for c in G_collide2_cond IM2_immun_generic_baseline IM2_immun_generic_cond; do
      for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL template_collide2"; done
    done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
  done
done
# idempotent retry of any auth-failed run in this rep range
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_*__rep9[01][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error|Credit balance" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}; probe=${x%%@*}; rep=${n##*__rep}; tag=${x#*@}; tag=${tag%%__rep*}
    tpl="template_$tag"; taskf=task.md; [[ "$tag" == reflect ]] && taskf=task_reflect.md; [[ "$tag" == collide2_p2* ]] && taskf=task_p2.md
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" "$tpl" "$taskf"
  fi
done
echo REVIEW_GAPS_DONE
