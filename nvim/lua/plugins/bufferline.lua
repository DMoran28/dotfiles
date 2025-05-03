return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local palette = require("catppuccin.palettes").get_palette()
		require("bufferline").setup({
			highlights = require("catppuccin.groups.integrations.bufferline").get({
				custom = {
					macchiato = {
						buffer_selected = { bg = palette.surface0 },
						error_selected = { bg = palette.surface0 },
						error_diagnostic_selected = { bg = palette.surface0 },
						fill = { bg = palette.base },
						hint_selected = { bg = palette.surface0 },
						hint_diagnostic_selected = { bg = palette.surface0 },
						info_selected = { bg = palette.surface0 },
						info_diagnostic_selected = { bg = palette.surface0 },
						modified_selected = { bg = palette.surface0 },
						pick = { bg = "#ff0000" },
						separator = { fg = palette.base },
						separator_selected = { bg = palette.surface0, fg = palette.base },
						separator_visible = { fg = palette.base },
						warning_selected = { bg = palette.surface0 },
						warning_diagnostic_selected = { bg = palette.surface0 },
					},
				},
			}),
			options = {
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level)
					local icons = { error = "󰅚 ", hint = "󰌶 ", info = "󰋽 ", warning = " " }
					return icons[level] .. count
				end,
				offsets = {
					{
						filetype = "NvimTree",
						highlight = "NvimTreeNormal",
						separator = true,
						text = " 󱙓  File Explorer",
						text_align = "left",
					},
				},
				separator_style = "slope",
				show_buffer_close_icons = false,
			},
		})
	end,
}
