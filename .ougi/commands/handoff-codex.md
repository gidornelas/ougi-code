# /handoff-codex

Prepare a clean Codex review handoff.

## Usage
/handoff-codex

## Output Format
```
## Codex Review Handoff

### Project Context
[repository purpose and stack]

### Summary of Changes
[what changed and why]

### Key Files to Review
- file/path/1
- file/path/2

### Likely Risks
- risk 1
- risk 2

### Review Prompt
Review the above changes for:
- correctness
- edge cases
- security
- performance
- maintainability
```

## Behavior
- Collects current context from active stack.
- Lists recently modified files.
- Summarizes known risks.
- Generates copy-paste ready prompt.
