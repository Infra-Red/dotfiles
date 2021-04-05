" Called after everything just before setting a default colorscheme
" Configure you own bindings or other preferences. e.g.:

" set nonumber " No line numbers
" let g:gitgutter_signs = 0 " No git gutter signs
" let g:SignatureEnabledAtStartup = 0 " Do not show marks
" nmap s :MultipleCursorsFind
" colorscheme hybrid
" let g:lightline['colorscheme'] = 'wombat'
" ...

if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f --hidden'
endif

let $PATH = g:go_bin_path . ':' . $PATH

colorscheme base16-material
