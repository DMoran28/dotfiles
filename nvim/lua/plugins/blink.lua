return {
	"saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",
	opts = {
		completion = {
			documentation = {
				auto_show = true,
				window = { border = "rounded" },
			},
			menu = { border = "rounded" },
		},
		fuzzy = { implementation = "lua" },
		keymap = { preset = "enter" },
		signature = {
			enabled = true,
			window = { border = "rounded" },
		},
		sources = {
			default = { "buffer", "lsp", "path" },
			snippets = { score_offset = -100 },
		},
	},
	opts_extend = { "sources.default" },
}
