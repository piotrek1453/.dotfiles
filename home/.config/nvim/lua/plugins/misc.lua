return {
	-- disable plaintext autocompletion source in all files
	-- {
	-- 	"saghen/blink.cmp",
	-- 	opts = function(_, opts)
	-- 		local sources = opts.sources or {}
	-- 		local default_sources = sources.default or {}
	--
	-- 		sources.default = vim.tbl_filter(function(name)
	-- 			return name ~= "buffer"
	-- 		end, default_sources)
	--
	-- 		opts.sources = sources
	-- 		return opts
	-- 	end,
	-- },
	-- -- remote dev
	{
		"nosduco/remote-sshfs.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		opts = {
			-- Refer to the configuration section below
			-- or leave empty for defaults
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
	},
	{
		"nvim-mini/mini.ai",
		opts = {
			search_method = "cover_or_nearest",
		},
	},
}
