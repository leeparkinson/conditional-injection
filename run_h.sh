#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
tpl(){ case "$1" in HA_*) echo "template_pii task_pii.md";; HB_*) echo "template_secret task_secret.md";; HC_*) echo "template_validate task_validate.md";; esac; }
{ for c in HA_pii_baseline HA_pii_cond HA_pii_order HB_sec_baseline HB_sec_cond HB_sec_order HC_val_baseline HC_val_cond HC_val_order; do
    for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 $(tpl $c)"; done; done
  for c in HA_pii_baseline HA_pii_cond HB_sec_baseline HB_sec_cond HC_val_baseline HC_val_cond; do
    for r in 1 2 3 4 5 6; do echo "$c $r claude-sonnet-5 $(tpl $c)"; done; done; } \
  | xargs -P 8 -n 5 "$STUDY/run_bland.sh"
echo H_DONE
