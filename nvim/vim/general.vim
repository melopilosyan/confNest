set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set number relativenumber                    " Show line relative number
set expandtab smarttab                       " Use spaces instead of tabs / Be smart when using tabs ;)
set tabstop=2 shiftwidth=2 softtabstop=2     " Set default tab size to 2

set wrap                                     " Wrap lines
set breakindent                              " Indent wrapped lines
set linebreak                                " Don't cut words on wrap
set nohlsearch                               " Don't highlight search results
set wildmenu                                 " Turn on visual autocompletion for command menu
set incsearch                                " Select search match while typing
set viminfo^=%                               " Remember info about open buffers on close
set autoindent smartindent                   " Auto indent / Smart indent
set scrolloff=8                              " lines above/below cursor

filetype plugin indent on                    " Enable filetype detection
syntax on                                    " Enable syntax highlighting
set hidden

set showcmd                                  " show (partial) command in the last line of the screen this also shows visual selection info
set showmatch                                " Show braces matchs
set lazyredraw                               " Redraw only when we need to

set guicursor=a:block-blinkon1

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set updatetime=300

set signcolumn=yes
set colorcolumn=100
highlight ColorColumn ctermbg=0 guibg=Black

set cursorline
" highlight Cursorline cterm=bold ctermbg=Black

"" Fix backspace indent
set backspace=indent,eol,start

"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" let no_buffers_menu=1
set termguicolors
set background=dark
" colorscheme onedark
