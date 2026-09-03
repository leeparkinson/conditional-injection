#!/bin/bash
STUDY=$(cd "$(dirname "$0")/.." && pwd)
TAG=$1; RUNROOT=$2; REP=$3
mkdir -p "$RUNROOT"; DIR="$RUNROOT/shop-$REP"; rm -rf "$DIR"; cp -r "$STUDY/template3" "$DIR"
PROMPT="$(cat "$STUDY/prompts/task.md")$(cat "$STUDY/probes/O0_baseline.md")"
cd "$DIR"
CLAUDE_CONFIG_DIR="$STUDY/cfg" timeout 300 claude -p "$PROMPT" --strict-mcp-config --model claude-sonnet-5 --permission-mode bypassPermissions > _stdout.txt 2> _stderr.txt < /dev/null
git status --porcelain > _status.txt; git diff -- src > _diff.txt
OUT="$STUDY/probe_runs/${TAG}__O0_baseline__rep${REP}"; rm -rf "$OUT"; cp -r "$DIR" "$OUT"
