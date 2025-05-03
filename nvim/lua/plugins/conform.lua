return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters = {
				stylua = {
					prepend_args = { "--column-width", "180" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = { timeout_ms = 500 },
		})
	end,
}
