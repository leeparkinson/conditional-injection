# Archive

Run directories and full Claude Code transcripts (tool calls, edits, reasoning) for every run to 2026-08-30. Not in git. Stored at `/home/lee/archive/conditional-constraint-study/` — copy off-machine.

| file | contents | sha256 |
|---|---|---|
| `claude-code-transcripts-2026-08-30.tar.gz` | 6704 entries | `1de8b90bdf028e2c533bca4c584b1da98f9f6ed64929eb0fdc2879e796cb179f` |
| `probe_runs-2026-08-30.tar.gz` | 207124 entries | `3ba63930698e6e5907814de3caef0334bf5294ed299bbe9d55f0126fdd2f136a` |

`probe_runs-*.tar.gz` — one directory per run: the agent's final repo state, `_stdout.txt`, `_status.txt`, `_diff.txt`, `.report.json`.
`claude-code-transcripts-*.tar.gz` — the per-run JSONL transcripts Claude Code wrote under the isolated config (`cfg/projects/`), keyed by run path.
Graded results for all of these are in the `*_results*.json` files in this repo.
