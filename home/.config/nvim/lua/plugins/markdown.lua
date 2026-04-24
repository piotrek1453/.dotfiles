return {
	-- Full override of render-markdown settings from LazyVim spec
	-- I don't like the way LazyVim sets up appearance of render
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = function()
			return {
				enabled = true,
				render_modes = { "n", "c" },
				heading = { enabled = true },
				code = { enabled = true, style = "full" },
				latex = { enabled = false },
				bullet = { enabled = true },
				checkbox = { enabled = true },
				quote = { enabled = true },
				pipe_table = { enabled = true },
			}
		end,
	},
}
