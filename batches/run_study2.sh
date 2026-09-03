#!/bin/bash
# Study 2 — clean replication of every reported cell (batches/study2_cells.tsv), one paper section per batch
# so every contrast has an in-batch baseline. Resumable: re-invoke and it skips completed runs and redoes
# auth-failed ones. Stops itself when the CLI reports a session/usage limit so no batch is half-done.
# Usage: batches/run_study2.sh [section-prefix]   e.g. batches/run_study2.sh 5.1   (default: all, in order)
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd); ISO=${ISO_DIR:-$HOME/work/.iso}; P=${PAR:-6}
ONLY=${1:-}; LOG="$STUDY/batches/study2.log"
[ -x "$ISO/claude" ] || { echo "pinned binary missing: $ISO/claude"; exit 2; }
"$ISO/claude" --version | grep -q "2.1.258" || { echo "pinned binary is not 2.1.258"; exit 2; }
cp ~/.claude/.credentials.json "$ISO/.credentials.json"
tag(){ echo "$1" | tr -c 'a-z0-9\n' '_'; }
# A run counts as done when _status.txt exists; a MISSING _stdout.txt with _status.txt present means the agent tidied
# the untracked log away (seen in del/secret/api cells) — not a failed run, so do not redo it (redoing would resample).
bad(){ d=$1; if [ ! -s "$d/_stdout.txt" ]; then { [ -f "$d/_status.txt" ] && [ ! -e "$d/_stdout.txt" ]; } && return 1; return 0; fi; grep -qE "Failed to authenticate|session limit|usage limit|OAuth session expired|API Error|Credit balance|Reconnecting\.\.\. 5/5" "$d/_stdout.txt" 2>/dev/null; }
limit_hit(){ # only the runs of the batch just executed (stale limited runs from LATER sections must not trip this)
  echo "$jobs" | while read -r probe r m tpl task; do [ -z "$probe" ] && continue; t=""; [ "$tpl" != template3 ] && t="@${tpl#template_}"
    f="$STUDY/probe_runs/S2_$(tag $m)__${probe}${t}__rep$r/_stdout.txt"; grep -lE "session limit|usage limit|Credit balance" "$f" 2>/dev/null; done | head -1; }
sections=$(grep -v '^#' "$STUDY/batches/study2_cells.tsv" | cut -f1 | awk '!s[$0]++')
for sec in $sections; do
  [ -n "$ONLY" ] && [[ "$sec" != "$ONLY"* ]] && continue
  lo=1001; case "$sec" in 8-baseline-b*) b=${sec##*b}; lo=$((1001+(b-1)*100));; esac
  jobs=$(grep -v '^#' "$STUDY/batches/study2_cells.tsv" | awk -F'\t' -v s="$sec" '$1==s' | while IFS=$'\t' read -r _ probe tpl task models; do
    for m in ${models//,/ }; do t=""; [ "$tpl" != template3 ] && t="@${tpl#template_}"
      for r in $(seq $lo $((lo+19))); do d="$STUDY/probe_runs/S2_$(tag $m)__${probe}${t}__rep$r"; if [ ! -d "$d" ] || bad "$d"; then echo "$probe $r $m $tpl $task"; fi; done
    done; done)
  n=$(echo "$jobs" | grep -c .); [ "$n" = 0 ] && { echo "$(date -u +%H:%M) $sec: complete" | tee -a "$LOG"; continue; }
  echo "$(date -u +%H:%M) $sec: running $n" | tee -a "$LOG"
  cp ~/.claude/.credentials.json "$ISO/.credentials.json"
  echo "$jobs" | xargs -P "$P" -n 5 "$STUDY/run_study2.sh"
  if [ -n "$(limit_hit)" ]; then echo "$(date -u +%H:%M) $sec: SESSION LIMIT HIT — stopping; re-run this script to resume" | tee -a "$LOG"; exit 3; fi
  # Baseline series: five separate 20-run batches, run back to back (Lee, 2026-09-03: timed spacing is not part of the design).
done
echo "$(date -u +%H:%M) STUDY2_DONE" | tee -a "$LOG"
