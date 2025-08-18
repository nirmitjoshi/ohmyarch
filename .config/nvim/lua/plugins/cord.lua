return {
	{
		"vyfor/cord.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("cord").setup({
				editor = {
					client = "neovim",
					tooltip = "aaaaaaaa...",
				},
				display = {
					theme = "atom",
					flavor = "accent",
				},
				text = {
					editing = "editing ${filename}",
					viewing = "viewing ${filename}",
					workspace = false,
					default = "",
				},
				variables = true,
			})
		end,
	},
}
