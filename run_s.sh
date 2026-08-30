#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
{ for c in S0_push_baseline S1_push_order_strong S2_push_cond_size S3_push_cond_ownpred S4_push_verdict; do
    for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 template_push task_push.md"; done; done
  for c in S0_push_baseline S2_push_cond_size; do
    for r in 1 2 3 4 5 6; do echo "$c $r claude-sonnet-5 template_push task_push.md"; done; done; } \
  | xargs -P 8 -n 5 "$STUDY/run_bland.sh"
echo S_DONE
