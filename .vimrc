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
"
" Instructions for non basic things :
" - <C-j> for jumpmenu
" - <leader>. for tags
" - m<space> for deleting all markers

" Fix for 2R issue https://github.com/1587/vim/issues/390
set t_u7=

" Plugins ----------------------------------------------------------------- {{{

" Autoinstall Plug if its not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Personal plugin
    Plug 'peakBreaker/peakPlugin'

" Theming
    Plug 'junegunn/vim-emoji'
    Plug 'dylanaraps/wal.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

" Syntax
    Plug 'cespare/vim-toml'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'posva/vim-vue'
    Plug 'ap/vim-css-color'

" Autocomplete/running & other utils
    Plug 'vim-syntastic/syntastic' | Plug 'Valloric/YouCompleteMe' | Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'othree/vim-autocomplpop'
    Plug 'vim-scripts/L9'

" Git
    Plug 'jreybert/vimagit'
    Plug 'airblade/vim-gitgutter'

" Filesystem/Project handling
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'dkprice/vim-easygrep'
    Plug 'ludovicchabant/vim-gutentags'

" Programming lang specifics
    Plug 'nvie/vim-flake8'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'hashivim/vim-terraform'

" Superpowers
    Plug 'tpope/vim-surround'
    Plug 'vim-scripts/ZoomWin'
    Plug 'janko-m/vim-test'
    Plug 'antoyo/vim-licenses'
    Plug 'kshenoy/vim-signature'
call plug#end()

" Configuring Plugins --------------------------------------------------- {{{

" Kite
    let g:kite_tab_complete=1

    set completeopt-=menu
    set completeopt+=menuone   " show the popup menu even when there is only 1 match
    set completeopt+=preview   " show preview window
    set completeopt+=noinsert  " don't insert any text until user chooses a match
    set completeopt-=noselect  " dont select first match

    autocmd CompleteDone * if !pumvisible() | pclose | endif

    let g:kite_documentation_continual=1

" Ultisnips
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:ultisnips_python_style="numpy"
    let g:UltiSnipsSnippetDirectories=["UltiSnips", "peakbreaker-snippets"]

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

" Use the Go LSP gopls for autocomplete
  let g:go_def_mode='gopls'
  let g:go_info_mode='gopls'

" if &filetype == 'go'
    " augroup peakbr_go_autocomplete
        " autocmd!
        " ...
    " augroup END
" endif

" augroup SPACEVIM_ASYNCRUN
"     autocmd!
"    " Automatically open the quickfix window
"     autocmd User AsyncRunStart call asyncrun#quickfix_toggle(15, 1)
" augroup END
"
" asyncrun now has an option for opening quickfix automatically
  let g:asyncrun_open = 15

