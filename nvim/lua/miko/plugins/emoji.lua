return {
	"allaman/emoji.nvim",
	version = "1.0.0", -- optionally pin to a tag
	ft = { "markdown", "TODO", "todo" }, -- adjust to your needs
	dependencies = {
		-- util for handling paths
		"nvim-lua/plenary.nvim",
		-- optional for nvim-cmp integration
		"hrsh7th/nvim-cmp",
		-- optional for telescope integration
		"nvim-telescope/telescope.nvim",
		-- optional for fzf-lua integration via vim.ui.select
		"ibhagwan/fzf-lua",
	},
	opts = {
		-- default is false, also needed for blink.cmp integration!
		enable_cmp_integration = true,
		-- optional if your plugin installation directory
		-- is not vim.fn.stdpath("data") .. "/lazy/
		plugin_path = vim.fn.expand("$HOME/.local/share/nvim/lazy/"),
	},
	config = function(_, opts)
		require("emoji").setup(opts)
		-- optional for telescope integration
		local ts = require("telescope").load_extension("emoji")
		vim.keymap.set("n", "<leader>em", ts.emoji, { desc = "[S]earch [E]moji" })
	end,
}
