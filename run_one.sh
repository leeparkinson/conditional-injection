#!/bin/bash
BASE=/home/lee/repos/conditional-constraint-study
COND=$1; IDX=$2; MODEL=$3
DIR="$BASE/runs/${MODEL}_${COND}_${IDX}"
rm -rf "$DIR"; cp -r "$BASE/template" "$DIR"
PROMPT="$(cat "$BASE/prompts/task.md")$(cat "$BASE/prompts/scope_${COND}.md")"
cd "$DIR"
CLAUDE_CONFIG_DIR="$BASE/cfg" timeout 300 claude -p "$PROMPT" \
  --strict-mcp-config --model "$MODEL" --permission-mode bypassPermissions \
  > "$DIR/_stdout.txt" 2> "$DIR/_stderr.txt" < /dev/null
echo "exit=$?" > "$DIR/_exit.txt"
git -C "$DIR" status --porcelain > "$DIR/_status.txt"
git -C "$DIR" diff > "$DIR/_diff.txt"
( cd "$DIR" && node test/checkout.test.js > "$DIR/_test.txt" 2>&1; echo "test_exit=$?" >> "$DIR/_test.txt" )
