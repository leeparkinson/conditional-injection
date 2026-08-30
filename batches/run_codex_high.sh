#!/bin/bash
# usage: run_codex.sh <probe> <rep> <model>   — same layout as run_w.sh, but drives OpenAI via Codex CLI
STUDY=$(cd "$(dirname "$0")/.." && pwd)
PROBE=$1; REP=$2; MODEL=$3; TAG=$(echo "$MODEL" | tr -c "a-z0-9\n" "_")_rhigh
DIR="$STUDY/probe_runs/${TAG}__${PROBE}__rep${REP}"
rm -rf "$DIR"; cp -r "$STUDY/template3" "$DIR"
PROMPT="$(cat "$STUDY/prompts/task.md")$(cat "$STUDY/probes/${PROBE}.md")"
cd "$DIR"
CODEX_HOME="$STUDY/codex_home" timeout 600 "$STUDY/node_modules/.bin/codex" exec -m "$MODEL" -c model_reasoning_effort=high \
  --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "$PROMPT" \
  > "$DIR/_stdout.txt" 2> "$DIR/_stderr.txt" < /dev/null
git -C "$DIR" status --porcelain > "$DIR/_status.txt"
git -C "$DIR" diff -- src > "$DIR/_diff.txt"
