import { TextAttributes } from "@opentui/core"
import { createMemo, createSignal, For, Show, onMount } from "solid-js"
import * as fs from "node:fs"
import * as path from "node:path"
import { useSDK } from "@tui/context/sdk"
import { useSync } from "@tui/context/sync"
import { useTheme } from "@tui/context/theme"
import { useDialog } from "@tui/ui/dialog"
import { DialogSelect } from "@tui/ui/dialog-select"
import { useToast } from "@tui/ui/toast"

interface StackPreset {
  name: string
  description: string
  model: string
  small_model: string
  agents: Record<string, string>
  external_lanes?: Record<string, string>
}

function getStackModelLines(preset: StackPreset) {
  return [
    { label: "main", value: preset.model },
    { label: "small", value: preset.small_model },
    ...Object.entries(preset.agents).map(([agent, model]) => ({
      label: agent,
      value: model,
    })),
  ]
}

function getExternalLaneLines(preset: StackPreset) {
  return Object.entries(preset.external_lanes ?? {}).map(([lane, description]) => ({
    label: lane,
    value: description,
  }))
}

function getStackSearchText(preset: StackPreset) {
  return [
    preset.name,
    preset.description,
    preset.model,
    preset.small_model,
    ...Object.entries(preset.agents).flatMap(([agent, model]) => [agent, model]),
    ...Object.entries(preset.external_lanes ?? {}).flatMap(([lane, description]) => [lane, description]),
  ]
    .join(" ")
    .toLowerCase()
}

function formatStackLabel(label: string) {
  return `${label}:`.padEnd(14, " ")
}

function getRepoRoot() {
  return process.cwd()
}

export function loadStacks(): { name: string; preset: StackPreset }[] {
  const stacksDir = path.join(getRepoRoot(), ".ougi", "stacks")
  if (!fs.existsSync(stacksDir)) return []
  return fs
    .readdirSync(stacksDir)
    .filter((file) => file.endsWith(".json"))
    .map((file) => {
      const name = file.replace(".json", "")
      const content = fs.readFileSync(path.join(stacksDir, file), "utf-8")
      return { name, preset: JSON.parse(content) as StackPreset }
    })
    .sort((a, b) => a.name.localeCompare(b.name))
}

export function getActiveStack() {
  try {
    const activePath = path.join(getRepoRoot(), ".ougi", "active-stack")
    if (!fs.existsSync(activePath)) return undefined
    return fs.readFileSync(activePath, "utf-8").trim()
  } catch {
    return undefined
  }
}

function updateAgentModel(content: string, model: string) {
  const frontmatter = content.match(/^---\r?\n[\s\S]*?\r?\n---/)
  if (!frontmatter) return content
  const block = frontmatter[0]
  const updated = /^model:\s*.*$/m.test(block)
    ? block.replace(/^model:\s*.*$/gm, `model: ${model}`)
    : block.replace(/\r?\n---$/, `\nmodel: ${model}\n---`)
  return content.replace(block, updated)
}

export async function applyStack(stackName: string, preset: StackPreset) {
  const repoRoot = getRepoRoot()
  const configPath = path.join(repoRoot, "ougi.json")
  const agentsDir = path.join(repoRoot, ".ougi", "agents")
  const activeStackPath = path.join(repoRoot, ".ougi", "active-stack")
  const updatedAgents: string[] = []

  if (fs.existsSync(configPath)) {
    const config = JSON.parse(fs.readFileSync(configPath, "utf-8"))
    config.model = preset.model
    config.small_model = preset.small_model
    fs.writeFileSync(configPath, JSON.stringify(config, null, 4), "utf-8")
  }

  if (fs.existsSync(agentsDir)) {
    for (const [agentKey, model] of Object.entries(preset.agents)) {
      const agentPath = path.join(agentsDir, `${agentKey}.md`)
      if (!fs.existsSync(agentPath)) continue
      const content = fs.readFileSync(agentPath, "utf-8")
      fs.writeFileSync(agentPath, updateAgentModel(content, model), "utf-8")
      updatedAgents.push(agentKey)
    }
  }

  fs.mkdirSync(path.dirname(activeStackPath), { recursive: true })
  fs.writeFileSync(activeStackPath, stackName, "utf-8")
  return updatedAgents
}

