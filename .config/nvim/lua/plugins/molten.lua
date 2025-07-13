return {
	{
		"benlubas/molten-nvim",
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20

			vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>",
				{ silent = true, desc = "Initialize the plugin" })
			vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>",
				{ silent = true, desc = "Run operator selection" })
			vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>",
				{ silent = true, desc = "Evaluate current line" })
			vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>",
				{ silent = true, desc = "Re-evaluate current cell" })
			vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
				{ silent = true, desc = "Evaluate visual selection" })
			vim.keymap.set("n", "<leader>rd", ":MoltenDelete<CR>",
				{ silent = true, desc = "molten delete cell" })
			vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>",
				{ silent = true, desc = "hide output" })
		end,
	},
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			max_width = 100,
			max_height = 12,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
	},
}
