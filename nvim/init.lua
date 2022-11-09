-- my neovim config uwu

-- functionality setup
local set = vim.opt
set.number=true
set.relativenumber=true
set.shiftwidth=8
set.termguicolors = true

--plugin setup
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'https://gitlab.com/__tpb/monokai-pro.nvim'
    use { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", }
    --use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
    use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'norcalli/nvim-colorizer.lua'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use "rafamadriz/friendly-snippets"

if packer_bootstrap then
    require('packer').sync()
  end
end)

--lspserver Setup
require("mason").setup {
    ui = {
        icons = {
            package_installed = "✓",
	    package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
}
require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua" },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'bashls', 'pyright', 'sumneko_lua', 'clangd', 'html','cssls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

--theme setup
require'colorizer'.setup{
    '*';
    css = { rgb_fn = true;RRGGBBAA = true; };
}

vim.g.monokaipro_transparent=true
vim.cmd[[colorscheme monokaipro]]
--require('pywal').setup()
require('lualine').setup {
  options = {
    theme = 'monokaipro',
    --theme = 'pywal',
  }
}
--vim.cmd[[hi Normal ctermbg=none guibg=none]]
--vim.cmd[[hi NormalNC ctermbg=none guibg=none]]
--vim.cmd[[hi Comment ctermbg=none guibg=none]]
--vim.cmd[[hi Constant ctermbg=none guibg=none]]
--vim.cmd[[hi Special ctermbg=none guibg=none]]
--vim.cmd[[hi Identifier ctermbg=none guibg=none]]
--vim.cmd[[hi Statement ctermbg=none guibg=none]]
--vim.cmd[[hi PreProc ctermbg=none guibg=none]]
--vim.cmd[[hi Type ctermbg=none guibg=none]]
--vim.cmd[[hi Underlined ctermbg=none guibg=none]]
--vim.cmd[[hi Todo ctermbg=none guibg=none]]
--vim.cmd[[hi String ctermbg=none guibg=none]]
--vim.cmd[[hi Function ctermbg=none guibg=none]]
--vim.cmd[[hi Conditional ctermbg=none guibg=none]]
--vim.cmd[[hi Repeat ctermbg=none guibg=none]]
--vim.cmd[[hi Operator ctermbg=none guibg=none]]
--vim.cmd[[hi Structure ctermbg=none guibg=none]]
--vim.cmd[[hi LineNr ctermbg=none guibg=none]]
--vim.cmd[[hi NonText ctermbg=none guibg=none]]
--vim.cmd[[hi SignColumn ctermbg=none guibg=none]]
--vim.cmd[[hi CursorLineNr ctermbg=none guibg=none]]
--vim.cmd[[hi EndOfBuffer ctermbg=none guibg=none]]
