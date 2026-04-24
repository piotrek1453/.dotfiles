return {
	{
		"folke/snacks.nvim",
		opts = {
			-- enable image preview in md formats
			image = {
				enabled = true,
				backend = "kitty",
				max_width = 80,
				max_height = 40,
				inline = true,
				math = {
					format = "svg",
				},
				markdown = {
					enabled = true,
					filetypes = { "markdown", "rmarkdown", "quarto" },
				},
			},

			picker = {
				-- show hidden files in explorer by default
				hidden = true,
				ignored = true,
				sources = {
					files = {
						hidden = true,
						ignored = true,
					},
				},
			},
		},
	},
}
