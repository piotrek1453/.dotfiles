-- HDL (Verilog/SystemVerilog/VHDL) support
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"verilog",
				"systemverilog",
				"vhdl",
			},
		},
	},
	{
		"mason.nvim",
		opts = {
			ensure_installed = {
				"verible", -- SystemVerilog LSP + formatter
				"vsg", -- VHDL Style Guide formatter+linter
				"rust_hdl", -- VHDL LSP
			},
		},
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- SystemVerilog / Verilog
				verible = {
					filetypes = {
						"verilog",
						"systemverilog",
						"sv",
						"svh",
					},
					cmd = {
						"verible-verilog-ls",
						"--rules_config_search",
					},
				},
				-- VHDL
				vhdl_ls = {},
			},
		},
	},
	-- linting
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				-- SystemVerilog / Verilog
				systemverilog = { "verilator" },
				verilog = { "verilator" },
				-- VHDL
				vhd = { "vsg" },
				vhdl = { "vsg" },
			},
			verilator = {
				append_args = { "-sv", "-Wall", "--bbox-sys", "--bbox-unsup", "--lint-only", "-f" },
			},
		},
	},
	-- formatters
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				-- SystemVerilog / Verilog
				verible = {
					append_args = {
						"--column_limit",
						"79",
					},
				},
				-- VHDL
				vsg = {
					append_args = { "--fix" },
				},
			},
		},
		formatters_by_ft = {
			-- VHDL
			vhdl = { "vsg" },
			vhd = { "vsg" },
		},
	},
}
