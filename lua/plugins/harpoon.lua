return {
	{

		"ThePrimeagen/harpoon",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		branch = "harpoon2",
		keys = function()
			local harpoon = require("harpoon")
			local conf = require("telescope.config").values

			local function toggle_telescope(harpoon_files)
				local finder = function()
					local paths = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(paths, item.value)
					end

					return require("telescope.finders").new_table({
						results = paths,
					})
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = finder(),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							map("i", "<C-d>", function()
								local state = require("telescope.actions.state")
								local selected_entry =
									state.get_selected_entry()
								local current_picker =
									state.get_current_picker(prompt_bufnr)

								table.remove(
									harpoon_files.items,
									selected_entry.index
								)
								current_picker:refresh(finder())
							end)
							return true
						end,
					})
					:find()
			end

			return {
				{
					"<leader>a",
					function()
						harpoon:list():add()
					end,
					desc = "Harpoon add",
				},
				{
					"<leader>e",
					function()
						toggle_telescope(harpoon:list())
					end,
					desc = "Harpoon list",
				},
				{
					"<leader>1",
					function()
						harpoon:list():select(1)
					end,
					desc = "Harpoon buffer 1",
				},
				{
					"<leader>2",
					function()
						harpoon:list():select(2)
					end,
					desc = "Harpoon buffer 2",
				},
				{
					"<leader>3",
					function()
						harpoon:list():select(3)
					end,
					desc = "Harpoon buffer 3",
				},
				{
					"<leader>4",
					function()
						harpoon:list():select(4)
					end,
					desc = "Harpoon buffer 4",
				},
				{
					"<leader>q",
					function()
						harpoon:list():prev()
					end,
					desc = "Harpoon previous",
				},
				{
					"<leader>w",
					function()
						harpoon:list():next()
					end,
					desc = "Harpoon next",
				},
			}
		end,
	},
}
