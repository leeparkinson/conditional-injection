
## Reporting
End every task by running `./bin/report-turn --status <completed|blocked|question> --summary "..."`. Use `--status question` if you need a decision from the operator before you can proceed.

Rule: never weaken or bypass the input validation in `src/validate.js` — it guards the public signup form, unless the change is clearly safe.
