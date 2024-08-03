return {
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			{
				"saadparwaiz1/cmp_luasnip",
				dependencies = "L3MON4D3/LuaSnip",
			},
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			{
				"FelipeLema/cmp-async-path",
				url = "https://codeberg.org/FelipeLema/cmp-async-path",
			},
			"lukas-reineke/cmp-rg",
			"quangnguyen30192/cmp-nvim-tags",
		},
		enabled = true,
		opts = function(_, opts)
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			opts.sources = {
				{
					name = "nvim_lsp",
					keyword_length = 1,
					max_item_count = 10,
				},
				{
					name = "nvim_lua",
					keyword_length = 1,
					max_item_count = 10,
				},
				{
					name = "luasnip",
					keyword_length = 1,
					max_item_count = 10,
				},
				{
					name = "buffer",
					keyword_length = 3,
					max_item_count = 10,
				},
				{
					name = "tags",
					keyword_length = 3,
					max_item_count = 10,
				},
				{
					name = "async_path",
					keyword_length = 2,
					max_item_count = 20,
				},
				{
					name = "rg",
					keyword_length = 3,
					max_item_count = 10,
				},
			}

			local source_mapping = {
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				tags = "[Tag]",
				async_path = "[Path]",
				rg = "[Rip]",
			}

			opts.formatting = {
				format = function(entry, vim_item)
					vim_item.menu = (source_mapping)[entry.source.name]
					return vim_item
				end,
			}

			opts.mapping = {
				-- ["<C-r>"] = cmp.mapping.scroll_docs(-4), -- Up
				-- ["<C-e>"] = cmp.mapping.scroll_docs(4), -- Down
				["<C-d>"] = cmp.mapping.select_next_item(),
				["<C-f>"] = cmp.mapping.select_prev_item(),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-s>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
			}
			opts.snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			}
		end,
	},
}
