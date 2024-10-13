return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			"nvim-telescope/telescope-smart-history.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			{
				"AckslD/nvim-neoclip.lua",
				lazy = true,
				opts = {},
			},
			"jonarrien/telescope-cmdline.nvim",
			-- To view the current file history in git
			{
				"isak102/telescope-git-file-history.nvim",
				dependencies = { "tpope/vim-fugitive" },
			},
		},
		config = function()
			local actions = require("telescope.actions")
			local action_layout = require("telescope.actions.layout")
			local lga_actions = require("telescope-live-grep-args.actions")
			local action_state = require("telescope.actions.state")
			local builtin = require("telescope.builtin")
			require("telescope-live-grep-args.shortcuts")
			require("telescope").setup({
				defaults = {
					selection_strategy = "closest",
					sorting_strategy = "descending",
					scroll_strategy = "cycle",
					color_devicons = true,
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
						neoclip = {
							initial_mode = "normal",
						},
					},
					layout_strategy = "horizontal",
					layout_config = {
						width = 0.99,
						height = 0.85,
						preview_cutoff = 120,
						prompt_position = "bottom",
						horizontal = {
							preview_width = function(_, cols, _)
								return math.floor(cols * 0.4)
							end,
						},
						vertical = {
							width = 0.9,
							height = 0.95,
							preview_height = 0.5,
						},
						flex = {
							horizontal = {
								preview_width = 0.9,
							},
						},
					},
					mappings = {
						i = {
							-- ["<C-s>"] = actions.select_horizontal,
							-- ["<C-g>"] = "move_selection_next",
							-- ["<C-t>"] = "move_selection_previous",
							-- ["<C-u>"] = actions.results_scrolling_down,
							-- ["<C-d>"] = actions.results_scrolling_up,
							["<C-h>"] = action_layout.toggle_preview,
							-- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							-- ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
							-- ["<C-k>"] = actions.cycle_history_next,
							-- ["<C-j>"] = actions.cycle_history_prev,
							-- ["<c-a>s"] = actions.select_all,
							-- ["<c-a>a"] = actions.add_selection,
							-- ["<M-f>"] = actions.results_scrolling_left,
							-- ["<M-k>"] = actions.results_scrolling_right,
						},
						n = {
							["<leader>oo"] = lga_actions.quote_prompt(),
						},
					},

					file_ignore_patterns = {
						"node_modules",
						"vendor",
						".git/",
						"*.lock",
						"package-lock.json",
					},

					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "git_file_history")
			require("telescope").load_extension("neoclip")
			require("telescope").load_extension("cmdline")
			require("telescope").load_extension("smart_history")

			local function neoclip()
				require("telescope").extensions.neoclip.default({
					initial_mode = "normal",
				})
			end

			local git_changed_files = function()
				builtin.git_status({
					attach_mappings = function(prompt_bufnr, map)
						local switch_to_file = function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.cmd(":e " .. selection.value)
						end
						map("i", "<CR>", switch_to_file)
						map("n", "<CR>", switch_to_file)
						return true
					end,
				})
			end

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>fr", builtin.grep_string, { desc = "Grep word under cursor" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Grep open buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			vim.keymap.set("n", "<leader>ss", git_changed_files, { desc = "Git changes files" })
			vim.keymap.set("n", "<leader>sp", neoclip, { desc = "Search clipboard history" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set("n", "<leader>sc", "<cmd>Telescope cmdline<cr>", { desc = "Cmdline" })

			-- then load the extension
			require("telescope").load_extension("live_grep_args")
			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
			vim.keymap.set(
				"n",
				"<leader>fd",
				require("telescope").extensions.live_grep_args.live_grep_args,
				{ desc = "search by grep" }
			)
			vim.keymap.set(
				"v",
				"<leader>fg",
				live_grep_args_shortcuts.grep_visual_selection,
				{ desc = "Search highlighted word" }
			)
		end,
	},
}
