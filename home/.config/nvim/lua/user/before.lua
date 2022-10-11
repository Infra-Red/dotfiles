-- Called before everything, even before loading plugins
-- Do things that need to happen very early such as:
-- vim.g.fzf_command_prefix = 'Fuzzy'
-- ...
local cmd = vim.cmd

cmd([[autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync(nil, 10000)]])
