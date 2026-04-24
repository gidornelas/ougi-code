export const lines = [
  "                                ▄▄                               ▄▄          ",
  "                                ▀▀                               ██          ",
  " ▄█████▄   ██   ██   ▄██████   ███       ▄█████▄  ▄█████▄   ▄██████   ▄█████▄",
  " ██   ██   ██   ██   ██   ██    ██       ██   ▀▀  ██   ██   ██   ██   ██▄▄▄██",
  " ██▄▄▄██   ██▄▄▄██   ██▄▄▄██   ▄██▄      ██▄▄▄██  ██▄▄▄██   ██▄▄▄██   ██▄▄▄▄ ",
  "  ▀▀▀▀▀     ▀▀▀▀▀▀    ▀▀▀▀██   ▀▀▀▀       ▀▀▀▀▀    ▀▀▀▀▀     ▀▀▀▀▀▀    ▀▀▀▀▀ ",
  "                      █████▀                                                 ",
]

export const tagline = "Designer-engineer coding agent"

export function render() {
  return lines.join("\n")
}

export * as AnsiLogo from "./ansi-logo"
