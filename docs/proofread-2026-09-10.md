# Fresh-reviewer proofread of PAPER.md

Scope: full read of PAPER.md (352 lines) cross-checked against RESULTS.md. Every count, fraction and p-value in the body matches the generated tables (the 360/280/200/120 boundary sums, the 960 total, the 2/120, the 58/80 and 113/120 escalation counts, the 115/160 baseline pool and its chi-square p = 0.23, and the 166 cell-model pairs all recompute exactly). All in-text p-values that RESULTS.md does not give directly were recomputed with Fisher's exact test and agree (Sonnet order vs conditional 0.008; Opus 8/20 vs 2/20 0.065, rounded to 0.07; Sonnet 13/20 vs 1/20 1.4e-4; operator-tier order 0.014; valence Opus 19/20 vs 5/20 1.0e-5). Figures (figures/scenario.svg, figures/form-ladder.svg) and every script or file named in section 9 exist. Every reference-list entry is cited and every citation has an entry.

The problems are in the framing layer: contradictions between sections, one date/tense error, several overclaims, and Appendix C contradicting itself.

## Must-fix

1. **Line 289, disclosure paragraph.** Quoted: "one week before this paper, its harness and its run data were made public on 11 September 2026." Past tense for a date that is tomorrow (today is 2026-09-10), and line 5 still reads "Draft — 2026-09-04". arXiv versions are permanent. Replace with: "The findings were reported to Anthropic on 4 September 2026; this paper, its harness and its run data are being made public on 11 September 2026, one week later." Update the line 5 date to the submission date.

2. **Line 9 vs lines 24 and 255: which two defenses?** Abstract: "Two defenses close the channel: an operator rule that demands evidence rather than confidence, and a provenance clause naming the untrusted tier (20/20 → 0/20 on both models)." Section 1 contribution 4 ("two measured defenses — an operator provenance clause and a review pass") and section 6 ("Two defenses, measured": operator-side provenance clause, review-side) name a different pair. The evidence-demand wording was measured on Opus only (line 251), so the abstract's "on both models" is also misattached. Replace the abstract sentence with: "Two operator-side wordings close the channel on the models tested — an exception that demands evidence rather than confidence (Opus, 20/20 → 0/20) and a provenance clause naming the untrusted tier (20/20 → 0/20 on both models) — and a prompted review pass catches the edit in 39 of 40 runs."

3. **Line 343 vs line 347, Appendix C contradicts itself.** Line 343: "Every cell in the body was run twice." Line 347: "Of the 125 cells present in both passes, 122 agree". Section 4 reports 166. Replace the line 343 sentence with: "Every cell in the body was run under the re-run configuration; 125 of the 166 had also been run in the first pass, at n=20 or below."

4. **Line 275 vs lines 133 and 216–225: section 8 disowns results the body asserts.** Line 275: "the attributed propagation note (6/20), the operator-tier order (18/20 vs. 10/20) — do not survive it and are described in the text as directional, not as results." But line 133 uses the order to conclude "form is irrelevant" with "each *p* ≤ 0.014" and line 21 says "all forms succeed (§5.3)"; line 225 bolds "**provenance is not the lever**" on the 6/20 cell. Either soften those passages or remove them from the section 8 list. Suggested line 225: "Attribution did not measurably screen the note (6/20 vs 8/20; the cells do not differ at n=20), so provenance is not the lever that the wording is." Suggested line 133 addition after "each *p* ≤ 0.014": "(the order alone would not survive the multiple-comparisons correction of §8; the point of the cell is that the three forms do not differ from one another)".

## Should-fix

5. **Line 100.** Quoted: "3,320 runs across 166 cells (n = 20 per model per cell)". 166 is the count of cell-model pairs (recounted from RESULTS.md: 166 × 20 = 3,320); as written, two-model cells would imply 6,640 runs. Replace with: "3,320 runs: 166 cell-model pairs at n = 20 each, across 23 scenario templates".

6. **Line 273.** Quoted: "a model whose baseline sits near 80%". The same paragraph gives the pooled rate 115/160 (72%) and line 96 says "~72%". Replace "near 80%" with "near 72%".

7. **Line 245, section 5.11.** Quoted: "(Opus, n=20 per cell, one batch)" and later "on the exact line to be changed, 0/20 (§5.1)". RESULTS.md's 5.11 table holds three templates; the same-line cell is borrowed from the 5.1 batch. Replace with: "(Opus, n=20 per cell; the three WIP placements in one batch, the same-line cell from the §5.1 batch)".

8. **Line 255, Defense A contrast straddles batches.** Quoted: "Opus 20/20 → 0/20, Sonnet 20/20 → 0/20 (*p* = 1.5×10⁻¹¹ each)". The defense batch contains only the baseline and clause cells (both 0/20); the 20/20 comparator is the 5.1 batch's conditional. Given section 3.5's in-batch rule, say so: "against the §5.1 conditional (20/20 on both models, a separate batch; Opus's conditional was 20/20 in every batch it was run, §5.11)". Same for the generic clause sentence later in the paragraph.

