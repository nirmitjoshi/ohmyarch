return {
	{ --using harpoon2
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
		config = function()
			local conf = require("telescope.config").values
			local pickers = require("telescope.pickers")
			local themes = require("telescope.themes")
			local finders = require("telescope.finders")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local harpoon = require('harpoon')
			harpoon:setup({})

			-- basic telescope-ui configuration
			local function generate_new_finder(harpoon_files)
				local files = {}
				for i, item in ipairs(harpoon_files.items) do
					table.insert(files, i .. ". " .. item.value)
				end

				return finders.new_table({
					results = files,
				})
			end

			-- move_mark_up will move the mark up in the list, refresh the picker's result list and move the selection accordingly
			local function move_mark_up(prompt_bufnr, harpoon_files)
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end
				if selection.index == 1 then
					return
				end

				local mark = harpoon_files.items[selection.index]

				table.remove(harpoon_files.items, selection.index)
				table.insert(harpoon_files.items, selection.index - 1, mark)

				local current_picker = action_state.get_current_picker(prompt_bufnr)
				current_picker:refresh(generate_new_finder(harpoon_files), {})

				-- yes defer_fn is an awful solution. If you find a better one, please let the world know.
				-- it's used here because we need to wait for the picker to refresh before we can set the selection
				-- actions.move_selection_previous() doesn't work here because the selection gets reset to 0 on every refresh.
				vim.defer_fn(function()
					-- don't even bother finding out why this is -2 here. (i don't know either)
					current_picker:set_selection(selection.index - 2)
				end, 2) -- 2ms was the minimum delay I could find that worked without glitching out the picker
			end

			-- move_mark_down will move the mark down in the list, refresh the picker's result list and move the selection accordingly
			local function move_mark_down(prompt_bufnr, harpoon_files)
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end

				local length = harpoon:list():length()
				if selection.index == length then
					return
				end

				local mark = harpoon_files.items[selection.index]

				table.remove(harpoon_files.items, selection.index)
				table.insert(harpoon_files.items, selection.index + 1, mark)

				local current_picker = action_state.get_current_picker(prompt_bufnr)
				current_picker:refresh(generate_new_finder(harpoon_files), {})

				-- yes defer_fn is an awful solution. If you find a better one, please let the world know.
				-- it's used here because we need to wait for the picker to refresh before we can set the selection
				-- actions.move_selection_next() doesn't work here because the selection gets reset to 0 on every refresh.
				vim.defer_fn(function()
					current_picker:set_selection(selection.index)
				end, 2) -- 2ms was the minimum delay I could find that worked without glitching out the picker
			end

			local function toggle_telescope(harpoon_files)
				pickers.new(themes.get_dropdown({
					--TODO: make previewer work.
					previewer = false
				}), {
					prompt_title = "Harpoon",
					finder = generate_new_finder(harpoon_files),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					-- Initial mode, change this to your liking. Normal mode is better for navigating with j/k
					initial_mode = 'insert',
					attach_mappings = function(_, map)
						actions.select_default:replace(function(prompt_bufnr)
								harpoon:list():select(curr_entry.index)
						end)

            -- Delete entries in insert mode from harpoon list with <C-d>
            map({ 'n', 'i' }, '<C-d>', function(prompt_bufnr)
                local curr_picker = action_state.get_current_picker(prompt_bufnr)

                curr_picker:delete_selection(function(selection)
                    harpoon:list():removeAt(selection.index)
                end)
            end)
            -- Move entries up and down with <C-j> and <C-k>
            -- Change the keybinding to your liking
            map({ 'n', 'i' },
                '<C-j>',
                function(prompt_bufnr)
                    move_mark_down(prompt_bufnr, harpoon_files)
                end
            )
            map({ 'n', 'i' },
                '<C-k>',
                function(prompt_bufnr)
                    move_mark_up(prompt_bufnr, harpoon_files)
                end
            )

            return true
        end
				}):find()
			end

			--shortcuts:
			vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
			vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
				{ desc = "Open harpoon window" })
			vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
			vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
			vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
		end
	}
}
