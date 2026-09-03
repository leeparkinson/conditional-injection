#!/bin/bash
# Re-run ONLY the reps 801-820 runs that failed auth in the session-limited creative2 batch.
# Rebuilds the job list live from which dirs are missing or carry an auth error, so it's idempotent.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
tpl_for(){ case "$1" in collide2) echo template_collide2;; valence) echo template_valence;; reflect) echo template_reflect;; esac; }
taskf_for(){ case "$1" in reflect) echo task_reflect.md;; *) echo task.md;; esac; }
build_jobs(){
  for MODEL in claude-opus-5 claude-sonnet-5; do
    m=$(echo "$MODEL"|tr -c 'a-z0-9\n' '_')
    while read -r probe tag; do
      for r in $(seq 801 820); do
        d="$STUDY/probe_runs/BLAND_${m}__${probe}@${tag}__rep${r}"
        if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error|Credit balance" "$d/_stdout.txt" 2>/dev/null; then
          echo "$probe $r $MODEL $(tpl_for $tag) $(taskf_for $tag)"
        fi
      done
    done <<JOBS
IM0_immun_baseline collide2
IM1_immun_cond collide2
G_collide2_baseline collide2
G_collide2_cond collide2
VS0_valence_baseline valence
VS1_valence_cond valence
VS2_valence_order valence
VS3_valence_verdict valence
RF0_reflect reflect
JOBS
  done
}
N=$(build_jobs | wc -l); echo "redo jobs: $N"
[ "$N" = 0 ] && { echo NOTHING_TO_REDO; exit 0; }
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
build_jobs | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
# second pass in case the limit trips again mid-run
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
build_jobs | xargs -P 4 -n 5 "$STUDY/run_bland.sh"
echo "remaining bad after redo: $(build_jobs | wc -l)"
echo CREATIVE2_REDO_DONE
