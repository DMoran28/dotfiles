return {
	"catppuccin/nvim",
	branch = "main",
	name = "catppuccin",
	priority = 1000,
	version = nil,
	opts = {
		flavour = "macchiato",
		highlight_overrides = {
			macchiato = function(palette)
				return {
					CursorLineNr = { fg = palette.peach },
					LineNr = { fg = palette.surface2 },
					NormalFloat = { bg = palette.base, fg = palette.blue },
					MsgArea = { bg = palette.mantle },
					Pmenu = { bg = palette.base, fg = palette.blue },
					PmenuSel = { bg = palette.surface0 },
				}
			end,
		},
		integrations = {
			blink_cmp = true,
			mason = true,
		},
	},
	init = function()
		vim.cmd.colorscheme("catppuccin")
	end,
}
