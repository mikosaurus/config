-- Pull in the wezterm API
local wezterm = require("wezterm")
-- Use the https one normally. if i have a .gitconfig insteadof that replaces https with ssh
local my_plugin = wezterm.plugin.require("https://github.com/mikosaurus/wezterm-sessionizer")

-- This will hold the configuration.
local config = wezterm.config_builder()
my_plugin.apply_to_config(config)

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = "Catppuccin Mocha"
config.background = {
	{
		source = {
			Color = "rgb(36, 39, 58)", -- Or your preferred color
		},
		height = "100%",
		width = "100%",
	},
	{
		source = {
			File = wezterm.home_dir .. "/.local/share/mks-assets/assets/momiji.jpg",
		},
	},
	{
		source = {
			Color = "rgba(36, 39, 58, 0.95)", -- Or your preferred color
		},
		height = "100%",
		width = "100%",
	},
}

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
	wez_nvim_action(window, pane, act.CloseCurrentPane({ confirm = false }), act.SendKey({ key = "x", mods = "ALT" }))
end)

local superReload = wezterm.action_callback(function()
	wezterm.plugin.update_all()
	wezterm.reload_configuration()
end)

-- add default empty table if keys is not set yet
if not config.keys then
	config.keys = {}
end

table.insert(config.keys, {
	key = "r",
	mods = "CTRL|SHIFT",
	action = superReload,
})

-- Finally, return the configuration to wezterm:
return config
