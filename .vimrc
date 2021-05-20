set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
" ________________________________________________________________________________
" Markdown editing
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'iamcco/markdown-preview.nvim'
Plugin 'junegunn/goyo.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" General environment settings
" ________________________________________________________________________________
syntax enable
syntax on
set number
" show the matching part of the pair for [] () {}
set showmatch

" Python Editing
" ________________________________________________________________________________

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set smartindent

let python_highlight_all=1

" ________________________________________________________________________________
" iamacco/markdown-preview.nvim

let g:mkdp_markdown_css='/home/philipbudden/.local/lib/github-markdown-css/github-markdown-css'

" ________________________________________________________________________________
" plasticboy/vim-markdown

autocmd FileType markdown set conceallevel=0
autocmd FileType markdown let b:sleuth_automatic=0
autocmd FileType markdown normal zR
