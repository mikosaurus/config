local root_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
}

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float)
		vim.keymap.set("n", "<leader>vn", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename)
		vim.keymap.set("n", "<leader>vs", function()
			vim.lsp.buf.hover({
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
			})
		end)

		-- These will be redundant with new keyboard, but are nice to have
		-- when function keys are available
		vim.keymap.set("n", "<F12>", vim.lsp.buf.references)
		vim.keymap.set("n", "<f2>", vim.lsp.buf.rename)

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"eslint",
				"jdtls",
				"vue_ls",
			},
			handlers = {
				function(server_name)
					if server_name ~= "jdtls" and "volar" then
						lspconfig[server_name].setup({
							on_attach = lsp_attach,
							capabilities = capabilities,
						})
					end
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								format = {
									enable = true,
									-- Put format options here
									-- NOTE: the value should be STRING!!
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
								workspace = {
									library = {
										vim.env.VIMRUNTIME,
										vim.fn.expand("~/.local/share/nvim/types/wezterm-types"),
									},
								},
							},
						},
					})
				end,
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"stylua",
				"google-java-format",
				"prettier",
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})

		cmp.setup({
			enabled = true,
			window = {
				completion = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
				},
				documentation = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
				},
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "path" },
				{ name = "codecompanion" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		vim.lsp.config("vue_ls", {
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			init_options = {
				vue = {
					hybridMode = false,
				},
			},
			on_attach = function() end,
			root_markers = { "package.json", "vite.config.ts" },
		})
	end,
}
