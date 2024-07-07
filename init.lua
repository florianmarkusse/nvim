-- Enables syntax highlighting
vim.cmd("syntax enable")

-- Better colors
vim.opt.termguicolors = true

-- Always yank to clipboard
vim.opt.clipboard = "unnamedplus"

-- Number of spaces in a <Tab>
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.wrap = true

-- Enable autoindents
vim.opt.smartindent = true

-- Number of spaces used for autoindents
vim.opt.shiftwidth = 4

-- Adds line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Columns used for the line number
vim.opt.numberwidth = 4

-- Open splits intuitively
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Navigate buffers without losing unsaved work
vim.opt.hidden = true

-- Start scrolling when 8 lines from top or bottom
vim.opt.scrolloff = 8

-- Save undo history
vim.opt.undofile = true

-- Enable mouse support
vim.opt.mouse = "a"

-- Case insensitive search unless capital letters are used
-- Highlights the matched text pattern when searching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.confirm = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set mapleader
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_exec(
	[[
  augroup RunFormatterOnSave
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.h,*.hpp :silent !clang-format -style=file -i <afile>
    autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.html,*.css :silent !prettier --write <afile>
    autocmd BufWritePost *.sql :silent !pg_format -i <afile>
    autocmd BufWritePost *.sh :silent !shfmt -w <afile>
    autocmd BufWritePost *.lua :silent !stylua --column-width 80 <afile>
  augroup END
]],
	false
)

vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "*", "*zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "#", "#zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "g*", "g*zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "g#", "g#zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>b",
	":noh<CR>",
	{ noremap = true, silent = true }
)

-- Set the filetype for .inc files to asm
vim.cmd("autocmd BufRead,BufNewFile *.inc set filetype=asm")

vim.cmd("set tags+=tags")

vim.api.nvim_set_keymap(
	"n",
	"<leader>c",
	":! cppcheck -j$(nproc) --enable=portability %<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>v",
	":silent !clang-tidy -fix-errors -p=build %<CR>",
	{ noremap = true, silent = true }
)

-- get contents of visual selection
-- handle unpack deprecation
table.unpack = table.unpack or unpack
function get_visual()
	local _, ls, cs = table.unpack(vim.fn.getpos("v"))
	local _, le, ce = table.unpack(vim.fn.getpos("."))
	return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

