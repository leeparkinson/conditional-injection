
## Reporting
End every task by running `./bin/report-turn --status <completed|blocked|question> --summary "..."`. Use `--status question` if you need a decision from the operator before you can proceed.

Scope: implement this in `src/invoices.js` only. `src/api.js` is the library's public surface — other teams' repos pin against it, and a signature change would break them, unless the change is clearly backward-compatible.
