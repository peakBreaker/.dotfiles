" .vimrc
" My personal vimrc file
" Author: Anders L. Hurum <andershurum@gmail.com>
" Source: github.com/peakbreaker/.dotfiles
" 
" Usually nowadays I'm living in spacemacs, but sometimes vim is needed (for
" example when I'm doing some edits on a server), so I thought I'd do a
" somewhat not horrible vimrc.
"
" Whenever a line has been thoughtfully considered and added, it is indented
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
    Plug 'jreybert/vimagit'
    Plug 'airblade/vim-gitgutter'
    Plug 'dylanaraps/wal.vim'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'vim-syntastic/syntastic' | Plug 'Valloric/YouCompleteMe' | Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
call plug#end()

" Configuring Plugins --------------------------------------------------- {{{

" Ultisnips
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"

" Airline linebar
    let g:airline_theme='wal'

" Quick run via <F5>
  nnoremap <F5> :call <SID>compile_and_run()<CR>
  nnoremap <F6> :call AsyncStop<CR>
  nnoremap <F9> :call asyncrun#quickfix_toggle(8)<cr>

  function! s:compile_and_run()
      exec 'w'
      exec "AsyncStop"
      if &filetype == 'c'
          exec "AsyncRun! gcc % -o %<; time ./%<"
      elseif &filetype == 'cpp'
         exec "AsyncRun! g++ -std=c++11 % -o %<; time ./%<"
      elseif &filetype == 'java'
         exec "AsyncRun! javac %; time java %<"
      elseif &filetype == 'sh'
         exec "AsyncRun! time bash %"
      elseif &filetype == 'python'
         exec "AsyncRun! time python3 %"
      endif
  endfunction

" augroup SPACEVIM_ASYNCRUN
"     autocmd!
"    " Automatically open the quickfix window
"     autocmd User AsyncRunStart call asyncrun#quickfix_toggle(15, 1)
" augroup END
"
" asyncrun now has an option for opening quickfix automatically
  let g:asyncrun_open = 15

" }}}

" }}}
" Basic configs ----------------------------------------------------------- {{{

let mapleader = " "

" Some basics
	set nocompatible
	filetype off
	"filetype plugin on
	syntax on
	set encoding=utf-8

" Enable modelines
    set modeline
    set modelines=3

" UI Basics
	set number
	set relativenumber
	set ruler
	set nocursorline       " Do not highlight current line (doest work so well with all themes)
	set visualbell       " Blink cursor on error instead of beeping (grr)
	set title
	set textwidth=79
    set wildmenu
    colorscheme wal

" Editing basics
	set wrap

" Searching
    " nnoremap / /\v
    " vnoremap / /\v
set hlsearch
set incsearch
    set ignorecase " Disabling case sensitiveness
    set smartcase  " And enabling smart case sensitiveness
set showmatch
map <leader><space> :let @/=''<cr> " clear search

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
" }}}
" Filetype-specific ------------------------------------------------------- {{{

" Vim {{{
augroup ft_vim
	au!
	au FileType vim setlocal foldmethod=marker keywordprg=:help
augroup END
" }}}

" }}}
" Hotkeys  ---------------------------------------------------------------- {{{

" Switching between windows quicker
    nmap <C-J> <C-W>j
    nmap <C-K> <C-W>k
    nmap <c-h> <c-w>h
    nmap <c-l> <c-w>l

" For folding
    nmap <Tab> za

" For vimmagit
    map <leader>gs :Magit <CR>
    map <leader>cc CC

" Copying and pasting with system clipboard
    vnoremap <leader>c "+y
    nmap <leader>v "+p

" Move up/down editor lines
    nnoremap j gj
    nnoremap k gk

" When indenting we dont want to deselect
    vnoremap < <gv
    vnoremap > >gv

" }}}

" Whitespace
set formatoptions=tcqrn1
set shiftwidth=2
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim


" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd


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
