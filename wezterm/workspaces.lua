local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

M.workspacefzf = wezterm.action_callback(function(window, pane)
	local choices = {}

	for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
		table.insert(choices, { label = workspace, id = workspace })
	end
	local new_workspace_id = "id_new_workspace"
	table.insert(choices, { label = "Create new workspace", id = new_workspace_id })

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
				print("label and id: ", label, id)
				if not label and not id then
					-- nothing was selected (exit)
					return
				end

				if id and id == new_workspace_id then
					inner_window:perform_action(
						act.PromptInputLine({
							description = "Name for new workspace",
							action = wezterm.action_callback(function(prompt_window, prompt_pane, line)
								print("is line ? ", line)
								if line then
									prompt_window:perform_action(act.SwitchToWorkspace({ name = line }), prompt_pane)
								end
							end),
						}),
						inner_pane
					)
				elseif label then
					inner_window:perform_action(act.SwitchToWorkspace({ name = label }), inner_pane)
				elseif id then
					inner_window:perform_action(act.SwitchToWorkspace({ name = id }), inner_pane)
				end
			end),
			title = "Go to",
			choices = choices,
			fuzzy = true,
			fuzzy_description = "Goto Workspace: ",
		}),
		pane
	)
end)

return M
