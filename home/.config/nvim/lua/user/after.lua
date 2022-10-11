-- Called after everything just before setting a default colorscheme
-- Configure you own bindings or other preferences. e.g.:
--
-- vim.opt.number = false -- No line numbers
-- require('utils').map('n', 's', ':MultipleCursorsFind<cr>')
-- vim.cmd[[colorscheme hybrid]]
-- ...
--
vim.cmd([[
colorscheme base16-material
]])
require 'lspconfig'.pylsp.setup {}
