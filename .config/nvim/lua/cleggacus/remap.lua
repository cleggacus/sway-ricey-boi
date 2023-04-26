vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set({"n", "v"}, "y", [["+y]])
vim.keymap.set({"n", "v"}, "p", [["+p]])
vim.keymap.set({"n", "v"}, "Y", [["+Y]])
vim.keymap.set({"n", "v"}, "P", [["+P]])

