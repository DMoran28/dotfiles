return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { ".DS_Store", ".git/" },
				layout_config = {
					mirror = true,
					prompt_position = "top",
				},
				layout_strategy = "vertical",
				mappings = {
					i = {
						["<A-Down>"] = actions.preview_scrolling_down,
						["<A-Up>"] = actions.preview_scrolling_up,
					},
					n = {
						["q"] = actions.close,
						["<A-Down>"] = actions.preview_scrolling_down,
						["<A-Up>"] = actions.preview_scrolling_up,
					},
				},
				sorting_strategy = "ascending",
				vimgrep_arguments = { "grep", "-b", "-E", "-i", "-I", "-n", "-R", "-s" },
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
			pickers = {
				find_files = { hidden = true },
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- Helper to dim the background when opening the prompt
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "TelescopePrompt",
			callback = function(context)
				local buffer = vim.api.nvim_create_buf(false, true)
				local name = "TelescopeBackground"
				local win = vim.api.nvim_open_win(buffer, false, {
					col = 0,
					height = vim.o.lines,
					relative = "editor",
					row = 0,
					style = "minimal",
					width = vim.o.columns,
				})

				vim.api.nvim_set_hl(0, name, { bg = "#000000", default = true })
				vim.wo[win].winhighlight = "Normal:" .. name
				vim.wo[win].winblend = 65

				vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave" }, {
					buffer = context.buf,
					callback = function()
						if vim.api.nvim_buf_is_valid(buffer) then
							vim.api.nvim_buf_delete(buffer, { force = true })
						end
						if vim.api.nvim_win_is_valid(win) then
							vim.api.nvim_win_close(win, true)
						end
					end,
				})
			end,
		})
	end,
}
