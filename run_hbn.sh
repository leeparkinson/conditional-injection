#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
{ for c in HBN_secnec_baseline HBN_secnec_cond; do for r in 1 2 3 4 5 6; do echo "$c $r claude-sonnet-5 template_secret_nec task_secret_nec.md"; done; done
  for r in 1 2 3 4 5 6; do echo "HBN_secnec_cond $r claude-opus-5 template_secret_nec task_secret_nec.md"; done; } | xargs -P 8 -n 5 "$STUDY/run_bland.sh"
echo HBN_DONE
