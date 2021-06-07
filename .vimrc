""""""""""""""""""""""""""""""""
" Configure global environment "
""""""""""""""""""""""""""""""""

syntax enable
syntax on
set number
set linebreak
set termguicolors
set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set spelllang=en_gb

""""""""""""""""""""""""""""
" Manage Plugins with Plug "
""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim'
Plug 'junegunn/goyo.vim'
Plug 'xuhdev/vim-latex-live-preview'

call plug#end()

"""""""""""""""""""""
" Configure plugins "
"""""""""""""""""""""

" iamacco/markdown-preview.nvim
let g:mkdp_markdown_css='~/.local/lib/github-markdown-css/github-markdown-css'

" plasticboy/vim-markdown
autocmd FileType markdown set conceallevel=0
autocmd FileType markdown let b:sleuth_automatic=0
autocmd FileType markdown normal zR

""""""""""""""""""""""""""""
" Configure Python editing "
""""""""""""""""""""""""""""

au BufNewFile,BufRead *.py
    \ set nospell |
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set smartindent

let python_highlight_all=1
