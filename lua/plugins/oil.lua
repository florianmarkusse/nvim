return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		keys = { { "<leader>no", "<cmd>Oil --float<cr>", desc = "Oil buffer" } },
		enabled = true,
		opts = {
			columns = { "icon" },
			prompt_save_on_select_new_entry = true,
			use_default_keymaps = false,
			keymaps = {
				["g?"] = "actions.show_help",
				["q"] = "actions.close",
				["r"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
			},
		},
	},
}
