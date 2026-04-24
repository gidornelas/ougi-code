# /stack [<preset-name>]

Apply a stack preset to the active Ougi Code CLI configuration.

## Usage
/stack                  # Interactive picker
/stack go-balanced
/stack go-throughput
/stack hybrid-pro

## Behavior
1. Locate preset in `.ougi/stacks/<preset-name>.json`.
2. Update `ougi.json`:
   - `model`
   - `small_model`
3. Update `.ougi/agents/*.md` frontmatter:
   - each agent's `model`
4. Write active preset to `.ougi/active-stack`.
5. Print active stack summary.

`ougi.json` remains the runtime config file for the fork.

## Example Output
Stack: hybrid-pro
- build: opencode-go/kimi-k2.6
- plan: opencode-go/glm-5.1
- ux-engineer: opencode-go/kimi-k2.6
- reviewer: opencode-go/minimax-m2.7
- release: opencode-go/glm-5.1
- small_model: opencode-go/qwen3.5-plus
- external: codex, gpt-5.4

