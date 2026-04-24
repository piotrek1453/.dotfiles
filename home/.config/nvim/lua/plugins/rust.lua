return {
	{
		"mrcjkb/rustaceanvim",
		opts = {
			server = {
				-- Connect to lspmux server - rust-analyzer caching
				cmd = { "lspmux", "client" },
				default_settings = {
					["rust-analyzer"] = {
						-- disable autocomplete etc in Leptos macros - not using it, keeping just in case
						-- Configure rust-analyzer for Leptos/RSX
						-- procMacro = {
						-- 	ignored = {
						-- 		leptos_macro = {
						-- 			-- optional: --
						-- 			-- "component",
						-- 			"server",
						-- 		},
						-- 	},
						-- },
						cargo = {
							allFeatures = true,
						},
					},
				},
			},
		},
	},
}
