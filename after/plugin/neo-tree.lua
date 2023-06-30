require('neo-tree').setup({
    filesystem = {
        filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = true,
        }
    }
})

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
vim.cmd([[ Neotree ]])

