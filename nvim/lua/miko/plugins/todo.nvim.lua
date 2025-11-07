return {
  "mikosaurus/todo.nvim",
  -- dir = "~/github.com/mikosaurus/todo.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local todofiles = require("todofiles")
    -- Use GitHub URL for treesitter parser (recommended)
    -- Run :TSInstall todofiles to install the parser
    -- For local development, use: treesitter_path = "~/github.com/mikosaurus/tree-sitter-todofiles"
    todofiles.setup({
      -- treesitter_path = "https://github.com/mikosaurus/tree-sitter-todofiles",
      treesitter_path = "~/github.com/mikosaurus/tree-sitter-todofiles",
    })

    vim.api.nvim_create_autocmd("FileType", {
      desc = "set keybinds for todofiles",
      pattern = "todofiles",
      group = vim.api.nvim_create_augroup("todofiles-keybinds", { clear = true }),
      callback = function(opts)
        vim.keymap.set("n", "<M-n>", todofiles.set_task_open, { buffer = true })
        vim.keymap.set("n", "<M-d>", todofiles.set_task_done, { buffer = true })
        vim.keymap.set("n", "<M-c>", todofiles.set_task_cancelled, { buffer = true })
        vim.keymap.set("n", "<M-N>", todofiles.clear_task, { buffer = true })
      end,
    })
  end,
}
