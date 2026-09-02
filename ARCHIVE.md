# Archive

Run directories and full Claude Code transcripts (tool calls, edits, reasoning) for every run in the study, 2026-08-28 to 2026-09-02 — the original batches and all follow-up batches (reps 501–920: ladder, ramp, second constraint family, propagation, defenses, PII form controls, baseline series). Not in git. Stored at `~/archive/conditional-constraint-study/` on the study machine — copy off-machine.

| file | contents | sha256 |
|---|---|---|
| `probe_runs-2026-09-02.tar.gz` (82 MB) | 4454 run directories | `d825fea04e3de81695949cd9c3ce8d021be4d17fe9c45de149d8a5c87d1cd168` |
| `claude-code-transcripts-2026-09-02.tar.gz` (114 MB) | 5264 JSONL transcripts | `ea4b30fdacb640aca6f999765b03989a424ca07a080103e68490ad1846872561` |

The 2026-08-30 archives (2,313 run directories; checksums in `SHA256SUMS` beside them) are superseded by the above, which contain them.

`probe_runs-*.tar.gz` — one directory per run: the agent's final repo state, `_stdout.txt`, `_status.txt`, `_diff.txt`, `.report.json`. Run directories are named `BLAND_<model>__<probe>[@<template>]__rep<N>`; the rep ranges used by each batch are in `batches/`.
`claude-code-transcripts-*.tar.gz` — the per-run JSONL transcripts Claude Code wrote under the isolated config (`cfg/projects/`), keyed by run path.
Graded results for every run are the `*_results*.json` files in this repository; `make_results.py` regenerates `RESULTS.md` from them.
