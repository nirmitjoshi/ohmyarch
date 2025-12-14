return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				ignore_filetypes = { cuda = true },
			})
		end
	},
}
