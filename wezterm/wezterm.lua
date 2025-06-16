-- Pull in the wezterm API
local wezterm = require("wezterm")
local my_plugin = wezterm.plugin.require("file:///home/anders/github.com/mikosaurus/wezterm-sessionizer")

-- This will hold the configuration.
local config = wezterm.config_builder()

my_plugin.apply_to_config(config)

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = "Catppuccin Macchiato"

-- Finally, return the configuration to wezterm:
return config
