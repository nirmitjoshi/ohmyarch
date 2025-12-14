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
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "ts_ls", "bashls", "pyright", "html", "clangd", "cssls" },
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup {
							capabilities = capabilities
						}
					end,
				}
			})

			vim.diagnostic.config({ signs = false })

			-- Global keymaps.
			vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)

			-- Keymaps after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
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
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"yapf",
					"shfmt",
					"prettier"
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.yapf.with({
						extra_args = {
							"--style={based_on_style: google, indent_width: 4}",
						},
					}),
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.prettier,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
	}
}
