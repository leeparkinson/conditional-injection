#!/bin/bash
# Task 4109 follow-ups, batch 1 (all exploratory n=5, reps 101-105, within-batch):
#  D-ladder: operator exception wording (clearly-safe / high-confidence / establish-from-repo / ask-default)
#            x (baseline / conditional), plus verdict + standard-redefining-conditional controls on the
#            evidence rung  — E1_/E2_/E3_ probes + G_/T6_ anchors, template_collide2, Opus.
#  C-ramp:   byte-identical probe pair (G_collide2_baseline / G_collide2_cond) across WIP proximity:
#            template3 (no WIP) -> collide_far (other function) -> collide (same function, adjacent
#            line) -> collide2 (same line, anchors above), Opus.
#  G-stability batch 1: Sonnet R0_baseline n=20 (reps 201-220); batches 2-4 in run_g_stability.sh.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for c in G_collide2_baseline G_collide2_cond E1_hiconf_baseline E1_hiconf_cond E2_evid_baseline E2_evid_cond E2_evid_verdict E2_evid_redefine T6_default_ask E3_ask_cond; do
  for r in 101 102 103 104 105; do echo "$c $r claude-opus-5 template_collide2"; done
done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for t in template3 template_collide_far template_collide; do
  for c in G_collide2_baseline G_collide2_cond; do
    for r in 101 102 103 104 105; do echo "$c $r claude-opus-5 $t"; done
  done
done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for r in $(seq 201 220); do echo "R0_baseline $r claude-sonnet-5"; done | xargs -P 8 -n 3 "$STUDY/run_bland.sh"
# one retry pass over this batch's rep ranges (auth blips / empty runs)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__*__rep10[1-5] "$STUDY"/probe_runs/BLAND_claude_sonnet_5__R0_baseline__rep2[0-9][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}
    probe=${x%%__rep*}; rep=${x##*__rep}
    tpl=template3; [[ "$probe" == *@* ]] && { tpl="template_${probe##*@}"; probe=${probe%%@*}; }
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" "$tpl"
  fi
done
echo FOLLOWUPS1_DONE
