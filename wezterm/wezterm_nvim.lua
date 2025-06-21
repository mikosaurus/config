local wezterm = require("wezterm")

local M = {}

local mux = require("wezterm").mux

local nvim = wezterm.home_dir .. "/nvim/bin/nvim"

local wez_nvim_action = function(window, pane, action_wez, forward_key_nvim)
	local current_process = mux.get_window(window:window_id()):active_pane():get_foreground_process_name()
	if current_process == nvim then
		window:perform_action(forward_key_nvim, pane)
	else
		window:perform_action(action_wez, pane)
	end
end

M.nvim_conf = function()
	wezterm.on("move-left", function(window, pane)
		wez_nvim_action(
			window,
			pane,
			act.ActivatePaneDirection("Left"), -- this will execute when the active pane is not a nvim instance
			act.SendKey({ key = "h", mods = "CTRL" }) -- this key combination will be forwarded to nvim if the active pane is a nvim instance
		)
	end)

	wezterm.on("move-right", function(window, pane)
		wez_nvim_action(window, pane, act.ActivatePaneDirection("Right"), act.SendKey({ key = "l", mods = "CTRL" }))
	end)

	wezterm.on("move-down", function(window, pane)
		wez_nvim_action(window, pane, act.ActivatePaneDirection("Down"), act.SendKey({ key = "j", mods = "CTRL" }))
	end)

	wezterm.on("move-up", function(window, pane)
		wez_nvim_action(window, pane, act.ActivatePaneDirection("Up"), act.SendKey({ key = "k", mods = "CTRL" }))
	end)

	-- you can add other actions, this unifies the way in which panes and windows are closed
	-- (you'll need to bind <A-x> -> <C-w>q)
	wezterm.on("close-pane", function(window, pane)
		wez_nvim_action(
			window,
			pane,
			act.CloseCurrentPane({ confirm = false }),
			act.SendKey({ key = "x", mods = "ALT" })
		)
	end)
end

return M
