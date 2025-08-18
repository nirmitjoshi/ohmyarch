return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require "dap"
			local ui = require "dapui"

			ui.setup()
			require("nvim-dap-virtual-text").setup()

			require("mason-nvim-dap").setup({
				ensure_installed = {
					"python",
					"delve",
					"codelldb",
				},
				automatic_installation = true,
			})

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			vim.keymap.set("n", "<leader>dc", dap.continue)
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>dq", dap.terminate)
			vim.keymap.set("n", "<leader>ds", dap.step_over)
			vim.keymap.set("n", "<leader>di", dap.step_into)
			vim.keymap.set("n", "<leader>do", dap.step_out)

			dap.listeners.before.attach.dapui_config = function() ui.open() end
			dap.listeners.before.launch.dapui_config = function() ui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
			dap.listeners.before.event_exited.dapui_config = function() ui.close() end
		end,
	},
}
