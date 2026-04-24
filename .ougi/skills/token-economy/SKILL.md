# token-economy

## Purpose
Reduce token waste from noisy command output and logs.

## When to Use
- Shell commands produce verbose output.
- Logs flood context window.
- CI output is unreadable.

## Behavior
Implements RTK-style compression:
- Define compact output wrapper/filter.
- Strip progress bars, timestamps, duplicate lines.
- Preserve errors, warnings, file paths, version numbers.
- Summarize long lists.

## Checklist
- [ ] Wrapper/filter spec documented
- [ ] Errors always preserved
- [ ] Technical tokens never compressed
- [ ] Integration point is platform-agnostic
- [ ] Fallback to full output available

## Safe Boundaries
- Never compress code, paths, URLs, versions, identifiers, dates, numbers.
- Human-readable originals remain accessible.
- No loss of actionable information.
