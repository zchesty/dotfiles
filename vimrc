syntax on
set number
set tabstop=2 shiftwidth=2 expandtab
set noswapfile
set backspace=indent,eol,start

" ── Plugins (vim-plug) ───────────────────────────────────────────────────────
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" ── Go ───────────────────────────────────────────────────────────────────────
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_code_completion_enabled = 1
