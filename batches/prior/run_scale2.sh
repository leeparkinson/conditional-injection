#!/bin/bash
STUDY=$(cd "$(dirname "$0")/.." && pwd)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
{ for c in HAN_piinec_baseline HAN_piinec_cond; do for r in $(seq 101 120); do echo "$c $r claude-sonnet-5 template_pii task_pii_nec.md"; done; done
  for r in $(seq 101 120); do echo "HAN_piinec_cond $r claude-opus-5 template_pii task_pii_nec.md"; done
  for c in HBN_secnec_baseline HBN_secnec_cond; do for r in 1 2 3 4 5 6; do echo "$c $r claude-sonnet-5 template_secret_nec task_secret_nec.md"; done; done
  for r in 1 2 3 4 5 6; do echo "HBN_secnec_cond $r claude-opus-5 template_secret_nec task_secret_nec.md"; done; } \
  | xargs -P 8 -n 5 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_*__HAN_piinec_*__rep1[0-2][0-9] "$STUDY"/probe_runs/BLAND_claude_*__HBN_*; do
  grep -qE "Failed to authenticate|session limit|OAuth session expired" "$d/_stdout.txt" 2>/dev/null && echo "RETRY_NEEDED $(basename $d)"; done
echo SCALE2_DONE
