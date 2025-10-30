-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				contrast = "hard", -- or "soft", "medium"
				transparent_mode = false,
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"NoahTheDuke/vim-just",
		ft = { "just" },
	},
}
