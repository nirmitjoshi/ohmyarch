local function buffer_count()
	return vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
end

local colorscheme_config = {
	{
		"catppuccin/nvim",
		name = "catppuccin-mocha",
		priority = 1000,
		config = function()
			require("catppuccin").setup {
				transparent_background = true,
				color_overrides = {
					mocha = {
						base = "#171515",
						mantle = "#232323",
						crust = "#282828",
					},
				}
			}
			vim.cmd.colorscheme "catppuccin-mocha"
		end
	},

	{ --bottom status line
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding' },
					lualine_y = { 'filetype' },
					lualine_z = { buffer_count }
				}
			})
		end
	}
}
return colorscheme_config
