return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.8",

	dependencies = { "nvim-lua/plenary.nvim", "benfowler/telescope-luasnip.nvim" },

	config = function()
		local telescope = require("telescope")
		telescope.setup({})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find files in git repo" })
		vim.keymap.set("n", "<leader>fw", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>fW", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)

		vim.keymap.set("n", "<leader>fs", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find)
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})

		telescope.load_extension("noice")
		telescope.load_extension("luasnip")
	end,
}
