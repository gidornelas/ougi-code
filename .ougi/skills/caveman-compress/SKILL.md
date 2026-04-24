# caveman-compress

## Purpose
Compress high-frequency memory and operational prose into lower-token form.

## When to Use
- Context window pressure.
- AGENTS.md or notes are verbose.
- Operational mode needs to be lean.

## Behavior
- Remove filler words (just, really, basically).
- Drop articles where meaning preserved.
- Use abbreviations and fragments.
- Preserve exact technical tokens.

## Checklist
- [ ] Code untouched
- [ ] File paths untouched
- [ ] URLs, versions, identifiers untouched
- [ ] Dates and numbers untouched
- [ ] Meaning preserved
- [ ] Backup created

## Safe Boundaries
- Never compress exact technical tokens.
- Keep human-readable backup.
- Reversible when possible.
- Applied only to prose and memory files.
