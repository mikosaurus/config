-- Pull in the wezterm API
local wezterm = require("wezterm")
local keys = require("keys")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

config.font_size = 10
-- config.color_scheme = "Catppuccin Mocha"
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

config.hide_tab_bar_if_only_one_tab = true

config.keys = keys.keys

config.adjust_window_size_when_changing_font_size = false
config.enable_wayland = false

wezterm.on("gui-startup", function(cmd)
	local mux = wezterm.mux
	mux.spawn_window({ workspace = "mks" })
	mux.spawn_window({ workspace = "work" })
	mux.set_active_workspace("mks")
end)

-- Finally, return the configuration to wezterm:
return config
