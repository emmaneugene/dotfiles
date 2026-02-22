import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("input", async (event, ctx) => {
    if (event.text.trim() === ":q") {
      ctx.shutdown();
      return { action: "handled" };
    }
  });
}
