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
        vim.keymap.set("n", "<leader>vn", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end)
        vim.keymap.set("n", "<leader>vp", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end)
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
                "ts_ls",
                "vue_ls",
                "vtsls",
                "roslyn_ls",
                "angularls",
            },
            automatic_enable = false,
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
                "stylua",
                "google-java-format",
                "prettier",
                "vue-language-server",
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

        -- Configure TypeScript Language Server with Vue plugin
        local vue_language_server_path = vim.fn.stdpath("data")
            .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

        vim.lsp.config("vtsls", {
            capabilities = capabilities,
            -- Added typescript/javascript so vtsls handles normal TS/JS as well as Vue files
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            init_options = {
                vue = {
                    hybridMode = true,
                },
                -- This block tells vtsls to register both Vue and Angular plugins
                typescript = {
                    tsserver = {
                        globalPlugins = {
                            {
                                name = "@vue/typescript-plugin",
                                location = vue_language_server_path,
                                languages = { "vue" },
                            },
                            {
                                name = "@angular/language-server",
                                -- Tries to find angular LS dynamically from Mason paths
                                location = vim.fn.stdpath("data")
                                    .. "/mason/packages/angular-language-server/node_modules/@angular/language-server",
                                enableForWorkspaceTypeScriptVersions = false,
                            },
                        },
                    },
                },
            },
        })

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                        checkThirdParty = false,
                    },
                },
            },
        })

        vim.lsp.config("csharp_ls", {
            capabilities = capabilities,
            root_dir = function(bufnr, on_dir)
                local util = require("lspconfig.util")
                local fname = vim.api.nvim_buf_get_name(bufnr)
                on_dir(
                    util.root_pattern("*.slnx")(fname)
                        or util.root_pattern("*.sln")(fname)
                        or util.root_pattern("*.csproj")(fname)
                )
            end,
        })

        vim.lsp.config("angularls", {
            capabilities = capabilities,
            filetypes = { "htmlangular" },
        })

        -- FIXED: Native vim.lsp.enable loops over server names using strings explicitly
        local servers = {
            "lua_ls",
            "rust_analyzer",
            "gopls",
            "eslint",
            "vtsls",
            "vue_ls",
            "roslyn_ls",
            "angularls",
        }

        for _, server in ipairs(servers) do
            vim.lsp.enable(server)
        end
    end,
}
