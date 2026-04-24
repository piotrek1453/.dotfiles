return {
	{
		"mason.nvim",
		opts = {
			ensure_installed = {
				"isort",
				"ruff",
				"black",
			},
		},
	},
	{
		"linux-cultist/venv-selector.nvim",
		opts = {
			search = {
				my_venvs = {
					command = "fd 'python$' ~/.venv",
				},
			},
		},
	},
	-- order imports, format with ruff and black as fallback
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "isort", "black", "ruff_format" },
			},
		},
	},
}
