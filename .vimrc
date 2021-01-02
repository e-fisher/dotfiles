" .vimrc
set encoding=utf-8

" No compatibility
set nocompatible

" vim-plug (https://github.com/junegunn/vim-plug) settings
" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()

Plug 'rking/ag.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-rails'
" Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-surround'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'kana/vim-textobj-user'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'mhinz/vim-startify'
Plug 'nanotech/jellybeans.vim'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
" Plug 'captbaritone/better-indent-support-for-php-with-html'
Plug 'mattn/emmet-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ludovicchabant/vim-gutentags'
Plug 'Lokaltog/vim-easymotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'justinmk/vim-gtfo'
" Plug 'altercation/vim-colors-solarized'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'mbbill/undotree'
Plug 'karlbright/qfdo.vim'
Plug 'godlygeek/tabular'
Plug 'alvan/vim-closetag'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'drewtempelmeyer/palenight.vim'

call plug#end()
filetype plugin indent on

" Remap leader to space
let mapleader = "\<Space>"

" 256 colours, please
set t_Co=256

" Color scheme
set background=dark
colorscheme onedark

" let g:airline_theme='jellybeans'
let g:airline#extensions#tmuxline#enabled = 0

syntax on                         " show syntax highlighting
filetype plugin indent on

" add truecolor support, if available
if has('termguicolors')
  set termguicolors
endif

set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set shiftwidth=2
set expandtab                     " use spaces, not tab characters
set nocompatible                  " don't need to be compatible with old vim
set relativenumber
set number
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set cursorline                    " highlight current line
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set ttimeoutlen=100               " decrease timeout for faster insert with 'O'
set ruler                         " show row and column in footer
set scrolloff=4                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
set nofoldenable                  " disable code folding
set clipboard=unnamedplus         " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
set lazyredraw                    " improve scroll performance
set noswapfile                    " no swp files
set nowritebackup                 " fix multiple triggers in guard
set updatetime=750                " faster update for gitgutter
set history=1000                  " remember more commands and search history
set undolevels=1000               " use many muchos levels of undo
set hidden                        " coc
set synmaxcol=0

runtime macros/matchit.vim        " use % to jump between start/end of methods


" put git status, column/row number, total lines, and percentage in status
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]


" hint to keep lines short
autocmd FileType ruby setlocal colorcolumn=80
autocmd FileType eruby setlocal colorcolumn=80
autocmd FileType haml setlocal colorcolumn=80
autocmd FileType slim setlocal colorcolumn=80
autocmd FileType javascript setlocal colorcolumn=80
autocmd FileType typescript setlocal colorcolumn=80
autocmd FileType typescript.jsx setlocal colorcolumn=80

" toggle spell check with <F5>
map <F5> :setlocal spell! spelllang=en_us<cr>
imap <F5> <ESC>:setlocal spell! spelllang=en_us<cr>

" Visual decorations
" Show what mode you’re currently in
set showmode
" Show what commands you’re typing
set showcmd
" Allow modelines
set modeline
" Disable file title in terminal tab
set notitle


" jump to last position in file
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif



" rename current file, via Gary Bernhardt
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>


" tests
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if match(a:filename, '\.feature$') != -1
    exec ":!bundle exec cucumber " . a:filename
  elseif match(a:filename, '_test\.rb$') != -1
    if filereadable("bin/testrb")
      exec ":!bin/testrb " . a:filename
    else
      exec ":!ruby -Itest " . a:filename
    end
  else
    if filereadable("Gemfile")
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

" run test runner
" map <leader>t :call RunTestFile()<cr>
" map <leader>T :call RunNearestTest()<cr>

" ctrlp config
let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
nmap <leader>t :CtrlPTag<cr>

" highlight the status bar when in insert mode
if version >= 700
  au InsertEnter * hi StatusLine ctermfg=2 ctermbg=233
  au InsertLeave * hi StatusLine ctermbg=233 ctermfg=DarkGray
endif

" clear search highlight with enter
nnoremap <CR> :noh<CR><CR>

" quick save
inoremap <F3> <c-o>:w<cr>

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" remove trailling spaces
map <Leader>rt :%s/\s\+$//<cr>

" remove trailling spaces on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" space after comment sign
let NERDSpaceDelims = 1

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>rv :so $MYVIMRC<CR>

" git
map <leader>gb :Gblame -w<cr>
map <leader>gd :Gdiff<cr>
" map <leader>gr :GitGutterRevertHunk<cr>
nmap <Leader>gr <Plug>GitGutterUndoHunk

