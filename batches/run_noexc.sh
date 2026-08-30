#!/bin/bash
STUDY=$(cd "$(dirname "$0")/.." && pwd)
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
# two Anthropic models, three cells, n=15 each = 90 runs
for m in claude-sonnet-5 claude-opus-5; do
  for c in N0_baseline N6_order N5_cond; do for r in $(seq 1 15); do echo "$c $r $m"; done; done
done | xargs -P 8 -n 3 "$STUDY/run_bland.sh"
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_*__N[056]_*__rep*; do n=$(basename "$d"); tag=${n%%__N*}; rest=${n#*__}
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    m=$(echo "$tag" | sed 's/BLAND_//;s/_/-/g'); "$STUDY/run_bland.sh" "${rest%%__rep*}" "${rest##*__rep}" "$m"; fi
done
echo NOEXC_DONE
