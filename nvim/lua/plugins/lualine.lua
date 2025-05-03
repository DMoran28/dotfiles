return {
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("lualine").setup({
			options = {
				component_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_b = { { "branch", icon = "" }, "diff" },
				lualine_x = { "filetype" },
				lualine_y = { "diagnostics", { "lsp_status", symbols = { done = "" } } },
				lualine_z = { "progress" },
			},
		})
	end,
}
