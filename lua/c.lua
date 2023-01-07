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
})
lsp.set_preferences({
  set_lsp_keymaps = false
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
  bind('n', 'mv', '<cmd>lua vim.lsp.buf.rename()<cr>')
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
      mode = 'text',
      maxwidth = 30,
      ellipsis_char = '...',
      before = function (entry, vim_item)
        return vim_item
      end,
    }),
  },
  documentation = false,
})
lsp.setup()
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "c" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
