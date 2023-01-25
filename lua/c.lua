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
vim.opt.signcolumn = 'yes'
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.ensure_installed({
  'sumneko_lua',
  'clangd',
  'marksman',
})
lsp.set_preferences({
  set_lsp_keymaps = false,
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
  },
})
lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  local bind = vim.keymap.set
  -- LSP actions
  bind('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  bind('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
  bind('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  bind('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  bind('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  bind('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
  bind('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  bind('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
  bind('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  bind('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
  -- Diagnostics
  bind('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
  bind('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  bind('n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end)
local luasnip = require('luasnip')
luasnip.config.set_config({
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave'
})
require('luasnip.loaders.from_vscode').lazy_load()
local cmp = require('cmp')
local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  -- confirm selection
  ['<CR>'] = cmp.mapping.confirm({select = false}),
  ['<C-y>'] = cmp.mapping.confirm({select = false}),
  -- navigate items on the list
  ['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
  ['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select_opts),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select_opts),
  -- scroll up and down in the completion documentation
  ['<C-d>'] = cmp.mapping.scroll_docs(5),
  ['<C-u>'] = cmp.mapping.scroll_docs(-5),
  -- toggle completion
  ['<C-e>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.close()
      fallback()
    else
      cmp.complete()
    end
  end),
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.confirm({select = false})
    elseif luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end, {'i', 's'}),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, {'i', 's'}),
})
local lspkind = require("lspkind")
lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = {
    {name = 'buffer', keyword_length = 1, max_item_count = 5},
    {name = 'nvim_lsp', keyword_length = 1, max_item_count = 5},
    {name = 'nvim_lua', keyword_length = 1, max_item_count = 5},
    {name = 'path', keyword_length = 1, max_item_count = 5},
    {name = 'luasnip', keyword_length = 1, max_item_count = 5},
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      menu = {
        buffer = '[BUF]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[API]',
        path = '[PATH]',
        luasnip = '[SNIP]',
      },
      preset = 'codicons',
      mode = 'symbol_text',
      maxwidth = 30,
      ellipsis_char = '...',
      before = function (entry, vim_item)
        return vim_item
      end,
    }),
  },
  documentation = false,
})
cmp.setup {
  window = {
    completion = {
      border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
      winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
    },
  },
}
lsp.setup()
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "lua",
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
-- empty setup using defaults
require("nvim-tree").setup()
-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "?", action = "toggle_help" },
        { key = "<CR>", action = "cd" },
        { key = "<CR>", action = "edit" },
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
