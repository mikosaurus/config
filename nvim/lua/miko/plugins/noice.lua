return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			lsp_doc_border = true,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	-- config = function()
	-- 	require("notify").setup({
	-- 		background_colour = "red",
	-- 	})
	-- end,
}
