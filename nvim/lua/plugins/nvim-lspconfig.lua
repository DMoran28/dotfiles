return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local icons = { error = "󰅚 ", hint = "󰌶 ", info = "󰋽 ", warning = " " }
		vim.diagnostic.config({
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.error,
					[vim.diagnostic.severity.HINT] = icons.hint,
					[vim.diagnostic.severity.INFO] = icons.info,
					[vim.diagnostic.severity.WARN] = icons.warning,
				},
			},
			virtual_text = true,
		})

		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						telemetry = { enable = false },
						workspace = {
							library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
						},
					},
				},
			},
		}

		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, {
			"stylua",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(name)
					local capabilities = require("blink.cmp").get_lsp_capabilities()
					local server = servers[name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[name].setup(server)
				end,
			},
		})
	end,
}
