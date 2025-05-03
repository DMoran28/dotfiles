return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.opts.hl = "Function"
		dashboard.section.header.val = {
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", "<cmd>e Unnamed<CR>"),
			dashboard.button("e", "󱞊  File explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("t", "󱎸  Find text", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("u", "󱍸  Update plugins", "<cmd>Lazy sync | MasonUpdate<CR>"),
			dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim | e init.lua | NvimTreeOpen<CR>"),
			dashboard.button("q", "󰅙  Quit", "<cmd>qa<CR>"),
		}

		local date = "󰸗 " .. vim.fn.strftime("%d/%m/%Y")
		local plugins = " Loaded " .. #require("lazy").plugins() .. " plugins"
		local version = " " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
		dashboard.section.footer.opts.hl = "Identifier"
		dashboard.section.footer.val = version .. "   " .. plugins .. "   " .. date

		require("alpha").setup({
			layout = {
				{ type = "padding", val = 5 },
				dashboard.section.header,
				{ type = "padding", val = 5 },
				dashboard.section.buttons,
				{ type = "padding", val = 3 },
				dashboard.section.footer,
			},
		})
	end,
}
