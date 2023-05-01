
local set = vim.opt
set.number=true
set.relativenumber=true
set.shiftwidth=8
set.termguicolors = true

--plugin setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
set.rtp:prepend(lazypath)
require('lazy').setup({
    'wbthomason/packer.nvim',
    { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } },
    'https://gitlab.com/__tpb/monokai-pro.nvim',
    { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", },
    	{
    		"adalessa/laravel.nvim",
    		dependencies = {
    		    "nvim-telescope/telescope.nvim",
    		},
    		cmd = {"Sail", "Artisan", "Composer"},
    		keys = {
    		    {"<leader>pa", ":Artisan<cr>"},
    		},
    		config = function()
    		    require("laravel").setup()
    		    require("telescope").load_extension("laravel")
    		end
	},
    {
    	"windwp/nvim-autopairs",
    	config = function() require("nvim-autopairs").setup {} end
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'gpanders/nvim-parinfer',
    'mfussenegger/nvim-dap',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'mfussenegger/nvim-dap-python',
    'norcalli/nvim-colorizer.lua',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    "rafamadriz/friendly-snippets",
    {'nvim-treesitter/nvim-treesitter' , build = ":TSUpdate"},
})

--lspserver Setup
require("mason").setup {
    ui = {
        icons = {
            package_installed = "✓",
	    package_pending = "➜ ",
            package_uninstalled = "✗"
        }
    }
}
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls" },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')
local configs = require ('lspconfig.configs')

--for enabling intelephense
if not configs.intelephense then
  configs.intelephense = {
    default_config = {
      cmd = { 'intelephense', '--stdio' };
      filetypes = { 'php' };
      root_dir = function (fname)
	      return vim.loop.cwd();
      end;
      settings = {
        intelephense = {
          files = {
            maxSize = 1000000;
          };
        }
      }
    }
  }
end

-- for arduino lsp server
local MY_FQBN = "esp8266:esp8266:nodemcu"
lspconfig.arduino_language_server.setup {
    cmd = {
        "arduino-language-server",
        "-cli-config", "$HOME/.arduino15/arduino-cli.yaml",
        "-fqbn",
        MY_FQBN
    }
}


-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'bashls', 'pyright', 'lua_ls', 'clangd','intelephense','phpactor' , 'html' ,'cssls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
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

-- mapping keys
--nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
--nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
--nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
--nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>

--dap server
local dap = require('dap')
    dap.adapters.python = {
      type = 'executable';
      command = os.getenv('HOME') .. '/.virtualenvs/tools/bin/python';
      args = { '-m', 'debugpy.adapter' };
}


--treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "bash", "html", "css","php","javascript", "python","jsonc" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
