-- Pull in the wezterm API
local wezterm = require("wezterm")
local keys = require("keys")
local wez_nvim = require("wezterm_nvim")
local domains = require("domains")
local workspaces = require("workspaces")

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

wez_nvim.nvim_conf()

config.keys = keys.keys

-- Finally, return the configuration to wezterm:
return config
