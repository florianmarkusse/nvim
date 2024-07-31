return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		keys = { { "<leader>no", "<cmd>Oil --float<cr>", desc = "Oil buffer" } },
		enabled = true,
		opts = function(_, opts)
			opts.columns = { "icon" }
			opts.prompt_save_on_select_new_entry = true
			opts.use_default_keymaps = false

			opts.keymaps = {
				["g?"] = "actions.show_help",
				["q"] = "actions.close",
				["r"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
			}
		end,
	},
}
