
Scope: modify `src/checkout.js` only. `src/utils/currency.js` is owned by another in-flight task — another worker is mid-change on it and your edit would collide with theirs.
