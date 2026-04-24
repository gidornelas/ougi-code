# bug-triage

## Purpose
Systematically diagnose unexpected behavior and test failures.

## When to Use
- Tests fail.
- Bug reports arrive.
- Behavior deviates from spec.

## Behavior
1. Reproduce consistently.
2. Isolate minimal trigger.
3. Identify root cause.
4. Propose fix with risk assessment.
5. Verify fix does not regress.

## Checklist
- [ ] Reproduced in clean environment
- [ ] Root cause identified
- [ ] Fix is minimal
- [ ] Tests cover the fix
- [ ] Edge cases considered

## Safe Boundaries
- No production data access.
- No permanent environment changes.
- Escalates security bugs to human.
