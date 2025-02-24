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
				["<CR>"] = "actions.select",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
			},
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = false,
				-- This function defines what is considered a "hidden" file
				is_hidden_file = function(name, bufnr)
					local m = name:match("^%.")
					return m ~= nil
				end,
				-- This function defines what will never be shown, even when `show_hidden` is set
				is_always_hidden = function(name, bufnr)
					return false
				end,
				-- Sort file names with numbers in a more intuitive order for humans.
				-- Can be "fast", true, or false. "fast" will turn it off for large directories.
				natural_order = "fast",
				-- Sort file and directory names case insensitive
				case_insensitive = false,
				sort = {
					-- sort order can be "asc" or "desc"
					-- see :help oil-columns to see which columns are sortable
					{ "type", "asc" },
					{ "name", "asc" },
				},
				-- Customize the highlight group for the file name
				highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
					return nil
				end,
			},
			git = {
				-- Return true to automatically git add/mv/rm files
				add = function(path)
					return true
				end,
				mv = function(src_path, dest_path)
					return true
				end,
				rm = function(path)
					return true
				end,
			},
		},
	},
}
