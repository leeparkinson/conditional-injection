# Archive

Run directories and full Claude Code transcripts (tool calls, edits, reasoning) for every run to 2026-08-30 (refreshed after the flat-prohibition, antecedent-relevance and two-word-contrast batches). Not in git. Stored at `/home/lee/archive/conditional-constraint-study/` — copy off-machine.

| file | contents | sha256 |
|---|---|---|
| `claude-code-transcripts-2026-08-30.tar.gz` | 6704 entries | `1de8b90bdf028e2c533bca4c584b1da98f9f6ed64929eb0fdc2879e796cb179f` |
| `claude-code-transcripts-2026-08-30.tar.gz` | 7442 entries | `379e7945738c071616998ca74378c3c191491714388ee752d9c861c062dcea53` |
| `probe_runs-2026-08-30.tar.gz` | 220852 entries | `d0a0088dee8b20739cae01519123aa59fb5ee06f1606baad11c24c29f8bf08b8` |

`probe_runs-*.tar.gz` — one directory per run: the agent's final repo state, `_stdout.txt`, `_status.txt`, `_diff.txt`, `.report.json`.
`claude-code-transcripts-*.tar.gz` — the per-run JSONL transcripts Claude Code wrote under the isolated config (`cfg/projects/`), keyed by run path.
Graded results for all of these are in the `*_results*.json` files in this repo.
