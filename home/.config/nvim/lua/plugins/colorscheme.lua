return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd("colorscheme oxocarbon")

			-- tweaks
			vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#5c6773" }) -- hidden files less dimmed
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "#241f31" }) -- change current line highlight color
			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c6773", bg = "NONE" })
		end,
	},
}
