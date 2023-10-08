return {

	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	{ "rstacruz/vim-closer", event = "VeryLazy" },
	{
		"feline-nvim/feline.nvim",
		event = "VeryLazy",
		config = function()
			require("feline").setup()
		end,
	},
	{ "andymass/vim-matchup", event = "VeryLazy" },
	{ "lewis6991/gitsigns.nvim", event = "VeryLazy" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
	},
	{
		"iamcco/markdown-preview.nvim",
		build = ":call mkdp#util#install()",
		event = "VeryLazy",
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
}
