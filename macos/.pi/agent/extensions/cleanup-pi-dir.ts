// FileSettingsStorage.withLock() unconditionally creates <cwd>/.pi/ on every
// startup, even when just reading project settings. This extension removes the
// directory at shutdown if it is still empty

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { existsSync, readdirSync, rmdirSync } from "node:fs";
import { join } from "node:path";

export default function (pi: ExtensionAPI) {
  pi.on("session_shutdown", async (_event, ctx) => {
    const piDir = join(ctx.cwd, ".pi");

    if (!existsSync(piDir)) return;

    try {
      if (readdirSync(piDir).length === 0) {
        rmdirSync(piDir); // non-recursive: will throw if somehow non-empty
      }
    } catch {
      // Best-effort cleanup — silently ignore any fs errors.
    }
  });
}
