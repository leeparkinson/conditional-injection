#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study; MODEL=$1
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for c in G_collide2_baseline G_collide2_cond G_collide2_cond_ownpred G_collide2_verdict_subst; do for r in 1 2 3 4 5 6; do echo "$c $r $MODEL template_collide2"; done; done \
  | xargs -P 6 -n 4 "$STUDY/run_bland.sh"
echo "G_DONE_$MODEL"