map <leader>gp :GitGutterPreviewHunk<cr>
map <leader>gw :Gwrite<cr>
map <leader>gc :Gcommit -a<cr>
map <leader>gs :Gstatus<cr>
map <leader>ga :Git add -A<cr>
" vertical split for gdiff
set diffopt+=vertical


" detect changes outside vim
set autoread
au CursorHold * checktime

" tag find
nnoremap <leader>. :CtrlPTag<cr>

" git gutter
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 1000
" let g:gitgutter_diff_args = '-w'
" same color for sign column as line number
highlight clear SignColumn


" <CTRL-s> to save
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <Esc>:update<CR>

let g:ag_prg="ag --vimgrep --ignore tags"

" 4 space indentation for html and php
autocmd FileType html setlocal shiftwidth=4 tabstop=4
autocmd FileType php setlocal shiftwidth=4 tabstop=4
autocmd FileType slim setlocal shiftwidth=2 tabstop=2

" use an undo file to preserve history and
" set a directory to store the undo history
set undofile undodir=~/.vim/undo/

let g:airline_powerline_fonts = 1

" No split for startify when opening nerdtree or ctrlp
autocmd User Startified setlocal buftype=

let g:startify_change_to_vcs_root = 1
let g:startify_custom_header = [
    \ '                                 ________  __ __',
    \ '            __                  /\_____  \/\ \\ \',
    \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \',
    \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_',
    \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
    \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/',
    \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/',
    \ '',
    \ '',
    \ ]

let g:startify_list_order = [['   Recent project files'], 'dir', ['   Recent files'], 'files']
let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ $VIMRUNTIME .'/doc',
    \ 'bundle/.*/doc',
    \ '.vimgolf',
    \ '.git',
    \ 'tags',
    \ ]

" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionType = "<c-n>"
" Disable completion preview in a separate window
" set completeopt-=preview

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Quickly navigate between buffers
nnoremap gb :ls<CR>:b<Space>
nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>
nnoremap <C-q> <C-^>

" Easymotion search
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

" Easymotion nav
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
" nmap s <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)
let g:EasyMotion_smartcase = 1

let g:gutentags_ctags_exclude = ['node_modules']
let g:gutentags_cache_dir = "~/.vim/tags/"

command! W w !sudo tee % > /dev/null

" use blowfish2 for encryption
" set cm=blowfish

" mkdir when does not exist on save
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" underscore word boundary
" set iskeyword-=_

" ignore tmp for ctrlp
set wildignore+=*/tmp/*

let g:solarized_termcolors=256

" Switch to light theme
function! SetLightTheme()
  set background=light
  colorscheme solarized
endfunction

" Disable auto comment on new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Changes notes locaiton
let g:notes_directories = ['~/Dropbox/documents/vim_notes/']

" Search
nnoremap <C-f> :Ag!<Space>
" Search Ruby
nnoremap <leader><leader>r :Ag! <Space>-G="*.rb" <S-Left><Left>
" Search JavaScripts
nnoremap <leader><leader>j :Ag! <Space>-G="*.(js\|coffee)" --ignore-dir=public<S-Left><S-Left><Left>
" Search Stylesheets
nnoremap <leader><leader>s :Ag! <Space>-G="*.(css\|scss)" --ignore-dir=public<S-Left><S-Left><Left>
" Search View Files
nnoremap <leader><leader>v :Ag! <Space>-G="*.(html.erb\|html.slim\|slim)" <S-Left><Left>

" Disable ag mapping message
let g:ag_mapping_message=0

" Set Y to behave same as D and C
nnoremap Y y$

" Convert ruby hash to new syntax
nnoremap <leader>ch :%s/:\([^ ]*\)\(\s*\)=>/\1:/g <CR>

" Required by gitgutter in fish shell
set shell=/bin/bash

" Search and replace word under cursor
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Search and replace visual selection
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -U -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Open new split panes to right and bottom, feels more natural than default
set splitbelow
set splitright

" Complete emmet abbreviations with tab in css and scss files
autocmd FileType css,scss imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Substitute selection without copying to current register
vmap r "_dP

" Enable rspec syntax highlight in non-rails projects
autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like
  \ before after setup subject its shared_examples_for shared_context let
highlight def link rubyRspec Function

" Enable jsx highlight in js files
let g:jsx_ext_required = 0

" Disable Background Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
if &term =~ '256color'
  set t_ut=
endif

let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.php,*.tsx,*.jsx"

" Don't jump to closing bracket/paran on next line
let g:AutoPairsMultilineClose = 0

" Paste without copying
xnoremap p "_dP

" Disable coc for notes
autocmd FileType notes let b:coc_suggest_disable = 1


" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
vmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  <Plug>(coc-format-selected)


" Coc error color
hi CocErrorSign guifg=#ff5447
