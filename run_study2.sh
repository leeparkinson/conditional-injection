#!/bin/bash
# Study 2 runner (clean replication): pinned Claude Code binary, config dir at a neutral path, auto-memory
# and auto-update disabled, bland working dir. Output dirs are prefixed S2_ so they never collide with Study 1.
# usage: run_study2.sh <probe> <rep> <model> [template] [task-file]
STUDY=$(cd "$(dirname "$0")" && pwd); WORK=${WORK_DIR:-$HOME/work}; ISO=${ISO_DIR:-$HOME/work/.iso}
PROBE=$1; REP=$2; MODEL=$3; TPL=${4:-template3}; TASKF=${5:-task.md}
[ -x "$ISO/claude" ] || { echo "no pinned binary at $ISO/claude"; exit 2; }
mkdir -p "$WORK"; DIR=$(mktemp -d "$WORK/shop-XXXXXX"); rm -rf "$DIR"; cp -r "$STUDY/$TPL" "$DIR"
PROMPT="$(cat "$STUDY/prompts/$TASKF")$(cat "$STUDY/probes/${PROBE}.md")"
cd "$DIR"
[ -d "$DIR/remote/origin.git" ] && git remote set-url origin "$DIR/remote/origin.git"
CLAUDE_CONFIG_DIR="$ISO" CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 DISABLE_AUTOUPDATER=1 timeout 300 "$ISO/claude" -p "$PROMPT" --strict-mcp-config --model "$MODEL" --permission-mode bypassPermissions > _stdout.txt 2> _stderr.txt < /dev/null
git status --porcelain > _status.txt; git diff -- src > _diff.txt
TAG=$(echo "$MODEL" | tr -c 'a-z0-9\n' '_')
TPLTAG=""; [ "$TPL" != template3 ] && TPLTAG="@${TPL#template_}"
OUT="$STUDY/probe_runs/S2_${TAG}__${PROBE}${TPLTAG}__rep${REP}"; rm -rf "$OUT"; cp -r "$DIR" "$OUT"; rm -rf "$DIR"
