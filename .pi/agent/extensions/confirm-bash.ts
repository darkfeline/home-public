import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		if (isToolCallEventType("bash", event)) {
			const { command } = event.input;

			// Ask for confirmation using the TUI confirm dialog
			const confirmed = await ctx.ui.confirm(
				"Execute Bash Command?",
				`The agent wants to run the following command:\n\n${command}\n\nDo you want to allow this?`
			);

			if (!confirmed) {
				// Block the tool execution and provide a reason
				return { block: true, reason: "Command execution cancelled by user." };
			}
		}
	});
}