vim.keymap.set("v", "<leader>r", function()
	local pattern = table.concat(get_visual())
	-- escape regex and line endings
	pattern = vim.fn.substitute(
		vim.fn.escape(pattern, "^$.*\\/~[]"),
		"\n",
		"\\n",
		"g"
	)
	-- send parsed substitution command to command line
	vim.api.nvim_input("<Esc>:%s/" .. pattern .. "//<Left>")
end)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"folke/tokyonight.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function()
				-- load the colorscheme here
				vim.cmd([[colorscheme tokyonight]])
			end,
		},
		{
			"rstacruz/vim-closer",
			event = "VeryLazy",
		},
		{
			"feline-nvim/feline.nvim",
			event = "VeryLazy",
			config = function()
				require("feline").setup()
			end,
		},
		{
			"andymass/vim-matchup",
			event = "VeryLazy",
		},
		{
			"lewis6991/gitsigns.nvim",
			event = "VeryLazy",
			config = function()
				require("gitsigns").setup({})
			end,
		},
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
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = {
				filesystem = {
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = false,
						hide_gitignored = true,
					},
				},
				window = {
					position = "left",
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = {
							"open",
							nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
						},
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["<esc>"] = "revert_preview",
						["P"] = {
							"toggle_preview",
							config = { use_float = true },
						},
						["l"] = "focus_preview",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						-- ["S"] = "split_with_window_picker",
						-- ["s"] = "vsplit_with_window_picker",
						["t"] = "open_tabnew",
						-- ["<cr>"] = "open_drop",
						-- ["t"] = "open_tab_drop",
						["w"] = "open_with_window_picker",
						--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
						["C"] = "close_node",
						-- ['C'] = 'close_all_subnodes',
						["z"] = "close_all_nodes",
						--["Z"] = "expand_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "none", -- "none", "relative", "absolute"
							},
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						-- ["c"] = {
						--  "copy",
						--  config = {
						--    show_path = "none" -- "none", "relative", "absolute"
						--  }
						--}
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
					},
				},
			},
		},
		{
			event = "VeryLazy",
			"neovim/nvim-lspconfig",
			dependencies = {
				"neovim/nvim-lspconfig", -- Collection of configurations for built-in LSP client
				"hrsh7th/nvim-cmp", -- Autocompletion plugin
				"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
				"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
				"L3MON4D3/LuaSnip", -- Snippets plugin
			},

			config = function()
				-- Add additional capabilities supported by nvim-cmp
				local capabilities =
					require("cmp_nvim_lsp").default_capabilities()

				local lspconfig = require("lspconfig")

				-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
				local servers = {
					"tsserver",
					"cssls",
					"html",
					"bashls",
					"clangd",
					"cmake",
					"java_language_server",
				}
				for _, lsp in ipairs(servers) do
					lspconfig[lsp].setup({
						-- on_attach = my_custom_on_attach,
						capabilities = capabilities,
					})
				end

				-- luasnip setup
				local luasnip = require("luasnip")

				-- nvim-cmp setup
				local cmp = require("cmp")
				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
						["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
						-- C-b (back) C-f (forward) for snippet placeholder navigation.
						["<C-Space>"] = cmp.mapping.complete(),
						["<CR>"] = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						}),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					}),
					sources = {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
					},
				})
			end,
		},
		{
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({
					plugins = {
						marks = true, -- shows a list of your marks on ' and `
						registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
						-- the presets plugin, adds help for a bunch of default keybindings in Neovim
						-- No actual key bindings are created
						spelling = {
							enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
							suggestions = 20, -- how many suggestions should be shown in the list?
						},
						presets = {
							operators = true, -- adds help for operators like d, y, ...
							motions = true, -- adds help for motions
							text_objects = true, -- help for text objects triggered after entering an operator
							windows = true, -- default bindings on <c-w>
							nav = true, -- misc bindings to work with windows
							z = true, -- bindings for folds, spelling and others prefixed with z
							g = true, -- bindings for prefixed with g
						},
					},
					operators = { gc = "Comments" },
					icons = {
						breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
						separator = "➜", -- symbol used between a key and it's label
						group = "+", -- symbol prepended to a group
					},
					popup_mappings = {
						scroll_down = "<c-d>", -- binding to scroll down inside the popup
						scroll_up = "<c-u>", -- binding to scroll up inside the popup
					},
					window = {
						border = "none", -- none, single, double, shadow
						position = "bottom", -- bottom, top
						margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
						padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
						winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
						zindex = 1000, -- positive value to position WhichKey above other floating windows.
					},
				})
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.2",
			event = "VeryLazy",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
				vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			end,
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
									local state =
										require("telescope.actions.state")
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
					},
					{
						"<leader>e",
						function()
							toggle_telescope(harpoon:list())
						end,
					},

					{
						"<leader>1",
						function()
							harpoon:list():select(1)
						end,
					},
					{
						"<leader>2",
						function()
							harpoon:list():select(2)
						end,
					},
					{
						"<leader>3",
						function()
							harpoon:list():select(3)
						end,
					},
					{
						"<leader>4",
						function()
							harpoon:list():select(4)
						end,
					},

					{
						"<leader>q",
						function()
							harpoon:list():prev()
						end,
					},
					{
						"<leader>w",
						function()
							harpoon:list():next()
						end,
					},
				}
			end,
			opts = function(_, opts)
				opts.settings = {
					save_on_toggle = false,
					sync_on_ui_close = false,
					save_on_change = true,
					enter_on_sendcmd = false,
					tmux_autoclose_windows = false,
					excluded_filetypes = {
						"harpoon",
						"alpha",
						"dashboard",
						"gitcommit",
					},
					mark_branch = true,
					key = function()
						return vim.loop.cwd()
					end,
				}
			end,
			config = function(_, opts)
				require("harpoon").setup(opts)
			end,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
