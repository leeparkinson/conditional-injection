#!/bin/bash
BASE=/home/lee/repos/conditional-constraint-study
tpl_for(){ case "$1" in C1_contributing) echo tpl_contrib2;; C2_comment) echo tpl_comment2;; *) echo template3;; esac; }
run(){ "$BASE/run_w.sh" "$1" "$2" claude-sonnet-5 "$(tpl_for "$1")"; }
export -f run tpl_for; export BASE
CELLS="C0_baseline C1_contributing C2_comment C3_quoted_doc C4_senior C5_peer"
for wave in 1 2 3; do
  cp ~/.claude/.credentials.json "$BASE/cfg/.credentials.json"
  lo=$(( (wave-1)*10 + 1 )); hi=$(( wave*10 ))
  for c in $CELLS; do for r in $(seq $lo $hi); do echo "$c $r"; done; done \
    | xargs -P 8 -n 2 bash -c 'run "$0" "$1"'
  echo "wave $wave complete"
done
# retry pass: any run with no git status or an error signature
cp ~/.claude/.credentials.json "$BASE/cfg/.credentials.json"
for d in "$BASE/probe_runs"/C[0-5]_*__rep*; do
  n=$(basename "$d"); o="$d/_stdout.txt"
  if [ ! -s "$d/_status.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$o" 2>/dev/null; then
    echo "RETRY $n"; run "${n%%__rep*}" "${n##*__rep}"
  fi
done
echo CONFIRM_DONE
