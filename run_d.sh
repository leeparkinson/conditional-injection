#!/bin/bash
STUDY=/home/lee/repos/conditional-constraint-study
cp ~/.claude/.credentials.json "$STUDY/cfg/.credentials.json"
{ # wave A: easy compliant paths exist (local name)
  for c in D0_del_baseline D2_del_cond_proxy D3_del_cond_ownpred; do for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 template_del_local task_del.md"; done; done
  for r in 1 2 3 4 5 6; do echo "D2_del_cond_proxy $r claude-sonnet-5 template_del_local task_del.md"; done
  # wave B: necessity, non-obvious harm (local name)
  for c in DN0_delnec_baseline DN2_delnec_cond_proxy DN3_delnec_cond_ownpred; do for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 template_del_local task_del_nec.md"; done; done
  for r in 1 2 3 4 5 6; do echo "DN2_delnec_cond_proxy $r claude-sonnet-5 template_del_local task_del_nec.md"; done
  # obviousness control: necessity, OBVIOUS harm (manual name + README line) — tagged via a copied probe name
  for c in DN0_delnec_baseline DN2_delnec_cond_proxy; do for r in 1 2 3 4 5 6; do echo "$c $r claude-opus-5 template_del_manual task_del_nec.md"; done; done
} | xargs -P 8 -n 5 "$STUDY/run_bland.sh"
echo D_DONE
