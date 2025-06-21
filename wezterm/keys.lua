local wezterm = require("wezterm")
local workspace = require("workspace")
local domains = require("domains")
local ssh_domains = require("ssh_domains").ssh_domains
local act = wezterm.action

local M = {}
M.keys = {

	-- Domains
	{
		key = "p",
		mods = "LEADER|CTRL",
		action = domains.domainfzf(ssh_domains),
	},
	{
		key = "p",
		mods = "LEADER",
		action = domains.domainfzf(ssh_domains),
	},

	-- Workspaces
	{
		key = "o",
		mods = "LEADER",
		action = workspace.workspacefzf,
	},
	{
		key = "o",
		mods = "LEADER|CTRL",
		action = workspace.workspacefzf,
	},
	{
		key = "å",
		mods = "LEADER|CTRL",
		action = act.ShowLauncher,
	},

	-- Section for tabs
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "h",
		mods = "ALT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "ALT",
		action = act.ActivateTabRelative(1),
	},

	-- Splitting tab in panes
	{
		key = "æ",
		mods = "ALT",
		action = act.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "'",
		mods = "ALT",
		action = act.SplitPane({
			direction = "Down",
		}),
	},

	-- Copy and paste
	{
		key = "C",
		mods = "CTRL",
		action = act.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		key = "v",
		mods = "CTRL",
		action = act.PasteFrom("Clipboard"),
	},

	-- Activate copy mode
	{
		key = "ø",
		mods = "LEADER|CTRL",
		action = act.ActivateCopyMode,
	},
	{
		key = "ø",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},

	-- clear screen
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = act.SendKey({ key = "l", mods = "CTRL" }),
	},

	-- Section for moving between panes
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Down"),
	},
}

return M
