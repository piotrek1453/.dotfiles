return {
	-- add CSS support for treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "css", "scss" },
		},
	},
	-- override Lazy's config for Tailwind to work in Rust
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {
					filetypes = {
						"rust",
					},
					settings = {
						tailwindCSS = { includeLanguages = { rust = "html" } },
					},
				},
			},
		},
	},
}
