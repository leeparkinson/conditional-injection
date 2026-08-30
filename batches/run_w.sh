#!/bin/bash
BASE=$(cd "$(dirname "$0")/.." && pwd)
PROBE=$1; REP=$2; MODEL=$3; TPL=${4:-template3}
DIR="$BASE/probe_runs/${PROBE}__rep${REP}"
rm -rf "$DIR"; cp -r "$BASE/$TPL" "$DIR"
PROMPT="$(cat "$BASE/prompts/task.md")$(cat "$BASE/probes/${PROBE}.md")"
cd "$DIR"
CLAUDE_CONFIG_DIR="$BASE/cfg" timeout 300 claude -p "$PROMPT" \
  --strict-mcp-config --model "$MODEL" --permission-mode bypassPermissions \
  > "$DIR/_stdout.txt" 2> "$DIR/_stderr.txt" < /dev/null
git -C "$DIR" status --porcelain > "$DIR/_status.txt"
git -C "$DIR" diff -- src > "$DIR/_diff.txt"
