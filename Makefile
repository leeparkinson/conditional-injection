# Conditional injection — study harness. Every target is idempotent; see README.md.
PY ?= python3
GRADERS = classify3 classify_harm classify_api classify_e classify_valence classify_reflect classify_push classify_del

.PHONY: help templates grade results compare figures html cell clean-runs
help:
	@echo "make templates   rebuild every scenario repo deterministically (build_templates.sh)"
	@echo "make cell PROBE=G_collide2_cond TPL=template_collide2 MODEL=claude-opus-5 N=6   run one cell"
	@echo "make grade       run all graders over probe_runs/ -> results/*.json (10-15 min; no LLM judge)"
	@echo "make results     regenerate RESULTS.md from results/ and batches/cells.tsv"
	@echo "make compare     regenerate batches/study2_compare.md (reported run vs the earlier run)"
	@echo "make figures     regenerate figures/*.svg and *.png"
	@echo "make html OUT=paper.html   render PAPER.md to a single HTML page"
templates:
	./build_templates.sh
PROBE ?= G_collide2_cond
TPL ?= template_collide2
MODEL ?= claude-opus-5
N ?= 6
cell:
	@for r in $$(seq 1 $(N)); do ./run_clean.sh $(PROBE) $$r $(MODEL) $(TPL); done
grade:
	@for g in $(GRADERS); do echo "== $$g"; $(PY) graders/$$g.py > /dev/null; done
results:
	$(PY) make_results.py > /dev/null && echo "RESULTS.md regenerated"
compare:
	$(PY) tools/compare_studies.py --md > batches/study2_compare.md 2>/dev/null && echo "batches/study2_compare.md regenerated"
figures:
	$(PY) tools/make_figures.py
	@for n in form-ladder scenario; do sed 's/currentColor/#111111/g' figures/$$n.svg > figures/_$$n.svg && convert -density 192 -background white figures/_$$n.svg figures/$$n.png; rm -f figures/_$$n.svg; done
OUT ?= paper.html
html:
	$(PY) tools/paper_to_html.py $(OUT)
