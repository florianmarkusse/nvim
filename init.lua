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
require("lazy").setup("plugins")
