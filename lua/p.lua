local ensure_packer = function()
  local fn = vim.fn
  -- Autocommand that reloads neovim whenever you save the plugins.lua file
  vim.cmd [[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost p.lua source <afile> | PackerSync
    augroup end
  ]]
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'github/copilot.vim'

  use 'numToStr/Comment.nvim'

  use 'windwp/nvim-autopairs'

  use 'folke/tokyonight.nvim'

  use 'projekt0n/github-nvim-theme'

  use 'Mofiqul/vscode.nvim'

  use 'kdheepak/lazygit.nvim'

  use 'lewis6991/gitsigns.nvim'

  use 'numToStr/FTerm.nvim'

  use 'lukas-reineke/indent-blankline.nvim'

  use 'norcalli/nvim-colorizer.lua'

  use 'nvim-tree/nvim-web-devicons'

  use 'andweeb/presence.nvim'

  use 'stevearc/dressing.nvim'

  use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim', tag = '0.1.0'}

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
  
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},
  
      -- Snippets
      {'L3MON4D3/LuaSnip'},

      -- Snippet Collection (Optional)
      {'rafamadriz/friendly-snippets'},

      -- Kind
      {'onsails/lspkind.nvim'},
    }
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  if packer_bootstrap then
    require('packer').sync()
  end
end)
