return {
	-- Install emmet-language-server via Mason
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"emmet-language-server",
			},
		},
	},

	-- Configure emmet-language-server
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				emmet_language_server = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"rust",
					},
				},
			},
		},
	},

	-- Ensure HTML treesitter is installed
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "html" },
		},
	},
}
