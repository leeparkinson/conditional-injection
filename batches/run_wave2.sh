#!/bin/bash
# Confirmatory wave 2 (task 4109, user-approved n=20):
#  2a ramp: byte-identical probe pair across WIP proximity, ALL cells reps 621-640 so the whole
#     ramp (incl. same-line) is one self-anchored batch. Opus.
#  2b thread A: AP cells on template_api, both models, reps 601-620.
#  2c thread E readers: p2 / p2lic / p2norm, Opus, reps 601-620.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for t in "" "@collide_far" "@collide" "@collide2"; do for c in G_collide2_baseline G_collide2_cond; do
  for r in $(seq 621 640); do [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__${c}${t}__rep$r" ] && { echo "CLASH $c$t rep$r"; clash=1; }; done
done; done
for m in claude_opus_5 claude_sonnet_5; do for c in AP0_api_baseline AP1_api_order_strong AP2_api_verdict AP3_api_cond AP4_api_cond_false; do
  for r in $(seq 601 620); do [ -d "$STUDY/probe_runs/BLAND_${m}__${c}@api__rep$r" ] && { echo "CLASH $m $c rep$r"; clash=1; }; done
done; done
for t in collide2_p2 collide2_p2lic collide2_p2norm; do
  for r in $(seq 601 620); do [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@${t}__rep$r" ] && { echo "CLASH $t rep$r"; clash=1; }; done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
# 2a ramp
for lo in 621 631; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for t in template3 template_collide_far template_collide template_collide2; do for c in G_collide2_baseline G_collide2_cond; do
    for r in $(seq $lo $((lo+9))); do echo "$c $r claude-opus-5 $t"; done
  done; done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
done
echo WAVE2A_DONE
# 2b thread A
for MODEL in claude-opus-5 claude-sonnet-5; do for lo in 601 611; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for c in AP0_api_baseline AP1_api_order_strong AP2_api_verdict AP3_api_cond AP4_api_cond_false; do
    for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL template_api task_api.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done; done
echo WAVE2B_DONE
# 2c thread E readers
for lo in 601 611; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for t in template_collide2_p2 template_collide2_p2lic template_collide2_p2norm; do
    for r in $(seq $lo $((lo+9))); do echo "G_collide2_baseline $r claude-opus-5 $t task_p2.md"; done
  done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done
echo WAVE2C_DONE
# retry pass
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_*__rep6[2-4][0-9] "$STUDY"/probe_runs/BLAND_claude_*__AP*@api__rep6[0-2][0-9] "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@collide2_p2*__rep6[0-2][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}
    probe=${x%%__rep*}; rep=${n##*__rep}
    tag=""; [[ "$probe" == *@* ]] && { tag=${probe#*@}; probe=${probe%%@*}; }
    tpl=template3; [ -n "$tag" ] && tpl="template_$tag"
    taskf=task.md
    [[ "$tag" == api ]] && taskf=task_api.md
    [[ "$tag" == collide2_p2* ]] && taskf=task_p2.md
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" "$tpl" "$taskf"
  fi
done
echo WAVE2_DONE
