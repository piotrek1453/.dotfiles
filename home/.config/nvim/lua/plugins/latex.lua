return {
	-- Treesitter adjustments for LaTeX/BibTeX
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "bibtex", "latex" },
		},
	},
	-- VimTeX core configuration & leader key bindings
	{
		"lervag/vimtex",
		config = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
			vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- keep LSP hover intact
			-- Enable SyncTeX for forward/inverse search
			vim.g.vimtex_compiler_latexmk = {
				options = {
					"-pdf",
					"-shell-escape",
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}
		end,
		keys = {
			{ "<leader>cc", "<cmd>VimtexCompile<CR>", desc = "Compile", ft = "tex" },
			{ "<leader>cv", "<cmd>VimtexView<CR>", desc = "View (Zathura)", ft = "tex" },
			{ "<leader>cC", "<cmd>VimtexClean<CR>", desc = "Clean Aux", ft = "tex" },
			{ "<leader>ck", "<cmd>VimtexStop<CR>", desc = "Stop Compile", ft = "tex" },
			{ "<leader>ce", "<cmd>VimtexErrors<CR>", desc = "Errors", ft = "tex" },
			{ "<leader>cs", "<cmd>VimtexStatus<CR>", desc = "Status", ft = "tex" },
			{ "<leader>ct", "<cmd>VimtexTocToggle<CR>", desc = "TOC Toggle", ft = "tex" },
		},
	},
}
