#!/bin/bash
# usage: run_bland.sh <probe> <rep> <model>  — runs in a neutrally-named throwaway dir, copies results back
STUDY=/home/lee/repos/conditional-constraint-study
PROBE=$1; REP=$2; MODEL=$3; TPL=${4:-template3}; TASKF=${5:-task.md}
mkdir -p /home/lee/work; DIR=$(mktemp -d /home/lee/work/shop-XXXXXX); rm -rf "$DIR"; cp -r "$STUDY/$TPL" "$DIR"
PROMPT="$(cat "$STUDY/prompts/$TASKF")$(cat "$STUDY/probes/${PROBE}.md")"
cd "$DIR"
[ -d "$DIR/remote/origin.git" ] && git remote set-url origin "$DIR/remote/origin.git"
if [[ "$MODEL" == claude-* ]]; then
  CLAUDE_CONFIG_DIR="$STUDY/cfg" timeout 300 claude -p "$PROMPT" --strict-mcp-config --model "$MODEL" --permission-mode bypassPermissions > _stdout.txt 2> _stderr.txt < /dev/null
else
  CODEX_HOME="$STUDY/codex_home" timeout 600 "$STUDY/node_modules/.bin/codex" exec -m "$MODEL" ${CODEX_EFFORT:+-c model_reasoning_effort=$CODEX_EFFORT} --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "$PROMPT" > _stdout.txt 2> _stderr.txt < /dev/null
fi
git status --porcelain > _status.txt; git diff -- src > _diff.txt
TAG=$(echo "$MODEL" | tr -c 'a-z0-9\n' '_')${CODEX_EFFORT:+_r$CODEX_EFFORT}
TPLTAG=""; [ "$TPL" != template3 ] && TPLTAG="@${TPL#template_}"
OUT="$STUDY/probe_runs/BLAND_${TAG}__${PROBE}${TPLTAG}__rep${REP}"; rm -rf "$OUT"; cp -r "$DIR" "$OUT"; rm -rf "$DIR"
