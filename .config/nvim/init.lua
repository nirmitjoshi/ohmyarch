vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.o.wildmenu = true
vim.o.wildmode = "longest,list,full"

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/.undodir/"
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.cmdheight = 1

require("keymaps")
require("lazy_setup")
