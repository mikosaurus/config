local wezterm = require("wezterm")

local M = {}

---@param opts wezterm.key
---@param direction "left" | "down" | "up" | "right"
M.activate_pane = function(opts, direction)
	opts.action = wezterm.action_callback(function(win, pane)
		if
			pane:get_user_vars().IS_NVIM == "true"
			or pane:get_user_vars().IS_TMUX == "true"
			or pane:get_user_vars().IS_ZELLIJ == "true"
		then
			win:perform_action({ SendKey = { key = opts.key, mods = opts.mods } }, pane)
		else
			wezterm.background_child_process({
				"bash",
				"-ilc", -- For macOS users, use zsh instead
				"multiplexer activate_pane " .. direction,
			})
		end
	end)
	return opts
end

---@param opts wezterm.key
---@param direction "left" | "down" | "up" | "right"
---@param amount? number
M.adjust_pane = function(opts, direction, amount)
	opts.action = wezterm.action_callback(function(win, pane)
		if
			pane:get_user_vars().IS_NVIM == "true"
			or pane:get_user_vars().IS_TMUX == "true"
			or pane:get_user_vars().IS_ZELLIJ == "true"
		then
			win:perform_action({ SendKey = { key = opts.key, mods = opts.mods } }, pane)
		else
			wezterm.background_child_process({
				"bash",
				"-ilc", -- For macOS users, use zsh instead
				"multiplexer resize_pane " .. direction,
			})
		end
	end)
	return opts
end

return M
