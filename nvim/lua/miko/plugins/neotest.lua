return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"fredrikaverpil/neotest-golang",
		"leoluz/nvim-dap-go",
	},
	config = function()
		require("neotest").setup({
			-- Add all other adapters needed to this list here.
			adapters = {
				require("neotest-golang")({
					dap_go_opts = { justMyCode = false },
					testify_enabled = false,
					log_level = vim.log.levels.DEBUG,
					go_test_args = { "-v", "-count=1" },
				}),
			},
			discovery = {
				enabled = true,
			},
		})

		local neotest = require("neotest")

		vim.keymap.set("n", "<leader>tr", function()
			neotest.run.run()
		end, { desc = "Debug: Running Nearest Test" })

		vim.keymap.set("n", "<leader>tv", function()
			require("neotest").summary.toggle()
		end, { desc = "Debug: Summary Toggle" })

		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, { desc = "Debug: Running Test Suite" })

		vim.keymap.set("n", "<leader>td", function()
			require("neotest").run.run({
				strategy = "dap",
			})
		end, { desc = "Debug: Debug Nearest Test" })

		vim.keymap.set("n", "<leader>to", function()
			require("neotest").output.open()
		end, { desc = "Debug: Open test output" })

		vim.keymap.set("n", "<leader>ta", function()
			require("neotest").run.run(vim.fn.getcwd())
		end, { desc = "Debug: Open test output" })
	end,
}
