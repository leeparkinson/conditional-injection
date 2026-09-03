#!/bin/bash
STUDY=$(cd "$(dirname "$0")/.." && pwd)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for c in M1_collide2_fact_only M2_collide2_fact_true_unhelpful M3_collide2_cond_size M4_collide2_cond_difffunc M5_collide2_cond_sameline; do
  for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 template_collide2"; done; done | xargs -P 8 -n 4 "$STUDY/run_bland.sh"
echo M_DONE