" Control-p speedup
  "" Ignore some sane things
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip,venv*/*
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$|vendor\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$|venv$',
    \ 'file': '\.exe$\|\.so$\|\.dat$'
    \ }

  "" caching and optimized search
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  endif

" }}}
  let g:acp_enableAtStartup = 1

  " Terraform
  let g:terraform_align=1
  let g:terraform_fold_sections = 1
  let g:terraform_fmt_on_save=1
" }}}
" Basic configs ----------------------------------------------------------- {{{

" Some basics
    let mapleader = " "
    set nocompatible
    filetype off

" Wildmode autocomplete
    set wildmode=longest,list,full

"filetype plugin on
    syntax on
    set encoding=utf-8

" Enable modelines
    set modeline
    set modelines=3

" Statusline
    set laststatus=2  " always display the status line

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

" Colored column
    highlight ColorColumn ctermbg=magenta
    call matchadd('ColorColumn', '\%80v', 100)

" Tabs and spaces highlighting
    exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
    set list

" Searching
    set incsearch " Search incrementally
    set hlsearch " Highlight search
    set ignorecase " Disabling case sensitiveness
    set smartcase  " And enabling smart case sensitiveness
    " Clear search
    noremap <leader>n :let @/=''<cr> 
    noremap <leader>N :let @/=''<cr> 
    " Blink the targeted match
    highlight WhiteOnRed ctermbg=red 
    nnoremap <silent> n n:call HLNext(0.2)<CR>
    nnoremap <silent> N N:call HLNext(0.2)<CR>
    function! HLNext (blinktime)
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let target_pat = '\c\%#'.@/
        let blinks = 3
        for n in range(1,blinks)
            let red = matchadd('WhiteOnRed', target_pat, 101)
            redraw
            exec 'sleep ' . float2nr(a:blinktime / (2*blinks) * 1000) . 'm'
            call matchdelete(red)
            redraw
            exec 'sleep ' . float2nr(a:blinktime / (2*blinks) * 1000) . 'm'
        endfor
    endfunction


" Splits at the bottom right
    set splitbelow
    set splitright

" Spaces / Tabs
    set tabstop=4 " number of spaces in one tab
    set softtabstop=4 " num spaces in tab when editing
    set expandtab       " tabs are spaces

" Makes vim jimp to last position when reopening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Jump to matching brackety when inserting one
    set showmatch
    set matchtime=3

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

" function! pasteregister()
  " let r = input('Register: ')
  " execute ''

" endfunction

nnoremap <Leader>/ :call ToggleComment()<CR>
vnoremap <Leader>/ :call ToggleComment()<CR>
" }}}
" Jumping  ---------------------------------------------------------------- {{{
function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction
nnoremap <leader>j :call GotoJump()<CR>
" }}}
" Hotkeys  ---------------------------------------------------------------- {{{

" Switching between windows quicker
    nmap <C-J> <C-W>j
    nmap <C-K> <C-W>k
    nmap <C-H> <C-W>h
    nmap <C-L> <C-W>l

" Buffers
    nnoremap <leader>bp :prev<CR>
    nnoremap <leader>bn :next<CR>
    nnoremap <leader>bb :buffers<CR>:buffer<space>
    nnoremap <leader>bd :buffers<CR>:bdelete<space>

" Marks & jumps
    nnoremap <C-Y> <C-I>

" Git blaming
    vnoremap <leader>b :!git blame <C-R>=expand("%:p")<CR> -L '<C-R>=line("'<")<CR>,<C-R>=line("'>")<CR>'
    vnoremap <leader>B ygv :!git log --pretty=format:"<..> %s %H" -L <C-R>=line("'<")<CR>,<C-R>=line("'>")<CR>:<C-R>=expand("%:p")<CR> --abbrev-commit \| grep "<..>"
    " vmap <leader>B :!git blame <C-R>=expand("%:p")<CR> \| sed -n '<C-R>=line("'<")<CR>,<C-R>=line("'>")<CR>' p


" For folding
    nmap <Tab> za
    nnoremap <expr> <leader><Tab> &foldlevel ? 'zM' :'zR'

" For jumping to definition
    nmap <C-[> <C-t>
    nnoremap <leader>. :CtrlPTag<CR>

" For vimmagit
    nnoremap <leader>gs :Magit<CR>

" Autocompleting
    inoremap <C-Space> <C-X><C-O>

" Copying and pasting with system clipboard
    vnoremap <leader>c "+y
    nmap <leader>v "+p

" Move up/down editor lines
    nnoremap j gj
    nnoremap k gk

" When indenting we dont want to deselect
    vnoremap < <gv
    vnoremap > >gv

" For vimtests
    nnoremap <leader>tn :TestNearest
    nnoremap <leader>tf :TestFile
    nnoremap <leader>ts :TestSuite
    nnoremap <leader>tg :TestVisit
    nnoremap <leader>tr :TestLast<CR>
    nnoremap <leader>tl :TestLast<CR>

" Other
    nnoremap <leader>w :wqa<CR>
    nnoremap <leader>qq :qa!<CR>
    " Switch : and ;
    nnoremap ; :
    nnoremap : ;
    " Jumping forward in history


" }}}
" Autocmds  ---------------------------------------------------------------- {{{
  autocmd FileType sh nnoremap <buffer> <leader>r :w<CR>:exec '!bash' expand("%")<CR>
  autocmd FileType python nnoremap <buffer> <leader>r :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
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

" Last line
set showmode
set showcmd

" Formatting
"map <leader>q gqip
