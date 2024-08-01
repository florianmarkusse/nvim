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
			}
			opts.snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			}

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig["tsserver"].setup({
				capabilities = capabilities,
			})
			lspconfig["cssls"].setup({
				capabilities = capabilities,
			})
			lspconfig["html"].setup({
				capabilities = capabilities,
			})
			lspconfig["bashls"].setup({
				capabilities = capabilities,
			})
			lspconfig["clangd"].setup({
				capabilities = capabilities,
			})
			lspconfig["cmake"].setup({
				capabilities = capabilities,
			})
		end,
	},
}
