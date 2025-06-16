-- Pull in the wezterm API
local wezterm = require("wezterm")
local my_plugin = wezterm.plugin.require("/home/anders/github.com/mikosaurus/wezterm-sessionizer")

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

local superReload = wezterm.action_callback(function()
	wezterm.plugin.update_all()
	wezterm.reload_configuration()
end)

config.keys = {
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = superReload,
	},
}

-- Finally, return the configuration to wezterm:
return config
