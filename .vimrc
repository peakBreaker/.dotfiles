" vim: set norelativenumber:
" .vimrc
"
" My personal vimrc file
"
" Author: Anders L. Hurum <andershurum@gmail.com>
" Source: github.com/peakbreaker/.dotfiles
" Website: https://peakbreaker.com
" Email: andershurum@gmail.com
" Github: https://github.com/peakbreaker
"
"                      #      mmmmm                       #                   
" mmmm    mmm    mmm   #   m  #    #  m mm   mmm    mmm   #   m   mmm    m mm 
" #" "#  #"  #  "   #  # m"   #mmmm"  #"  " #"  #  "   #  # m"   #"  #   #"  "
" #   #  #""""  m"""#  #"#    #    #  #     #""""  m"""#  #"#    #""""   #    
" ##m#"  "#mm"  "mm"#  #  "m  #mmmm"  #     "#mm"  "mm"#  #  "m  "#mm"   #    
" #                                                                           
" #
"
" Whenever a line has been thoughtfully considered and added, it is indented

" Plugins ----------------------------------------------------------------- {{{

" Autoinstall Plug if its not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Theming
    Plug 'junegunn/vim-emoji'
    Plug 'dylanaraps/wal.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

" Autocomplete/running & other utils
    Plug 'vim-syntastic/syntastic' | Plug 'Valloric/YouCompleteMe' | Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'skywind3000/asyncrun.vim'

" Git
    Plug 'jreybert/vimagit'
    Plug 'zivyangll/git-blame.vim'
    Plug 'airblade/vim-gitgutter'

" Filesystem/Project handling
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'dkprice/vim-easygrep'

" Programming lang specifics
    Plug 'nvie/vim-flake8'

" Superpowers
    Plug 'tpope/vim-surround'
call plug#end()

" Configuring Plugins --------------------------------------------------- {{{

" Ultisnips
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"

" Airline linebar
    let g:airline_theme='wal'

" Quick run via <F5>
  nnoremap <F5> :call <SID>compile_and_run()<CR>
  nnoremap <F6> :AsyncStop<CR>
  nnoremap <F4> :call asyncrun#quickfix_toggle(8)<cr>

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

" Some basics
    let mapleader = " "
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
    set formatoptions=qron1

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

" Makes vim jimp to last position when reopening file
" I love this - Anders
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

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

" Python {{{
augroup python
    au!
    au filetype python let python_highlight_all=1
    " Linting
    " autocmd BufWritePost *.py call Flake8()
    let g:flake8_show_quickfix=0
    let g:flake8_show_in_gutter=1
    let g:flake8_show_in_file=0 
augroup END
" }}}

" }}}
" Hotkeys  ---------------------------------------------------------------- {{{

" Switching between windows quicker
    nmap <C-J> <C-W>j
    nmap <C-K> <C-W>k
    nmap <c-h> <c-w>h
    nmap <c-l> <c-w>l

" Git blaming
    vmap <leader>b :!git blame <C-R>=expand("%:p")<CR> -L '<C-R>=line("'<")<CR>,<C-R>=line("'>")<CR>'
    vmap <leader>B ygv :!git log --pretty=format:"<..> %s %H" -L <C-R>=line("'<")<CR>,<C-R>=line("'>")<CR>:<C-R>=expand("%:p")<CR> --abbrev-commit \| grep "<..>"
    " vmap <leader>B :!git blame <C-R>=expand("%:p")<CR> \| sed -n '<C-R>=line("'<")<CR>,<C-R>=line("'>")<CR>' p

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

" Other
    nmap <leader>w :wqa<CR>
    nmap <leader>qq :qa!<CR>

" }}}

" Whitespace
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

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL
