return {
	{ -- using telescope, telescope-undo and telescope ui
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'debugloop/telescope-undo.nvim',
		},
		config = function()
			local builtin = require('telescope.builtin')
			local build = require("telescope").load_extension("undo")

			--shortcuts:
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
		end
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup {
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
						}
					}
				}
			}
			require("telescope").load_extension("ui-select")
		end
	}
}
