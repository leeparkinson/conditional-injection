#!/bin/bash
# Thread F: PII / weak-prior boundary — vendor-bound diagnostic (HD, template_pii_diag) and
# partner-facing pricing doc (HE, template_partner); baseline vs conditional, Opus + Sonnet, n=5, reps 501-505.
set -u
STUDY=$(cd "$(dirname "$0")/.." && pwd)
clash=0
for m in claude_opus_5 claude_sonnet_5; do
  for c in HD0_diag_baseline@pii_diag HD1_diag_cond@pii_diag HE0_partner_baseline@partner HE1_partner_cond@partner; do
    for r in 501 502 503 504 505; do [ -d "$STUDY/probe_runs/BLAND_${m}__${c}__rep$r" ] && { echo "CLASH $m $c rep$r"; clash=1; }; done
  done
done
[ $clash = 1 ] && { echo ABORT_PREFLIGHT; exit 1; }
for MODEL in claude-opus-5 claude-sonnet-5; do
  cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
  { for c in HD0_diag_baseline HD1_diag_cond; do for r in 501 502 503 504 505; do echo "$c $r $MODEL template_pii_diag task_pii_diag.md"; done; done
    for c in HE0_partner_baseline HE1_partner_cond; do for r in 501 502 503 504 505; do echo "$c $r $MODEL template_partner task_partner.md"; done; done
  } | xargs -P 6 -n 5 "$STUDY/run_bland.sh"
done
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
for d in "$STUDY"/probe_runs/BLAND_claude_*__H[DE]*__rep50[1-5]; do
  [ -d "$d" ] || continue; n=$(basename "$d")
  if [ ! -s "$d/_stdout.txt" ] || grep -qE "Failed to authenticate|session limit|OAuth session expired|API Error" "$d/_stdout.txt" 2>/dev/null; then
    model=claude-opus-5; [[ "$n" == *sonnet* ]] && model=claude-sonnet-5
    x=${n#BLAND_claude_opus_5__}; x=${x#BLAND_claude_sonnet_5__}
    probe=${x%%__rep*}; probe=${probe%%@*}; rep=${n##*__rep}
    tpl=template_pii_diag; taskf=task_pii_diag.md
    [[ "$probe" == HE* ]] && { tpl=template_partner; taskf=task_partner.md; }
    "$STUDY/run_bland.sh" "$probe" "$rep" "$model" "$tpl" "$taskf"
  fi
done
echo HF_DONE
