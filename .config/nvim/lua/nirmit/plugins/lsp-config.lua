return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "tsserver", "bashls", "pyright" },
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local lspconfig = require('lspconfig')

			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.tsserver.setup({ capabilities = capabilities })
			lspconfig.bashls.setup({ capabilities = capabilities })
			lspconfig.pyright.setup({ capabilities = capabilities })

			vim.diagnostic.config({signs = false})

			-- Global keymaps.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
			-- vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev)
			-- vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next)
			-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- Keymaps after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)              -- Jumps to the definition of the symbol under the cursor.
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                    -- Shows hover information for the symbol under the cursor.
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)          -- Jumps to the implementation of the symbol under the cursor.
					vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- Provides quick fixes of errors under the cursor.
					vim.keymap.set('n', '<space>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)
				end,
			})
		end
	}
}
