" ----------------------------------------------------------------------------
"   .vimrc
" ----------------------------------------------------------------------------
" TODO: See what happens when the swap/undo/backup files are not in place

" This must happen before Vundle
set nocompatible

" ----------------------------------------------------------------------------
"   Vundle
" ----------------------------------------------------------------------------

filetype off                              " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle (required)
Bundle 'gmarik/vundle'                    

                                          " Molokai colorscheme
Bundle 'tomasr/molokai'                   
                                          " My personal Todo list syntax
Bundle 'captbaritone/myTodo'              
                                          " Gundo: Undo history
Bundle 'sjl/gundo.vim'                    
                                          " Webapi: Dependancy of Gist-vim
Bundle 'mattn/webapi-vim'                 
                                          " Gist: Post text to gist.github
Bundle 'mattn/gist-vim'                   
                                          " MiniBufExpl: Show open buffers
Bundle 'fholgado/minibufexpl.vim'         
                                          " Syntastic: Highlight code errors
Bundle 'scrooloose/syntastic'             
                                          " Ultisnips: Snippet manager
Bundle 'SirVer/ultisnips'                 
                                          " Solarized: Colorscheme
Bundle 'altercation/vim-colors-solarized' 
                                          " Powerline: Pretty statusline
Bundle 'Lokaltog/vim-powerline'           

filetype plugin indent on                 " required!

" Not sure if this will be needed on jailed servers
" set shell=/bin/bash                     " Allows pathogen to work on jailed servers

" ----------------------------------------------------------------------------
"   Base Options
" ----------------------------------------------------------------------------

" Set the leader key to , instead of \ because it's easier to reach
let mapleader = ","
"set notimeout                  " Turn off the timeout for the leader key
                                " Seems to break `n` in normal mode, so
                                " I turned it off
set encoding=utf-8              " I generally want utf-8 encoding
set hidden                      " Allow buffers to exist in the background
set ttyfast                     " Indicates a fast terminal connection
set backspace=indent,eol,start  " Allow backspaceing over autoindent, line breaks, starts of insert
set shortmess+=I                " No welcome screen

" ----------------------------------------------------------------------------
"   Visual
" ----------------------------------------------------------------------------

" Control Area (May be superseeded by PowerLine)
set showcmd                 " Show (partial) command in the last line of the screen.
set wildmenu                " Command completion
set wildmode=list:longest   " List all matches and complete till longest common string
set laststatus=2            " The last window will have a status line always
set showmode                " Show the mode in the last line of the screen
set ruler                   " Show the line and column number of the cursor position, separated by a comma.

" Buffer Area Visuals
set scrolloff=7             " Minimal number of screen lines to keep above and below the cursor.
set visualbell              " Use a visual bell
set cursorline              " Highlight the current line
set number                  " Show line numbers
set wrap                    " Soft wrap at the window width
set linebreak               " Break the line on words
set textwidth=79            " Break lines at just under 80 characters
if exists('+colorcolumn')
  set colorcolumn=+1        " Highlight the column after `textwidth` 
endif

" Highlight tabs and trailing spaces
"set listchars=tab:>-,trail:-
"set list

" Trim trailing white space on save (preserving cursor postion
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python,css autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" letter meaning when present in 'formatoptions'
" ------ ---------------------------------------
" c Auto-wrap comments using textwidth, inserting
" the current comment leader automatically.
" q Allow formatting of comments with "gq".
" r Automatically insert the current comment leader
" after hitting <Enter> in Insert mode. 
" t Auto-wrap text using textwidth (does not apply
" to comments)
set formatoptions=cqrn1

syntax enable               " This has to come after colorcolumn in order to draw it.
set t_Co=256                " enable 256 colors

" Colorscheme (Don't complain if you don't have it yet)
silent! colorscheme molokai

" ----------------------------------------------------------------------------
"   GUI Specific 
" ----------------------------------------------------------------------------

if has("gui_running")
    " Hide Scrollbars
	set guioptions-=T       " Remove tool bar
	set guioptions-=r       " Remove right-hand scroll bar
    set guioptions-=m       " Remove menu bar
    set guioptions-=L       " Remove left-hand scroll bar 
    set background=dark
    " Turn on spellcheck only for GUI because colors don't work so well in
    " command line
    setlocal spell spelllang=en_us

endif

" ----------------------------------------------------------------------------
"   Search
" ----------------------------------------------------------------------------

set gdefault                " Greedy search by default
set incsearch               " Show search results as we type
set showmatch               " Show matching brackets
set hlsearch                " Highlight search results
                            " Use regex for searches
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
set ignorecase              " Ignore case when searching
                            " Clear search highlights
nnoremap <leader><space> :nohlsearch<cr>

" ----------------------------------------------------------------------------
"   Tabs
" ----------------------------------------------------------------------------

set tabstop=2               " Show a tab as two spaces
set shiftwidth=2            " Reindent is also two spaces
set softtabstop=2           " When hit <tab> use two columns
set expandtab               " Create spaces when I type <tab>
set autoindent              " Copy indent from current line when starting new line
set smartindent             " Smart indent on new line, works for C-like langs.
set shiftround              " Round indent to multiple of 'shiftwidth'.

" ----------------------------------------------------------------------------
"   Custom commands
" ----------------------------------------------------------------------------

" automatically reload vimrc when it's saved
au BufWritePost *vimrc so $MYVIMRC

" ----------------------------------------------------------------------------
"   Plugins
" ----------------------------------------------------------------------------

" Custom command to refresh Chrome on save
command! W exec "w" | silent !osascript ~/.vim/scripts/refresh_chrome.scptd

" Set Ultisnip directory
let g:UltiSnipsSnippetDirectories=["snippets"]
" Cycle through ultisnip triggers with <tab>
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Gist Vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" ----------------------------------------------------------------------------
"   Custom filetypes
" ----------------------------------------------------------------------------

autocmd BufNewFile,BufRead *.md,*.markdown  set filetype=markdown

" ----------------------------------------------------------------------------
"   Custom mappings
" ----------------------------------------------------------------------------

" Make standard GUI cut/copy/paste hotkeys work as expected
" TODO: This should only run in gvim
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa
" Note: the next command destroys the visual mode <C-v> hotkey
nnoremap <C-v> "+pa

" gundo plugin. Requires vim being compiled with Python support
nnoremap <F5> :GundoToggle<CR>

" Disable arrow keys to keep from falling back on bad habits 
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Navigate using displayed lines not actual lines
nnoremap j gj
nnoremap k gk

" Reselect visual block after indent/outdent: http://vimbits.com/bits/20
vnoremap < <gv
vnoremap > >gv

" ----------------------------------------------------------------------------
"   Undo, Backup and Swap file locations
" ----------------------------------------------------------------------------

set directory=$HOME/.vim/swapdir//
set backupdir=$HOME/.vim/backupdir//
if exists('+undodir') 
    set undodir=$HOME/.vim/undodir
    set undofile
endif

" ----------------------------------------------------------------------------
"   If there is a local .vimrc, source it here at the end
" ----------------------------------------------------------------------------

if filereadable(glob("$HOME/.vimrc.local")) 
    source $HOME/.vimrc.local
endif
