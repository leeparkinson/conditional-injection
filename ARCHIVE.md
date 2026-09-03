# Archive

Run directories and full Claude Code transcripts (tool calls, edits, reasoning) for every run behind the paper. Not in git: all six files below are attached to the GitHub release **[v1.0-data](https://github.com/leeparkinson/conditional-injection/releases/tag/v1.0-data)** (a Zenodo deposit with a DOI is planned for publication); the originals are also at `~/archive/conditional-constraint-study/` on the study machine.

**Reported runs (the paper's numbers; 2026-09-02/03, pinned CLI 2.1.258, isolated neutrally named config, auto-memory off):**

| file | contents | sha256 |
|---|---|---|
| `probe_runs-clean-2026-09-03.tar.gz` (63 MB) | 3,320 run directories (`S2_<model>__<probe>[@<template>]__rep<N>`, reps 1001–1020; baseline series 1001/1101/1201/1301/1401) | `5709e67b0ac885a8cca613db8bdbf95b5de6b47c0c72749181030223fb37ac57` |
| `claude-code-transcripts-clean-2026-09-03.tar.gz` (57 MB) | 3,430 JSONL transcripts written under the isolated config (`~/work/.iso/projects/`), keyed by run path | `2bc025f366ee54690a4085ddf9c583c59ef69a42422c54923f81e89286cd108d` |

**Earlier run (Appendix C; exploratory batches, Appendix A, and the first full pass over the same cells, 2026-08-28 to 2026-09-02):**

| file | contents | sha256 |
|---|---|---|
| `probe_runs-2026-09-02.tar.gz` (82 MB) | 4,454 run directories (`BLAND_…` and pre-neutral-path dirs; rep ranges per batch in `batches/`) | `d825fea04e3de81695949cd9c3ce8d021be4d17fe9c45de149d8a5c87d1cd168` |
| `claude-code-transcripts-2026-09-02.tar.gz` (114 MB) | 5,264 JSONL transcripts (`cfg/projects/`) | `ea4b30fdacb640aca6f999765b03989a424ca07a080103e68490ad1846872561` |

Checksums are also in `SHA256SUMS-2026-09-03` and `SHA256SUMS-2026-09-02` beside the archives. The 2026-08-30 archives are superseded by the 2026-09-02 ones, which contain them.

`probe_runs-*.tar.gz` — one directory per run: the agent's final repo state, `_stdout.txt`, `_status.txt`, `_diff.txt`, `.report.json`. (In a handful of runs the agent tidied the untracked `_stdout.txt` away; the transcript still holds the full session and the graders score repository state.) In both clean-run archives every `/home/lee` path has been rewritten to `/home/user` (in file contents and in the transcript directory names) before publication: agents in the deletion scenarios searched the filesystem and their tool results swept up unrelated directory names from the study machine's home directory (Appendix C of the paper). Nothing else was altered, and the graders were run on the unscrubbed originals. Where an agent committed inside a run, the commit and the transcript carry the study machine's git identity (the author's name and email); the archives contain no credentials.
Graded results for every run are the `results/*_results.json` files in this repository; `make_results.py` regenerates `RESULTS.md` from them and `tools/compare_studies.py` produces the cell-by-cell comparison with the earlier run (`batches/study2_compare.md`).
