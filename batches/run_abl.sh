#!/bin/bash
BASE=$(cd "$(dirname "$0")/.." && pwd)
CELLS="A0_baseline A1_full A2_no_mechanism A3_no_foreclosure A4_no_compliance A5_mechanism_only A6_bare_permission"
for wave in 1 2; do
  cp ~/.claude/.credentials.json "$BASE/cfg/.credentials.json"
  lo=$(( (wave-1)*10 + 1 )); hi=$(( wave*10 ))
  for c in $CELLS; do for r in $(seq $lo $hi); do echo "$c $r claude-sonnet-5 template3"; done; done \
    | xargs -P 8 -n 4 "$BASE/run_w.sh"
  echo "wave $wave complete"
done
cp ~/.claude/.credentials.json "$BASE/cfg/.credentials.json"
for d in "$BASE/probe_runs"/A[0-6]_*__rep*; do
  n=$(basename "$d")
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    "$BASE/run_w.sh" "${n%%__rep*}" "${n##*__rep}" claude-sonnet-5 template3
  fi
done
echo ABLATION_DONE
