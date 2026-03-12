return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},

	config = function()
		-- 1. Init Mason (The installer)
		require("mason").setup()

		-- 2. Init Mason-LSPConfig (The bridge)
		-- This ensures servers are installed and sets them up automatically
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"zls",
				"dockerls",
				"yamlls",
				"bashls"
			},
			handlers = {
				function(server_name)
					-- This function runs for every server in ensure_installed
					local capabilities = require('cmp_nvim_lsp').default_capabilities()
					require("lspconfig")[server_name].setup({
						capabilities = capabilities
					})
				end,
			}
		})

		-- 3. Init CMP (The Autocomplete Menu)
		local cmp = require('cmp')
		cmp.setup({
			-- Snippet engine is required for nvim-cmp to work, even if you don't use it directly
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				['<Enter>'] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			-- Only listen to the LSP (Language Server) for suggestions
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
			})
		})
	end
}
