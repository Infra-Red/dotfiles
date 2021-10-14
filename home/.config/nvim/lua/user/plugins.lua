local M = {}

M.plugins = function(use)
  -- Add your own plugins
  -- use 'kyazdani42/nvim-tree.lua'
  -- use '~/my-prototype-plugin'
  -- see :help packer for more options
  use 'arcticicestudio/nord-vim'

  -- use 'avakhov/vim-yaml'
  use 'rizzatti/dash.vim'
  use 'shime/vim-livedown'

  -- Terraform
  use 'hashivim/vim-terraform'

  -- Spellcheck
  use 'kamykn/spelunker.vim'

  -- Ytt
  -- use 'cappyzawa/starlark.vim'
  use 'vmware-tanzu/ytt.vim'

  -- Go
  use 'ivy/vim-ginkgo'

  -- Toml support
  -- use 'cespare/vim-toml'
end

return M
