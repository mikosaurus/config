return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>")
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
        vim.keymap.set("n", "<leader>gd", function()
            local buf = vim.api.nvim_get_current_buf()
            local target = nil
            if vim.bo[buf].filetype == "fugitive" then
                local ok, path = pcall(vim.fn["fugitive#GX"])
                if ok and path and path ~= "" and vim.fn.filereadable(path) then
                    target = path
                end
            end
            if target then
                vim.cmd("tabnew " .. vim.fn.fnameescape(target))
            else
                vim.cmd("tabnew")
                vim.api.nvim_set_current_buf(buf)
            end
            vim.cmd("Gdiffsplit!")
        end)
    end,
}
