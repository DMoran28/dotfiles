vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File [E]xplorer" })
vim.keymap.set("n", "<leader>q", "<cmd>NvimTreeClose | q!<CR>", { desc = "[Q]uit Neovim" })
vim.keymap.set("n", "<leader>w", "<C-w>w", { desc = "Switch [W]indow Focus" })

-- Buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>s", "<cmd>w!<CR>", { desc = "[S]ave Current Buffer" })

vim.keymap.set("n", "<leader>c", function()
	local current = vim.api.nvim_get_current_buf()
	local buffers = vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
	end, vim.api.nvim_list_bufs())

	if #buffers > 1 then
		vim.cmd.bprev()
	end

	vim.cmd.bdelete(current)
end, { desc = "[C]lose Current Buffer" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitsigns-blame", "help", "lazy", "mason" },
	callback = function()
		vim.keymap.set("n", "<Esc>", "<cmd>q<cr>", { buffer = true })
		vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true })
	end,
})

-- Gitsigns
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>gb", gitsigns.blame, { desc = "[G]it: Show [B]lame" })
vim.keymap.set("n", "<leader>gr", gitsigns.reset_buffer, { desc = "[G]it: [R]eset Buffer" })
vim.keymap.set("n", "<leader>gs", gitsigns.stage_buffer, { desc = "[G]it: [S]tage Buffer" })

vim.keymap.set("n", "<leader>gn", function()
	gitsigns.next_hunk()
	gitsigns.preview_hunk_inline()
end, { desc = "[G]it: [N]ext Hunk" })

vim.keymap.set("n", "<leader>gp", function()
	gitsigns.prev_hunk()
	gitsigns.preview_hunk_inline()
end, { desc = "[G]it: [P]revious Hunk" })

-- Lazy
local lazy = require("lazy")
vim.keymap.set("n", "<leader>z", lazy.show, { desc = "[L]azy: Open Plugin Manager" })

-- Mason
local mason = require("mason.ui")
vim.keymap.set("n", "<leader>m", mason.open, { desc = "[M]ason: Open LSP Manager" })

-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "[F]ind with [G]rep" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "[F]ind [K]eymaps" })

vim.keymap.set("n", "<leader>fc", function()
	telescope.current_buffer_fuzzy_find({ previewer = false })
end, { desc = "[F]ind [C]urrent Buffer" })

vim.keymap.set("n", "<leader>fo", function()
	telescope.live_grep({ grep_open_files = true })
end, { desc = "[F]ind [O]pen Buffers" })

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, { buffer = event.buf, desc = "[L]SP: Show [C]ode Actions" })
		vim.keymap.set("n", "<leader>ld", telescope.lsp_definitions, { buffer = event.buf, desc = "[L]SP: Show [D]efinition" })
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "[L]SP: Show [D]eclaration" })
		vim.keymap.set("n", "<leader>li", telescope.lsp_implementations, { buffer = event.buf, desc = "[L]SP: Show [I]mplementation" })
		vim.keymap.set("n", "<leader>lr", telescope.lsp_references, { buffer = event.buf, desc = "[L]SP: Show [R]eferences" })
		vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { buffer = event.buf, desc = "[L]SP: [R]ename Symbols" })
		vim.keymap.set("n", "<leader>ls", telescope.lsp_dynamic_workspace_symbols, { buffer = event.buf, desc = "[L]SP: Show [S]ymbols" })
		vim.keymap.set("n", "<leader>lt", telescope.lsp_type_definitions, { buffer = event.buf, desc = "[L]SP: Show [T]ype Definition" })

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local group = vim.api.nvim_create_augroup("highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = group,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = group,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				callback = function(ev)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "highlight", buffer = ev.buf })
				end,
			})
		end
	end,
})