export function DialogStack() {
  const dialog = useDialog()
  const sync = useSync()
  const toast = useToast()
  const sdk = useSDK()
  const { theme } = useTheme()
  const [query, setQuery] = createSignal("")

  onMount(() => {
    dialog.setSize("xlarge")
  })

  const stacks = createMemo(() => loadStacks())
  const activeStack = createMemo(() => getActiveStack())

  const options = createMemo(() => {
    const needle = query().trim().toLowerCase()
    return stacks()
      .map((item) => {
        const isActive = item.name === activeStack()
        const modelLines = getStackModelLines(item.preset)
        const externalLaneLines = getExternalLaneLines(item.preset)
        return {
          key: item.name,
          value: item.name,
          title: `${item.preset.name || item.name}${isActive ? " [active]" : ""}`,
          description: item.preset.description,
          gutter: isActive ? <text fg={theme.success}>*</text> : undefined,
          footer: (
            <box flexDirection="column">
              <For each={modelLines.slice(0, 2)}>
                {(line) => (
                  <text>
                    <span style={{ fg: theme.info }}>{formatStackLabel(line.label)}</span>
                    <span style={{ fg: theme.text }}>{line.value}</span>
                  </text>
                )}
              </For>
            </box>
          ),
          details: (
            <box flexDirection="column" gap={1}>
              <box flexDirection="column">
                <text fg={theme.secondary} attributes={TextAttributes.BOLD}>
                  Agents
                </text>
                <For each={modelLines.slice(2)}>
                  {(line) => (
                    <text>
                      <span style={{ fg: theme.info }}>{formatStackLabel(line.label)}</span>
                      <span style={{ fg: theme.text }}>{line.value}</span>
                    </text>
                  )}
                </For>
              </box>
              <Show when={externalLaneLines.length > 0}>
                <box flexDirection="column">
                  <text fg={theme.secondary} attributes={TextAttributes.BOLD}>
                    External lanes
                  </text>
                  <For each={externalLaneLines}>
                    {(line) => (
                      <text wrapMode="word">
                        <span style={{ fg: theme.primary }}>{formatStackLabel(line.label)}</span>
                        <span style={{ fg: theme.textMuted }}>{line.value}</span>
                      </text>
                    )}
                  </For>
                </box>
              </Show>
            </box>
          ),
          lines: modelLines.length + externalLaneLines.length + 5,
          layout: "stacked" as const,
          onSelect: () => {
            if (isActive) {
              toast.show({
                variant: "info",
                message: `Stack ${item.name} is already active`,
              })
              dialog.clear()
              return
            }

            void applyStack(item.name, item.preset)
              .then(async (updatedAgents) => {
                await sdk.client.instance.dispose()
                await sync.bootstrap({ fatal: false })
                toast.show({
                  variant: "success",
                  message:
                    updatedAgents.length > 0
                      ? `Stack ${item.name} applied. Updated: ${updatedAgents.join(", ")}`
                      : `Stack ${item.name} applied`,
                })
                dialog.clear()
              })
              .catch((error) => {
                toast.error(error)
              })
          },
        }
      })
      .filter((option) => {
        if (!needle) return true
        const stack = stacks().find((item) => item.name === option.value)
        if (!stack) return false
        return getStackSearchText(stack.preset).includes(needle)
      })
  })

  return (
    <DialogSelect
      title="Select Stack Preset"
      placeholder="Search stacks..."
      options={options()}
      onFilter={setQuery}
      current={activeStack()}
    />
  )
}
