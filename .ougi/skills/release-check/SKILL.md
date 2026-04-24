# release-check

## Purpose
Validate release readiness before shipping.

## When to Use
- Before version tags.
- Before production deploy.
- After significant feature completion.

## Behavior
Runs:
- Lint and typecheck.
- Unit and integration tests.
- Build verification.
- Dependency audit.
- Changelog review.

## Checklist
- [ ] All checks pass
- [ ] No critical security advisories
- [ ] Changelog updated
- [ ] Version bumped
- [ ] Rollback plan documented

## Safe Boundaries
- Read-only on production.
- Does not deploy.
- Blocks but never forces.
