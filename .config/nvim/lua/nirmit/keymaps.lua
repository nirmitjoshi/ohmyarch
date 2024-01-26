vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "k", ":m '>-2<CR>gv=gv")

vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", 'yy"+')
vim.keymap.set("n", "<leader>p", '"+p')
