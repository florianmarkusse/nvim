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
				group = vim.api.nvim_create_augroup(
					"kickstart-lsp-attach",
					{ clear = true }
				),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set(
							"n",
							keys,
							func,
							{ buffer = event.buf, desc = "LSP: " .. desc }
						)
					end
					map(
						"gd",
						require("telescope.builtin").lsp_definitions,
						"[G]oto [D]efinition"
					)
					map("gr", vim.lsp.buf.references, "Goto References")
					map(
						"gi",
						require("telescope.builtin").lsp_implementations,
						"[G]oto [I]mplementation"
					)
					map(
						"gt",
						require("telescope.builtin").lsp_type_definitions,
						"Goto type definition"
					)

					map(
						"<leader>d",
						require("telescope.builtin").lsp_document_symbols,
						"[D]ocument [S]ymbols"
					)
					map(
						"<leader>w",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>r", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>c", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map(
						"<leader>p",
						vim.lsp.buf.signature_help,
						"Peek signature"
					)
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- highlight references to symbol under cursor
					local client =
						vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client.server_capabilities.documentHighlightProvider
					then
						vim.api.nvim_create_autocmd(
							{ "CursorHold", "CursorHoldI" },
							{
								buffer = event.buf,
								callback = vim.lsp.buf.document_highlight,
							}
						)
						vim.api.nvim_create_autocmd(
							{ "CursorMoved", "CursorMovedI" },
							{
								buffer = event.buf,
								callback = vim.lsp.buf.clear_references,
							}
						)
					end
				end,
			})

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
