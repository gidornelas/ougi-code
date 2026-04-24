export * as ConfigPaths from "./paths"

import path from "path"
import { Filesystem } from "@/util"
import { Flag } from "@/flag/flag"
import { Global } from "@/global"
import { unique } from "remeda"
import { JsonError } from "./error"
import * as Effect from "effect/Effect"
import { AppFileSystem } from "@opencode-ai/shared/filesystem"

export const LOCAL_CONFIG_DIRS = [".ougi", ".opencode"] as const

function names(name: string) {
  if (name !== "opencode") return [`${name}.jsonc`, `${name}.json`]
  return ["ougi.jsonc", "ougi.json", "opencode.jsonc", "opencode.json"]
}

export const files = Effect.fn("ConfigPaths.projectFiles")(function* (
  name: string,
  directory: string,
  worktree?: string,
) {
  const afs = yield* AppFileSystem.Service
  return (yield* afs.up({
    targets: names(name),
    start: directory,
    stop: worktree,
  })).toReversed()
})

export const directories = Effect.fn("ConfigPaths.directories")(function* (directory: string, worktree?: string) {
  const afs = yield* AppFileSystem.Service
  return unique([
    Global.Path.config,
    ...(!Flag.OPENCODE_DISABLE_PROJECT_CONFIG
      ? yield* afs.up({
          targets: [...LOCAL_CONFIG_DIRS],
          start: directory,
          stop: worktree,
        })
      : []),
    ...(yield* afs.up({
      targets: [...LOCAL_CONFIG_DIRS],
      start: Global.Path.home,
      stop: Global.Path.home,
    })),
    ...(Flag.OPENCODE_CONFIG_DIR ? [Flag.OPENCODE_CONFIG_DIR] : []),
  ])
})

export function fileInDirectory(dir: string, name: string) {
  if (name !== "opencode") return [path.join(dir, `${name}.json`), path.join(dir, `${name}.jsonc`)]
  return [
    path.join(dir, "ougi.json"),
    path.join(dir, "ougi.jsonc"),
    path.join(dir, "opencode.json"),
    path.join(dir, "opencode.jsonc"),
  ]
}

/** Read a config file, returning undefined for missing files and throwing JsonError for other failures. */
export async function readFile(filepath: string) {
  return Filesystem.readText(filepath).catch((err: NodeJS.ErrnoException) => {
    if (err.code === "ENOENT") return
    throw new JsonError({ path: filepath }, { cause: err })
  })
}
