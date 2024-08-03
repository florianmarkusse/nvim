return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>ft",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
					})
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		init = function()
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
		opts = function(_, opts)
			opts.notify_on_error = true
			opts.format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					timeout_ms = 1000,
					lsp_fallback = true,
				}
			end

			-- formatters = {
			-- 	clang = {
			-- 		inherit = false,
			-- 		command = "clang-format",
			-- 		args = {
			-- 			"-style=file",
			-- 			"$FILENAME",
			-- 		},
			-- 	},
			-- },

			-- NOTE If you add a formatter here, make sure it is also present in nvim-cmp-lsp
			opts.formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports" },
				c = {
					"clang-format",
				},
				h = {
					"clang-format",
				},
				cpp = {
					"clang-format",
				},
				hpp = {
					"clang-format",
				},
				javascript = {
					"prettierd",
					"prettier",
					stop_after_first = true,
				},
				javascriptreact = {
					"prettierd",
					"prettier",
					stop_after_first = true,
				},
				typescript = {
					"prettierd",
					"prettier",
					stop_after_first = true,
				},
				typescriptreact = {
					"prettierd",
					"prettier",
					stop_after_first = true,
				},
				html = {
					"prettierd",
					"prettier",
					stop_after_first = true,
				},
				css = {
					"prettierd",
					"prettier",
					stop_after_first = true,
				},
				kotlin = { "ktlint" },
				rust = { "rustfmt" },
				yaml = { "yamlfmt" },
				toml = { "taplo" },
				shell = { "shfmt" },
				sql = { "sqlfluff" },
				markdown = { "prettierd", "markdownlint" },
				json = { "jq" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			}
		end,
	},
}
