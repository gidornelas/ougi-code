# /token-mode <mode>

Switch operational language mode.

## Usage
/token-mode lean
/token-mode normal

## Behavior
Sets a marker file at `.ougi/mode`. Agents and skills can read this to adjust operational language. Does not automatically modify prompts or rules.

- `lean`: Compact operational language marker.
- `normal`: Standard operational language marker.

## Safety
- Does not modify code or technical tokens.
- Marker file is read-only signal.
- Easy revert.

