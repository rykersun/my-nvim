require("s") -- settings
require("g") -- gui settings
require("p") -- packer
require("c") -- config
require("lsp")

-- Colorscheme settings
vim.opt.cursorline = true

-- require("colorscheme.vscode")
-- require("colorscheme.vscode.lualine")

-- require("colorscheme.github")
-- require("colorscheme.github.lualine")

-- require("colorscheme.tokyonight")
-- require("colorscheme.tokyonight.lualine")

require("colorscheme.gruvbox")
require("colorscheme.gruvbox.lualine")

local copilot = true

if copilot then
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
end
