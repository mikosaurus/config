local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function get_domains(ssh_domains)
	local domains = {}

	for _, domain in ipairs(ssh_domains) do
		table.insert(domains, {
			id = domain:name(),
			label = domain:name(),
		})
	end

	return domains
end

local acclbk = function(window, pane, id, label)
	-- Open existing domain
	window:perform_action(
		act.SpawnCommandInNewTab({
			domain = { DomainName = id },
		}),
		pane
	)
end

M.domainfzf = function(ssh_domains)
	return act.InputSelector({
		action = wezterm.action_callback(acclbk),
		title = "",
		choices = get_domains(ssh_domains),
		fuzzy = true,
	})
end

return M
