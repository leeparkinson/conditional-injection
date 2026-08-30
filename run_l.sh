#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
{ for c in L1_collide2_order L2_collide2_order_strong L3_collide2_order_reason L4_collide2_cond_irrelevant L5_collide2_cond_conflictfalse L6_collide2_cond_noknowledge; do
    for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 template_collide2"; done; done
  for c in L1_collide2_order L4_collide2_cond_irrelevant L7_collide2_cond_prohibit; do
    for r in 1 2 3 4 5 6; do echo "$c $r claude-sonnet-5 template_collide2"; done; done; } \
  | xargs -P 8 -n 4 "$STUDY/run_bland.sh"
echo L_DONE
