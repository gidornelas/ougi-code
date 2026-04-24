# lean-ops

## Purpose
Enable compact operational language automatically via `.ougi/mode` marker.

## How It Works
The `token-mode` command writes `lean` or `normal` to `.ougi/mode`. All agents check this file via AGENTS.md rules and adjust language accordingly.

## When to Use
- High-frequency updates.
- Status reports.
- Operational chatter.

## Behavior
- Short sentences.
- Abbreviations accepted.
- Arrows for causality (X -> Y).
- One word when one word enough.

## Checklist
- [ ] Critical info still clear
- [ ] Technical tokens unchanged
- [ ] Human can still parse
- [ ] Easy to revert to normal mode

## Safe Boundaries
- Not for user-facing docs.
- Not for code comments explaining complex logic.
- Not for legal or compliance text.

