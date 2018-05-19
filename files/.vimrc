" .vimrc
" My personal vimrc file
" Author: Anders L. Hurum <andershurum@gmail.com>
" Source: github.com/peakbreaker/.dotfiles
" 
" Usually nowadays I'm living in spacemacs, but sometimes vim is needed (for
" example when I'm doing some edits on a server), so I thought I'd do a
" somewhat not horrible vimrc.
"
" Note that this file is considered a WIP at all times
"
"                      #      mmmmm                       #                   
" mmmm    mmm    mmm   #   m  #    #  m mm   mmm    mmm   #   m   mmm    m mm 
" #" "#  #"  #  "   #  # m"   #mmmm"  #"  " #"  #  "   #  # m"   #"  #   #"  "
" #   #  #""""  m"""#  #"#    #    #  #     #""""  m"""#  #"#    #""""   #    
" ##m#"  "#mm"  "mm"#  #  "m  #mmmm"  #     "#mm"  "mm"#  #  "m  "#mm"   #    
" #                                                                           
" #

" Plugins ----------------------------------------------------------------- {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'dylanaraps/wal.vim'
    colorscheme wal
call plug#end()

" }}}

" Basic configs ----------------------------------------------------------- {{{

let mapleader = " "

" load plugin
	execute pathogen#infect()
	execute pathogen#helptags()

" Some basics
	set nocompatible
	filetype off
	"filetype plugin on
	syntax on
	set encoding=utf-8

" UI Basics
	set number
	set relativenumber
	set ruler
	set cursorline       " Highlight current line
	set visualbell       " Blink cursor on error instead of beeping (grr)
	set title
	set textwidth=79

" Editing basics
	set wrap

" Splits at the bottom right
	set splitbelow
	set splitright

" Spaces / Tabs
	set tabstop=4 " number of spaces in one tab
	set softtabstop=4 " num spaces in tab when editing
	set expandtab       " tabs are spaces

" }}}

" Folding ----------------------------------------------------------------- {{{
	set foldlevelstart=0
" }}}


" Commenting -------------------------------------------------------------- {{{
" source: https://stackoverflow.com/a/24046914/2571881
let s:comment_map = {
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "python": '#',
    \   "ruby": '#',
    \   "rust": '\/\/',
    \   "sh": '#',
    \   "desktop": '#',
    \   "fstab": '#',
    \   "conf": '#',
    \   "profile": '#',
    \   "bashrc": '#',
    \   "bash_profile": '#',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "vim": '"',
    \   "tex": '%'
    \ }

function! ToggleComment()
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ '^\s*$'
	    return
	endif
        if getline('.') =~ '^\s*' . comment_leader
            " Uncomment the line
	    execute 'silent s/\v\s*\zs' . comment_leader . '\s*\ze//'
        else
            " Comment the line
            execute 'silent s/\v^(\s*)/\1' . comment_leader . ' /'
	endif
    else
        echo "No comment leader found for filetype"
    endif
endfunction

nnoremap <Leader>t :call ToggleComment()<CR>
vnoremap <Leader>t :call ToggleComment()<CR>

" Filetype-specific ------------------------------------------------------- {{{

" Vim {{{
augroup ft_vim
	au!
	au FileType vim setlocal foldmethod=marker keywordprg=:help
augroup END
" }}}

" }}}

" Shortcuts


" Security
set modelines=0


" Encoding

" Whitespace
set formatoptions=tcqrn1
set shiftwidth=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL
