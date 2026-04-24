#!/usr/bin/env bun

import fs from "fs/promises"
import path from "path"
import { fileURLToPath } from "url"

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const dir = path.resolve(__dirname, "..")

const MESSAGE_MODULE = `// File generated from our OpenAPI spec by Stainless. See CONTRIBUTING.md for details.
import { APIResource } from "../../core/resource.mjs";
import { MessageStream } from "../../lib/MessageStream.mjs";
import * as BatchesAPI from "./batches.mjs";
import { Batches } from "./batches.mjs";
import { MODEL_NONSTREAMING_TOKENS } from "../../internal/constants.mjs";
export class Messages extends APIResource {
    constructor() {
        super(...arguments);
        this.batches = new BatchesAPI.Batches(this._client);
    }
    create(body, options) {
        if (body.model in DEPRECATED_MODELS) {
            console.warn(\`The model '\${body.model}' is deprecated and will reach end-of-life on \${DEPRECATED_MODELS[body.model]}\\nPlease migrate to a newer model. Visit https://docs.anthropic.com/en/docs/resources/model-deprecations for more information.\`);
        }
        let timeout = this._client._options.timeout;
        if (!body.stream && timeout == null) {
            const maxNonstreamingTokens = MODEL_NONSTREAMING_TOKENS[body.model] ?? undefined;
            timeout = this._client.calculateNonstreamingTimeout(body.max_tokens, maxNonstreamingTokens);
        }
        return this._client.post('/v1/messages', {
            body,
            timeout: timeout ?? 600000,
            ...options,
            stream: body.stream ?? false,
        });
    }
    stream(body, options) {
        return MessageStream.createMessage(this, body, options);
    }
    countTokens(body, options) {
        return this._client.post('/v1/messages/count_tokens', { body, ...options });
    }
}
const DEPRECATED_MODELS = {
    'claude-1.3': 'November 6th, 2024',
    'claude-1.3-100k': 'November 6th, 2024',
    'claude-instant-1.1': 'November 6th, 2024',
    'claude-instant-1.1-100k': 'November 6th, 2024',
    'claude-instant-1.2': 'November 6th, 2024',
    'claude-3-sonnet-20240229': 'July 21st, 2025',
    'claude-3-opus-20240229': 'January 5th, 2026',
    'claude-2.1': 'July 21st, 2025',
    'claude-2.0': 'July 21st, 2025',
    'claude-3-7-sonnet-latest': 'February 19th, 2026',
    'claude-3-7-sonnet-20250219': 'February 19th, 2026',
};
Messages.Batches = Batches;
//# sourceMappingURL=messages.mjs.map
`

async function candidates(root: string) {
  const bunDir = path.join(root, "node_modules", ".bun")
  const exists = await fs.stat(bunDir).then(() => true).catch(() => false)
  if (!exists) return []
  const glob = new Bun.Glob("@anthropic-ai+sdk@*/node_modules/@anthropic-ai/sdk/resources/messages/messages.mjs")
  return Array.fromAsync(glob.scan({ cwd: bunDir, absolute: true }))
}

export async function repairAnthropicSdk() {
  const files = [
    ...(await candidates(dir)),
    ...(await candidates(path.resolve(dir, "../.."))),
  ]
  const unique = [...new Set(files)]
  const repaired: string[] = []

  for (const file of unique) {
    const stat = await fs.stat(file).catch(() => undefined)
    if (!stat || stat.size > 0) continue
    await fs.writeFile(file, MESSAGE_MODULE, "utf8")
    repaired.push(file)
  }

  if (repaired.length) {
    console.log(
      `repaired @anthropic-ai/sdk messages.mjs in ${repaired.length} location${repaired.length === 1 ? "" : "s"}`,
    )
  }
}

if (import.meta.main) {
  await repairAnthropicSdk()
}
