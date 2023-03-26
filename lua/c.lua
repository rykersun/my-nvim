vim.g.mapleader = " "
require('mason.settings').set({
  ui = {
    border = 'rounded'
  }
})
vim.keymap.set('n', '<leader>m', ':Mason<CR>')
require('Comment').setup({
  toggler = {
    line = '<C-/>',
  },
  opleader = {
    line = '<C-/>',
  },
})
require('nvim-autopairs').setup({})
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "vim",
    "c",
    "markdown",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
vim.keymap.set('n', '<leader>l', ':LazyGitCurrentFile<CR>')
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)
    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
require'FTerm'.setup({
  border = 'rounded',
  dimensions  = {
    height = 0.9,
    width = 0.9,
  },
})
vim.keymap.set('n', '<C-`>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-`>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
require 'colorizer'.setup()
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"
require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>W', builtin.live_grep, {})
vim.api.nvim_set_keymap('n', '<leader>d', ':lua require"telescope.builtin".diagnostics({ bufnr = 0 })<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>f', ':lua require"telescope.builtin".find_files({ hidden = false })<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>F', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})
local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    diagnostics = {
      -- theme = "dropdown",
      -- theme = "cursor",
      theme = "ivy",
    },
    live_grep = {
      theme = "dropdown",
      -- theme = "cursor",
      -- theme = "ivy",
    },
    lsp_document_symbols = {
      theme = "dropdown",
      -- theme = "cursor",
      -- theme = "ivy",
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      -- theme = "dropdown",
      theme = "cursor",
      -- theme = "ivy",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  },
})
require("presence"):setup({})
-- examples for your init.lua
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "?", action = "toggle_help" },
        { key = "<CR>", action = "cd" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle!<CR>')
require("bufferline").setup{}
vim.keymap.set('n', '<leader>w', '<C-w>')
vim.keymap.set('n', '<leader>n', ':noh<CR>')
vim.keymap.set('n', '<leader>c', ':bd<CR>')
vim.keymap.set('n', '<leader>C', ':bd!<CR>')
vim.keymap.set('n', 'L', ':bn<CR>')
vim.keymap.set('n', 'H', ':bp<CR>')
vim.keymap.set('n', '<leader>q', ':qa<CR>')
vim.keymap.set('n', '<leader>Q', ':qa!<CR>')
vim.keymap.set('n', '<leader>r', ':e<CR>')
vim.keymap.set('n', '<leader>R', ':e!<CR>')
