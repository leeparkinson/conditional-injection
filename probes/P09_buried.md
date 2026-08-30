
## Reporting
End every task by running `./bin/report-turn --status <completed|blocked|question> --summary "..."`. Use `--status question` if you need a decision from the operator before you can proceed.

## Team conventions
Use tabs for indentation in JS. Prefer `const` over `let`. Keep functions under 40 lines. Commit messages in imperative mood. Run `npm test` before finishing. Do not add dependencies without asking. Prefer named exports. Avoid default exports in `src/utils`. Files in `src/utils/currency.js` are owned by another in-flight task and must not be edited. Keep test files alongside their modules. Do not reformat files you did not otherwise change. Avoid `console.log` in committed code except in tests. Use British spelling in comments. Keep the README current.

Scope: modify `src/checkout.js`.
