require("s") -- settings
require("g") -- gui settings
require("p") -- packer
require("c") -- config

-- Colorscheme settings
vim.opt.cursorline = true
-- require("colorscheme.vscode")
require("colorscheme.github")
-- require("colorscheme.tokyonight")

local copilot = 1

if copilot == 1 then
    require("copilot")
else
    require("lsp")
end