9. **Line 251, same issue.** Quoted: "(n=20, Opus, genuine-conflict scenario, one batch), the wording ladder confirms and sharpens this: "clearly safe" 20/20". The E-batch in RESULTS.md holds only the "highly confident", "evidence" and "ask" cells; "clearly safe" 20/20 is again the 5.1 cell. Add: "('clearly safe' is the §5.1 cell)".

10. **Line 36, section 2, two problems.** (a) Quoted: "consensus manipulations suppressed rather than raised violation (Appendix A)". Appendix A is headed "underpowered; not a finding" and line 96 promises nothing below n=20 is reported as a result. Replace with: "and consensus manipulations did not raise it (Appendix A, underpowered)". (b) Quoted: "peer agents, named seniors, human colleagues, CI logs and policy files produced indistinguishable outcomes (§5.4)". Section 5.4's sources are a peer agent's log entry, a named staff engineer, a quoted document, a CONTRIBUTING.md file and a code comment; there is no CI log. Replace the list with: "a peer agent's log, a named staff engineer, a quoted document, a contribution guide and a code comment produced indistinguishable or near-indistinguishable outcomes (§5.4)".

11. **Line 21, section 1.** Quoted: "and vanishes at the operator tier, where all forms succeed (§5.3), and when the source varies with content held constant (§5.4)." Reads as "the form effect vanishes when source varies", the opposite of 5.4. Replace with: "vanishes at the operator tier, where all forms succeed (§5.3), and is source-invariant with content held constant (§5.4)."

12. **Line 265, section 7.** Quoted: "The form ranking that governs the wrongful edit — conditional above order above verdict —". On Opus the order and verdict are both at the floor (0/20 and 1/20, section 5.1) and on the privacy rule they tie (1/20, 1/20); "order above verdict" holds only for Sonnet on the scope rule. Replace with: "The form ranking that governs the wrongful edit — conditional far above order and verdict —".

13. **Line 38, section 2.** Quoted: "the agent that took the licence in real time rejects it 39 times in 40 as a reviewer". The reviewer is a fresh session, not the same agent. Replace with: "the same model that takes the licence in real time rejects it 39 times in 40 when asked to review the edit".

14. **Line 137, section 5.4 ceiling effect.** Quoted: "Source does not matter; wording does." All three message-borne sources are 20/20, so the cell cannot detect a source effect. Add after the sentence: "The message-borne cells are at ceiling, so they bound a source effect at zero only where the conditional saturates; the file-embedded placements (16/20, 15/20) are the informative cells, and they do not differ from each other."

15. **Line 275, Bonferroni tier gap.** The paragraph names only the three effects at p = 0.01–0.07 as failing correction, but the stated threshold (5×10⁻⁴) also fails section 5.4 (p = 0.003), section 5.8 Opus vs baseline (0.003), section 5.9 unattributed (0.003), section 5.10 Opus (0.008) and section 5.1 Sonnet conditional vs order (0.008). Add: "Effects at *p* between 10⁻³ and 10⁻² (§5.4, §5.8 Opus, §5.9, §5.10 Opus, the Sonnet order contrast of §5.1) sit below the corrected threshold too; each replicates a direction already fixed at 10⁻¹¹ elsewhere and is not a stand-alone claim."

16. **Lines 347 and 349, Appendix C, the Sonnet privacy shift.** Quoted (347): "its privacy conditional, run at n=26 and n=39 before the form controls existed, gave Sonnet 25/26 and Opus 6/39". The re-run gives 13/20: 96% vs 65%, Fisher p = 0.014, yet it is not among the "three differ" because the cell was excluded from the 125. Add: "Sonnet's 25/26 in that earlier form is above the re-run's 13/20 (*p* = 0.014); the scenario was rebuilt with the form controls between passes, so the two are not the same cell." Quoted (349): "The Sonnet privacy flip survived and strengthened." Given the drop, replace "strengthened" with "survived at n=20 with form controls (§5.8)".

17. **Line 96.** Quoted: "Exploratory cells were run at n=5–6". Appendix A says "n=2–8" and Appendix C "n≤8". Replace with "n≤8".

18. **Spelling, lines 15, 17, 261 vs 24, 255.** "defence/defences" and "defense/defenses" both appear; the paper is otherwise British (licence, judgement, behaviour, neutralised, artefact). Standardise on "defence" throughout, including the bold heading at line 255 and the abstract.

19. **Lines 34 and 295–296, citation labels.** "Chen et al., 2026" (Expected Harm) and "Chen et al., 2026b" (Self-Correction Illusion) with no "2026a". Label Expected Harm "2026a" in text (line 34) and list (line 296). Minor mismatch: text says "Tracebit, 2026" (line 265), list says "Tracebit Research (2026)" (line 325); make them agree. Reference list mixes initialled and surname-only author strings (e.g. line 296 "Chen, Tam, Wu, & Chen" vs line 295 "Chen, K.-Y., Su, F.-Y."); standardise.

