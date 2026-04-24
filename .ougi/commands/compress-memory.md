# /compress-memory <file-path>

Compress a memory or rules file into lower-token form.

## Usage
/compress-memory AGENTS.md
/compress-memory .ougi/notes/project-context.md

## Behavior
1. Read target file.
2. Apply caveman-compress rules:
   - Remove filler.
   - Abbreviate where safe.
   - Preserve exact technical tokens.
3. Write compressed version.
4. Preserve `.bak` backup if original does not already have one.

## Safety
- Never compress code blocks.
- Never compress file paths, URLs, versions, identifiers, dates, numbers.
- Always keep human-readable backup.
- Explicit file selection only â€” no auto-scan.

