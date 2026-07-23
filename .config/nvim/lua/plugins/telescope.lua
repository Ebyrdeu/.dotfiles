vim.pack.add({
	{ src = git("nvim-lua/plenary.nvim.git") },
	{ src = git("kyazdani42/nvim-web-devicons.git") },
	{ src = git("nvim-telescope/telescope-fzf-native.nvim.git") },
	{ src = git("nvim-telescope/telescope.nvim.git") },
})

local telescope = require("telescope")
telescope.setup({
	defaults = {
		file_ignore_patterns = { ".cache", ".git/", "node_modules/" },
	},
})

pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", function()
	builtin.find_files({ hidden = true })
end, { desc = "Telescope find files" })

vim.keymap.set("n", "<leader>sr", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>sf", builtin.live_grep, { desc = "Telescope live grep" })
