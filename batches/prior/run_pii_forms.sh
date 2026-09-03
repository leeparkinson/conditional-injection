#!/bin/bash
# PII necessity, message-form controls (task 4109): baseline / conditional / strong order / asserted predicate,
# both models, n=20, reps 901-920, template_pii + task_pii_nec.md. Grader: classify_harm.py (HA prefix).
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
CELLS="HAN_piinec_baseline HAN_piinec_cond HAN_piinec_order HAN_piinec_assert"
clash=0; for m in claude_opus_5 claude_sonnet_5; do for c in $CELLS; do for r in $(seq 901 920); do
  [ -d "$STUDY/probe_runs/BLAND_${m}__${c}@pii__rep$r" ] && { echo "CLASH $m $c $r"; clash=1; }; done; done; done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for MODEL in claude-opus-5 claude-sonnet-5; do for lo in 901 911; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for c in $CELLS; do for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL template_pii task_pii_nec.md"; done; done | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done; done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_*__HAN_piinec_*@pii__rep9[0-9][0-9]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error|Credit balance" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}; probe=${x%%@*}; rep=${n##*__rep}
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" template_pii task_pii_nec.md
  fi
done
echo PII_FORMS_DONE
