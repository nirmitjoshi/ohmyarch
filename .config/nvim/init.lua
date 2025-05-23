vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
	end,
})

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
