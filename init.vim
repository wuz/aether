" ------------------------------------------------------------ DEIN
let g:dein#install_progress_type = 'none'
let g:dein#install_message_type = 'none'

if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  " dein
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " functionality
  call dein#add('w0rp/ale')
  call dein#add('Olical/vim-enmasse')
  call dein#add('vim-scripts/auto-pairs-gentle')
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim')
  call dein#add('moll/vim-bbye')
  call dein#add('matze/vim-move')
  call dein#add('tpope/vim-surround')
  call dein#add('terryma/vim-multiple-cursors')
  call dein#add('tpope/vim-commentary')

  " display
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('airblade/vim-gitgutter')
  
  " behavior
  call dein#add('Shougo/neoinclude.vim')
  call dein#add('wuz/ProjectLevel')
  call dein#add('tpope/vim-sleuth')

  " completion
  call dein#add('Shougo/deoplete.nvim')

  " languages
  call dein#add('sheerun/vim-polyglot')
  call dein#add('captbaritone/better-indent-support-for-php-with-html')
  call dein#add('ap/vim-css-color')
  call dein#add('gko/vim-coloresque')

  call dein#add('dankneon/vim')

  call dein#end()
  call dein#save_state()
endif
filetype plugin indent on
syntax enable

" ------------------------------------------------------------ SETUP

let mapleader="\<Space>"   " leader is <space>
let maplocalleader = "\\"  " local leader is \

" Reload Vim when .vimrc is changed
augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

" ------------------------------------------------------------ FUNCTIONALITY

set hidden                            " remember buffer history
set history=1000                      " increase history from 20 to 1000

set undofile                                  " persistent undo
set backupdir=~/.config/nvim/backups          " use global backup directory
set directory=~/.config/nvim/swaps            " use global swaps directory
set undodir=~/.config/nvim/undo               " use global undo directory

" yank to system clipboard
vmap <Leader>y "+y 
" delete to system clipboard
vmap <Leader>d "+d 
" paste from system clipboard
nmap <Leader>p "+p 
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
" replace globally
vmap <Leader>r "hy:%s/<C-r>h//gc<left><left><left>

" make line numbers relative
set relativenumber

" show line numbers
set nu

" fix backspace behavior
set backspace=indent,eol,start

" Always show status line
set laststatus=2

" enable extended regexes.
set magic

" disable annoying error bells
set noerrorbells

" disable use visual bells
set visualbell

" Set omni-completion method.
set ofu=syntaxcomplete#Complete

" more keys/sec == 1337 H4X0R
set ttyfast

" no stupid intro message
set shortmess=atI

" Show the current mode.
set showmode

" Always show tab bar.
set showtabline=2

" Don't redraw all the time
set lazyredraw

" highlight matching [{}]
set showmatch

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set notimeout
set ttimeout
set ttimeoutlen=10

" ------------------------------------------------------------ TERMINAL

tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" ------------------------------------------------------------ VISUAL

hi Normal ctermbg=NONE guibg=NONE
set lazyredraw
if (has("termguicolors"))
 set termguicolors
endif
syntax on

set background=dark
colorscheme dank-neon

highlight VertSplit ctermbg=NONE
set cursorline

" ------------------------------------------------------------ FOLDING MARKERS

set foldmarker=#--,--
set foldlevel=0
set foldmethod=marker


" ------------------------------------------------------------ INDENTATION

filetype indent on                    " load filetype-specific indents
set expandtab                         " tabs are spaces
set softtabstop=2                     " number of columns in insert mode
set smartindent                       " indent files smartly
set ts=2 sw=2 et
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1
let g:indent_guides_color_change_percent = 5
let g:indent_guides_exclude_filetypes = ['help', 'netrw']

" ------------------------------------------------------------ FIND/REPLACE

" search as characters are typed
set incsearch
" highlight matches
set hlsearch
" ignore case of searches
set ignorecase
" default to global search
set gdefault
" ignore ignore case if uppercase letters
set smartcase
" Searches wrap around end of file
set wrapscan

" ------------------------------------------------------------ FZF/SEARCH

let g:fzf_tags_command = 'ctags --extra=+f -R'
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" use leader-/ to open FZF
noremap <leader>/ :Files<CR>
nmap <Leader>b :Buffers<CR>

" open up ripgrep search with <space>a
nnoremap <Leader>a :Rg

" use ripgrep for fzf
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


" ------------------------------------------------------------ NORMAL MODE

" insert line with <space>Enter
nnoremap <Leader><CR> o<esc>

" unhighlight everything
nnoremap <Leader>x :noh<CR>

" delete buffer
nnoremap <Leader>q :Bdelete<CR>

nnoremap n nzzzv
nnoremap N Nzzzv

" ------------------------------------------------------------ EDITING

" edit location buffer
map <Leader>f :EnMasse<CR>

" ------------------------------------------------------------ COMPLETION

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
" Disable the candidates in Comment syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment'])


" ------------------------------------------------------------ FILETREE

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

noremap <leader>\ :20Lexplore<CR>

function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NetrwTreeListing") && bufwinnr(t:NetrwTreeListing) != -1)
        \ || &buftype == 'quickfix'
    q
  endif
endfunction
augroup CloseIfOnlyControlWinLeft
  au!
  au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END

" ------------------------------------------------------------ WILDMENU

" use wildmenu
set wildmenu
" tab complete commands
set wildchar=<TAB>

" ignore certain extensions in wildmenu
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/smarty/*,*/vendor/*,*/node_modules/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*

" Complete only until point of ambiguity.
set wildmode=list:longest

" splits reduced to single line.
set winminheight=0

" ------------------------------------------------------------ STATUSLINE

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '♥' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?l:branchname:''
endfunction

function! StatusSpace()
  return '  '
endfunction

function! StatusSeperator()
  return ' | '
endfunction

" left
set statusline=%{StatusSpace()}
set statusline+=%#PmenuSel#
set statusline+=%{LinterStatus()}
set statusline+=%{StatusSpace()}
set statusline+=%{StatusSeperator()}
set statusline+=%{StatuslineGit()}
set statusline+=%#Constant#

" right
set statusline+=%=        " Switch to the right side
set statusline+=\ %y
set statusline+=%{StatusSeperator()}
set statusline+=\ %f

" ------------------------------------------------------------ ALE

let g:ale_sign_error = '✖' " Less aggressive than the default '>>'
let g:ale_sign_warning = '»'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 0
let g:ale_echo_msg_error_str = '💀'
let g:ale_echo_msg_warning_str = '📣'
let g:ale_echo_msg_format = '[%severity%]|[%linter%] %s [%severity%]'
" Show 2 lines of errors (default: 10)
let g:ale_list_window_size = 2
let g:ale_fixers = {
\   'javascript': ['eslint', 'importjs', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1
highlight ALEWarning ctermbg=DarkMagenta
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
