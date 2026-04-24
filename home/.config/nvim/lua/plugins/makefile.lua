return {
	-- Ensure Makefile treesitter is installed for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"make",
			},
		},
	},
}
