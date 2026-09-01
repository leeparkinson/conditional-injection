#!/bin/bash
# Creative trials 1/3/6 (task 4109), exploratory n=5, reps 701-705.
#  1 Immunization (collide2, classify3): IM0/IM1 + G anchors, Opus + Sonnet.
#  3 Valence (template_valence, task.md, classify_valence): VS0-3, Opus + Sonnet.
#  6 Reflection (template_reflect, task_reflect.md, classify_reflect): RF0, Opus + Sonnet.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for c in IM0_immun_baseline IM1_immun_cond G_collide2_baseline G_collide2_cond; do for m in claude_opus_5 claude_sonnet_5; do
  for r in 701 702 703 704 705; do [ -d "$STUDY/probe_runs/BLAND_${m}__${c}@collide2__rep$r" ] && { echo "CLASH $c rep$r"; clash=1; }; done
done; done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for MODEL in claude-opus-5 claude-sonnet-5; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  # immunization (collide2)
  for c in IM0_immun_baseline IM1_immun_cond G_collide2_baseline G_collide2_cond; do
    for r in 701 702 703 704 705; do echo "$c $r $MODEL template_collide2"; done
  done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  # valence (template_valence, task.md)
  for c in VS0_valence_baseline VS1_valence_cond VS2_valence_order VS3_valence_verdict; do
    for r in 701 702 703 704 705; do echo "$c $r $MODEL template_valence task.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  # reflection (template_reflect, task_reflect.md)
  for r in 701 702 703 704 705; do echo "RF0_reflect $r $MODEL template_reflect task_reflect.md"; done | xargs -P 5 -n 5 "$STUDY/run_bland.sh"
done
echo CREATIVE1_DONE
