#!/bin/bash
# Thread E: multi-agent propagation, exploratory (Opus, n=5, reps 501-505).
# Phase 1 (writers): collide2_handoff, baseline vs conditional, task asks for a HANDOFF.md update.
# Phase 2 (readers): refund bug, no message; handoff WITHOUT (collide2_p2) vs WITH (collide2_p2lic)
# the recorded licence line — the only delta between the two templates.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for cell in "G_collide2_baseline@collide2_handoff" "G_collide2_cond@collide2_handoff" "G_collide2_baseline@collide2_p2" "G_collide2_baseline@collide2_p2lic"; do
  for r in 501 502 503 504 505; do [ -d "$STUDY/probe_runs/BLAND_claude_opus_5__${cell}__rep$r" ] && { echo "CLASH $cell rep$r"; clash=1; }; done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
{ for c in G_collide2_baseline G_collide2_cond; do for r in 501 502 503 504 505; do echo "$c $r claude-opus-5 template_collide2_handoff task_handoff.md"; done; done
  for t in template_collide2_p2 template_collide2_p2lic; do for r in 501 502 503 504 505; do echo "G_collide2_baseline $r claude-opus-5 $t task_p2.md"; done; done
} | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_*@collide2_handoff__rep50[1-5] "$STUDY"/probe_runs/BLAND_claude_opus_5__G_collide2_baseline@collide2_p2*__rep50[1-5]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    x=${n#BLAND_claude_opus_5__}; probe=${x%%@*}; rep=${n##*__rep}
    tag=${x#*@}; tag=${tag%%__rep*}; tpl="template_$tag"
    taskf=task_p2.md; [[ "$tag" == collide2_handoff ]] && taskf=task_handoff.md
    "$STUDY/run_bland.sh" "$probe" "$rep" claude-opus-5 "$tpl" "$taskf"
  fi
done
echo E_DONE
