---@diagnostic disable: undefined-global
require("nirmit.keymaps")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

require("nirmit.lazy")

vim.o.wildmenu = true
vim.o.wildmode = "longest,list,full"

--vim.opt.signcolumn = 'no' -- auto/yes/no

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.undodir = "/home/nirmit/.config/nvim/.undodir/"
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50

vim.opt.cmdheight = 1
