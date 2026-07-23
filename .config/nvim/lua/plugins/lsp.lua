vim.pack.add({
  { src = git("neovim/nvim-lspconfig.git") },
  { src = git("williamboman/mason.nvim.git") },
  { src = git("williamboman/mason-lspconfig.nvim.git") },
  { src = git("hrsh7th/nvim-cmp.git") },
  { src = git("hrsh7th/cmp-nvim-lsp.git") },
  { src = git("L3MON4D3/LuaSnip.git") },
  { src = git("saadparwaiz1/cmp_luasnip.git") },
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "clangd",
    "zls",
    "dockerls",
    "yamlls",
    "bashls",
  },
  handlers = {
    function(server_name)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
      })
    end,
  },
})

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
})
