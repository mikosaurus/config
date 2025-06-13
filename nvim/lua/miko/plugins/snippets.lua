return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",

		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
			local ls = require("luasnip")
			ls.filetype_extend("javascript", { "jsdoc" })

			ls.snippets = {
				html = {},
			}
			ls.snippets.javascript = ls.snippets.html
			ls.snippets.javascriptreact = ls.snippets.html

			require("luasnip/loaders/from_vscode").load({ include = { "html" } })

			require("luasnip.loaders.from_vscode").lazy_load()

			vim.keymap.set({ "i" }, "<C-s>e", function()
				ls.expand()
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-s>;", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-s>,", function()
				ls.jump(-1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
		end,
	},
}
