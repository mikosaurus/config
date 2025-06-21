local wezterm = require("wezterm")
local workspace = require("workspaces")
local domains = require("domains")
local ssh_domains = require("ssh_domains").ssh_domains
local act = wezterm.action

local M = {}
M.keys = {

	-- Domains
	{
		key = "p",
		mods = "META|CTRL",
		action = domains.domainfzf(ssh_domains),
	},
	-- {
	-- 	key = "p",
	-- 	mods = "META",
	-- 	action = domains.domainfzf(ssh_domains),
	-- },

	-- Workspaces
	-- {
	-- 	key = "o",
	-- 	mods = "META",
	-- 	action = workspace.workspacefzf,
	-- },
	{
		key = "o",
		mods = "META|CTRL",
		action = workspace.workspacefzf,
	},
	{
		key = "å",
		mods = "META|CTRL",
		action = act.ShowLauncher,
	},

	-- Section for tabs
	-- {
	-- 	key = "c",
	-- 	mods = "LEADER",
	-- 	action = act.SpawnTab("CurrentPaneDomain"),
	-- },
	-- {
	-- 	key = "h",
	-- 	mods = "ALT",
	-- 	action = act.ActivateTabRelative(-1),
	-- },
	-- {
	-- 	key = "l",
	-- 	mods = "ALT",
	-- 	action = act.ActivateTabRelative(1),
	-- },

	-- Splitting tab in panes
	-- {
	-- 	key = "æ",
	-- 	mods = "LEADER",
	-- 	action = act.SplitPane({
	-- 		direction = "Right",
	-- 	}),
	-- },
	-- {
	-- 	key = "æ",
	-- 	mods = "LEADER|CTRL",
	-- 	action = act.SplitPane({
	-- 		direction = "Right",
	-- 	}),
	-- },
	-- {
	-- 	key = "'",
	-- 	mods = "LEADER",
	-- 	action = act.SplitPane({
	-- 		direction = "Down",
	-- 	}),
	-- },

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
	-- {
	-- 	key = "ø",
	-- 	mods = "LEADER|CTRL",
	-- 	action = act.ActivateCopyMode,
	-- },
	-- {
	-- 	key = "ø",
	-- 	mods = "LEADER",
	-- 	action = act.ActivateCopyMode,
	-- },

	-- clear screen
	-- {
	-- 	key = "l",
	-- 	mods = "LEADER|CTRL",
	-- 	action = act.SendKey({ key = "l", mods = "CTRL" }),
	-- },

	-- Section for moving between panes
	-- {
	-- 	key = "h",
	-- 	mods = "CTRL",
	-- 	action = act.ActivatePaneDirection("Left"),
	-- },
	--
	-- {
	-- 	key = "l",
	-- 	mods = "CTRL",
	-- 	action = act.ActivatePaneDirection("Right"),
	-- },
	--
	-- {
	-- 	key = "k",
	-- 	mods = "CTRL",
	-- 	action = act.ActivatePaneDirection("Up"),
	-- },
	--
	-- {
	-- 	key = "j",
	-- 	mods = "CTRL",
	-- 	action = act.ActivatePaneDirection("Down"),
	-- },
}

return M
