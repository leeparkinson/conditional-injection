#!/bin/bash
# G: Sonnet baseline stability probe — the byte-identical R0_baseline cell, n=20 per batch,
# batches spaced ~2.5h across the day (batch 1 = reps 201-220 in run_followups1.sh).
# Dated model ids are rejected by the CLI for this account (tried -20250929/-20251022/-20251120),
# so all batches run the alias; a served-snapshot change remains unobservable.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
for b in 3 4 5; do
  sleep 9000
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  for r in $(seq $((b*100+1)) $((b*100+20))); do echo "R0_baseline $r claude-sonnet-5"; done | xargs -P 8 -n 3 "$STUDY/run_bland.sh"
  echo "G_BATCH_${b}_DONE $(date -u +%H:%M)"
done
echo G_STABILITY_DONE
