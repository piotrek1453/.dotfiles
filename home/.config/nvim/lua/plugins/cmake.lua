-- CMake support
return {
	{
		"mason.nvim",
		opts = {
			ensure_installed = {
				"neocmakelsp", -- CMake LSP
				"cmake-language-server", -- alternative CMake LSP
				"cmakelang", -- contains cmake-format
			},
		},
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- CMake LSP
				neocmake = {},
			},
		},
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				cmake_format = {},
			},
			formatters_by_ft = {
				cmake = { "cmake_format" },
			},
		},
	},
}
