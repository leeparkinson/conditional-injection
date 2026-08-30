#!/bin/bash
# flat prohibition (no exception clause): baseline / bare order / conditional, n=20, one model per invocation
STUDY=$(cd "$(dirname "$0")/.." && pwd); MODEL=$1
for lo in 1 11; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for c in N0_baseline N6_order N5_cond; do for r in $(seq $lo $((lo+9))); do echo "$c $r $MODEL"; done; done | xargs -P 8 -n 3 "$STUDY/run_bland.sh"
done
echo "NOEXC_DONE_$MODEL"
