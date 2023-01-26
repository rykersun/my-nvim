require("s") -- settings
require("g") -- gui settings
require("p") -- packer
require("c") -- config
require("lsp")

-- Colorscheme settings
vim.opt.cursorline = true
-- require("colorscheme.vscode")
require("colorscheme.github")
-- require("colorscheme.tokyonight")

local copilot = true

if copilot then
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
end
