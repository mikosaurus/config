vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>fm", function()
	require("conform").format({ bufnr = 0 })
end)

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "=ap", "ma=ap'a")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- keymap to run find and replace on a visual line
vim.keymap.set("v", "<leader>fr", [[:s/\(\w.*\)/]])

vim.keymap.set("n", "<leader>wsq", "ciw''<ESC>P")
vim.keymap.set("v", "<leader>wsq", "c''<ESC>P")

vim.keymap.set("n", "<leader>wss", 'ciw""<ESC>P')
vim.keymap.set("v", "<leader>wss", 'c""<ESC>P')

vim.keymap.set("v", "<leader>wsj", "c()<ESC>P")
vim.keymap.set("v", "<leader>wsk", "c{}<ESC>P")
vim.keymap.set("v", "<leader>wsl", "c[]<ESC>P")
vim.keymap.set("v", "<leader>wsn", "c<><ESC>P")

vim.keymap.set({ "i", "n", "v" }, "ø", "{")
vim.keymap.set({ "i", "n", "v" }, "æ", "}")
vim.keymap.set({ "i", "n", "v" }, "Ø", "[")
vim.keymap.set({ "i", "n", "v" }, "Æ", "]")
vim.keymap.set({ "n", "v" }, "-", "/")

vim.keymap.set("n", "<leader>md", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