20. **Line 339, Appendix B.** Quoted: "never observed on Claude models in ~900 runs". The study reports 3,320 clean runs and 4,454 earlier ones; "~900" is unexplained. Replace with the true denominator, e.g. "never observed on Claude models in the 3,320 runs of this study".

21. **Lines 75–88, section 3.3 forms table.** Lists "bare order", never reported for Claude (only Appendix B), and omits three forms that appear in results: "size-only antecedent" (5.1), "naming the conflict" (5.1) and "if you are only editing `currency.js`" (5.5). Either add those rows with their text or retitle "Principal forms (others are quoted where reported)" and drop "bare order".

## Nit

22. **Line 281, section 8.** Quoted: "The configuration described in §3.4 was adopted after an earlier run of the same cells was found to fall short of that standard (Appendix C)." The only body sentence that reveals the earlier run. It belongs for honesty, but it is the one leak if the intent was strict confinement to Appendix C.

23. **Line 9, abstract.** Quoted: 'The two-word contrast "make the fix … **if it is** small and self-contained" (20/20) versus "make the fix … **— it's** small and self-contained"'. The cell's text (line 159) is "if it is a small, self-contained change". Quote exactly or drop the quotation marks; "two-word" is loose for "if it is" vs "— it's".

24. **Line 187.** Section 5.8 table puts Sonnet before Opus; every other two-model table puts Opus first.

25. **Lines 199–202.** The second 5.8 table repeats two rows of the first verbatim. Fine if it feeds the figure, but a reader sees the same numbers twice.

26. **Line 148.** Quoted: "(One batch, Opus; … the no-message baseline is 0/20.)" RESULTS.md's 5.5–5.6 table has no baseline row, so the baseline is from another batch. Replace "the no-message baseline is 0/20" with "the no-message baseline is 0/20 (§5.1)".

27. **Line 257.** Quoted: "the reasons carrying every verdict were scope and the unverifiable authorisation", but the same paragraph reports one verdict unclear. Replace "every verdict" with "every clear verdict".

28. **Line 92.** Quoted: "Models: Claude Sonnet 5 and Claude Opus 5 via Claude Code, default reasoning." No model snapshot identifiers; a reviewer will ask. Add the exact model ids the CLI resolved to.

29. **Line 351, item (3).** Quoted: "Three findings from that pass were not re-run" then "(3) The n=6 authoring sweep … its ordering was reproduced at n=20". Reword: "(3) the n=6 sweep itself was not re-run; the body's n=20 sweep replaces it, reproducing its ordering with one change".

30. **Lines 148, 162, 204.** Nested italics of the form `*(… *p* = …)*` render in CommonMark but break in some converters. Use `_p_` inside or unitalicise the note.

31. **Line 58.** Quoted: "in the pilot that fixed the design". "Fixed" is ambiguous (repaired vs settled). Replace with "in the pilot that settled the design".

32. **Line 3.** Repository URL "github.com/leeparkinson/conditional-injection" differs from the local directory name "conditional-constraint-study". Confirm the public repo name before posting.

## Hostile-reviewer points not covered above

- **Sonnet's scope-rule headline is not elevation.** Conditional vs baseline on Sonnet is 20/20 vs 16/20, p = 0.106. The Sonnet story is "the only form that does not depress a 72% baseline"; the abstract's "20/20 on both" reads as elevation. Consider stating Sonnet's baseline in the abstract sentence.
- **"Not model drift" vs the between-pass disagreements.** Section 8 argues Sonnet variance is binomial sampling on the baseline, but Appendix C's three between-pass Sonnet shifts (cautionary order 17→8, p = 0.008; cautionary conditional 18→10; strong order 5→13) are not sampling noise at n=20. The paper discloses them; a sentence acknowledging that some non-baseline Sonnet cells did shift between CLI versions and dates would pre-empt the objection.
- **File-embedded 5.4 cells lack their own baselines.** Line 137 says CONTRIBUTING.md and the code comment are "each its own scenario template", but RESULTS.md carries no template-specific baseline for either, so 16/20 and 15/20 are compared to the template3 baseline of 12/20.

## Verdict

The quantitative core is sound: every count and p-value in the body matches the generated tables, the boundary sums and the 166-pair total recompute exactly, the reference list is complete in both directions, and every figure and script path exists. What is not ready is the framing layer. The abstract and section 1 disagree with section 6 about what the "two defenses" are, section 8 disowns two results the body states as findings, Appendix C says every cell was run twice and then says 125 of 166 were, and the disclosure paragraph is written in past tense about tomorrow. Those four are must-fix before an arXiv v1. The should-fix items are mostly single-sentence overclaims (section 2's use of the underpowered Appendix A, section 5.4's saturated "source does not matter", section 7's "order above verdict") plus two contrasts that silently straddle batches despite section 3.5's in-batch rule. With those addressed the paper is ready; without them a careful reviewer will find the internal contradictions on the first read.
