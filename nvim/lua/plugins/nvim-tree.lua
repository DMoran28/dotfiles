return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-tree").setup({
			git = { ignore = false },
			renderer = {
				highlight_opened_files = "name",
				icons = {
					git_placement = "after",
					glyphs = {
						git = { ignored = "󱥸 ", staged = "", unstaged = "", untracked = "?" },
					},
					symlink_arrow = "  ",
				},
			},
			sync_root_with_cwd = true,
			view = {
				side = "right",
				width = 35,
			},
		})
	end,
}
