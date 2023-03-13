syntax on
set tabstop=4
set shiftwidth=4
set nu
set rnu
set softtabstop=4
set autoindent
set smartindent
set termguicolors
set colorcolumn=72,120
set mouse=a
filetype plugin indent on

call plug#begin()

Plug 'marko-cerovac/material.nvim'
Plug 'neoclide/coc.nvim'
Plug 'elkowar/yuck.vim'

call plug#end()

" Color Scheme
"let g:material_style = "darker"
"colorscheme material

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
