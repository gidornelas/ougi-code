# ux-guard

## Purpose
Catch visual hierarchy, accessibility, and interaction issues early.

## When to Use
- After UI component changes.
- Before merging frontend PRs.
- When accessibility concerns arise.

## Behavior
Scans for:
- Missing alt text, labels, or ARIA.
- Color-only information.
- Poor contrast ratios.
- Unclear focus states.
- Inconsistent spacing or typography.

## Checklist
- [ ] All images have alt text
- [ ] Interactive elements have visible focus
- [ ] Color is not sole information carrier
- [ ] Heading hierarchy is logical
- [ ] Touch targets are adequate

## Safe Boundaries
- Does not change business logic.
- Does not modify API contracts.
- Flags only; does not auto-fix without approval.
