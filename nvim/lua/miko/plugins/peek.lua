return {
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				app = 'browser',
				filetype = { "markdown", "conf" }
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
			vim.api.nvim_create_user_command("PeekIsOpen", require("peek").is_open, {})
		end
}

