return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			{ "williamboman/mason.nvim",           opts = true },
			{ "williamboman/mason-lspconfig.nvim", opts = true },
		},
		opts = {
			ensure_installed = {
				"pyright", -- LSP for python
				"ruff-lsp", -- linter for python (includes flake8, pep8, etc.)
				"debugpy", -- debugger
				"black", -- formatter
				"isort", -- organize imports
				"taplo", -- LSP for toml (for pyproject.toml files)
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "gd",        vim.lsp.buf.definition,  desc = "Goto Definition" },
			{ "gr",        vim.lsp.buf.references,  desc = "Goto References" },
			{ "<leader>c", vim.lsp.buf.code_action, desc = "Code Action" },
		},
		init = function()
			-- this snippet enables auto-completion
			local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
			lspCapabilities.textDocument.completion.completionItem.snippetSupport = true

			-- setup pyright with completion capabilities
			require("lspconfig").pyright.setup({
				capabilities = lspCapabilities,
			})

			-- setup taplo with completion capabilities
			require("lspconfig").taplo.setup({
				capabilities = lspCapabilities,
			})

			-- ruff uses an LSP proxy, therefore it needs to be enabled as if it
			-- were a LSP. In practice, ruff only provides linter-like diagnostics
			-- and some code actions, and is not a full LSP yet.
			require("lspconfig").ruff_lsp.setup({
				-- organize imports disabled, since we are already using `isort` for that
				-- alternative, this can be enabled to make `organize imports`
				-- available as code action
				settings = {
					organizeImports = false,
				},
				-- disable ruff as hover provider to avoid conflicts with pyright
				on_attach = function(client) client.server_capabilities.hoverProvider = false end,
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- load the plugin before saving
		keys = {
			{
				"<leader>f",
				function() require("conform").format({ lsp_fallback = true }) end,
				desc = "Format",
			},
		},
		opts = {
			formatters_by_ft = {
				-- first use isort and then black
				python = { "isort", "black" },
				-- "inject" is a special formatter from conform.nvim, which
				-- formats treesitter-injected code. Basically, this makes
				-- conform.nvim format python codeblocks inside a markdown file.
				markdown = { "inject" },
			},
			-- enable format-on-save
			format_on_save = {
				-- when no formatter is setup for a filetype, fallback to formatting
				-- via the LSP. This is relevant e.g. for taplo (toml LSP), where the
				-- LSP can handle the formatting for us
				lsp_fallback = true,
			},
		},
	},
}
