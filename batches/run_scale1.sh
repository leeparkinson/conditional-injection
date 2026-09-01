#!/bin/bash
# Confirmatory wave 1 (task 4109, user-approved n=20): reps 601-620, Opus, template_collide2.
#  - D-ladder + B-evidence cells (ask-default leak, evidence-demand resistance, redefine refusal) with anchors
#  - U7 repo-git irrelevant-antecedent (candidate replacement for the paper's earth-round example)
#    with U5 in-formatprice rerun for the same-batch relevant-vs-irrelevant contrast
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
CELLS="G_collide2_baseline G_collide2_cond E1_hiconf_baseline E1_hiconf_cond E2_evid_baseline E2_evid_cond E2_evid_verdict E2_evid_redefine T6_default_ask E3_ask_cond U7_collide2_repo_git U5_collide2_in_formatprice"
clash=0
for c in $CELLS; do for r in $(seq 601 620); do
  [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__${c}@collide2__rep$r" ] && { echo "CLASH $c rep$r"; clash=1; }
done; done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for lo in 601 611; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for c in $CELLS; do for r in $(seq $lo $((lo+9))); do echo "$c $r claude-opus-5 template_collide2"; done; done | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__*@collide2__rep6[0-2][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_claude_opus_5__}; probe=${x%%@*}; rep=${n##*__rep}
    "$STUDY/run_bland.sh" "$probe" "$rep" claude-opus-5 template_collide2
  fi
done
echo SCALE1_DONE
