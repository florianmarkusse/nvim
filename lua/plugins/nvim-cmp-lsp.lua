return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", vim.lsp.buf.references, "Goto References")
					map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("gt", require("telescope.builtin").lsp_type_definitions, "Goto type definition")

					map("<leader>d", require("telescope.builtin").lsp_document_symbols, "[D]ocument Symbols")
					map("<leader>w", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")
					map("<leader>r", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>c", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("<leader>p", vim.lsp.buf.signature_help, "Peek signature")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- highlight references to symbol under cursor
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local servers = {
				clangd = {},
				["cmake-language-server"] = {
					init_options = {
						buildDirectory = "build",
					},
				},
				gopls = {
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
							gofumpt = true,
						},
					},
				},
				pyright = {},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								allFeatures = true,
								overrideCommand = {
									"cargo",
									"clippy",
									"--workspace",
									"--message-format=json",
									"--all-targets",
									"--all-features",
								},
							},
							imports = {
								granularity = {
									group = "module",
								},
								prefix = "self",
							},
							cargo = {
								buildScripts = {
									enable = true,
								},
							},
							procMacro = {
								enable = true,
							},
						},
					},
					on_attach = function(_client, _bufnr)
						-- vim.lsp.inlay_hint.enable(bufnr)
					end,
				},
				ts_ls = {},
				ruff_lsp = {},
				yamlls = {},
				jsonls = {},
				ltex = {
					language = "en-GB",
				},
				terraformls = {},
				bashls = {},
				dockerls = {},
				graphql = {},
				tailwindcss = {},
				marksman = {},
				emmet_ls = {
					-- on_attach = on_attach,
					capabilities = capabilities,
					filetypes = {
						"css",
						"eruby",
						"html",
						"javascript",
						"javascriptreact",
						"less",
						"sass",
						"scss",
						"svelte",
						"pug",
						"typescriptreact",
						"vue",
					},
					init_options = {
						html = {
							options = {
								-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
								["bem.enabled"] = true,
							},
						},
					},
				},
				kotlin_language_server = {},
				vale_ls = {},
				lua_ls = {
					-- cmd = {...},
					-- filetypes { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
								-- If lua_ls is really slow on your computer, you can try this instead:
								-- library = { vim.env.VIMRUNTIME },
							},
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"goimports",
				"clang-format",
				"prettierd",
				"prettier",
				"ktlint",
				"rustfmt",
				"yamlfmt",
				"taplo",
				"shfmt",
				"sqlfluff",
				"jq",
				"cmake-language-server",
				"gersemi",
				"graphql",
			})
			-- This is slow
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
