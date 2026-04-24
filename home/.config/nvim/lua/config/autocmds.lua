-- Force spell off globally and keep overriding late
local nospell_grp = vim.api.nvim_create_augroup("NoSpellAll", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "BufEnter", "InsertEnter" }, {
	group = nospell_grp,
	pattern = "*",
	callback = function()
		vim.opt_local.spell = false
		vim.opt.spell = false
	end,
})
