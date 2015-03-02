" .vimrc
set encoding=utf-8

" No compatibility
set nocompatible

" load up pathogen and all bundles
call pathogen#infect()
call pathogen#helptags()

" 256 colours, please
set t_Co=256

" Color scheme
set background=dark
colorscheme jellybeans
let g:airline_theme='tomorrow'

syntax on                         " show syntax highlighting
filetype plugin indent on

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
set updatetime=750                " faster update for gitgutter
set history=1000                  " remember more commands and search history
set undolevels=1000               " use many muchos levels of undo

runtime macros/matchit.vim        " use % to jump between start/end of methods


" put git status, column/row number, total lines, and percentage in status
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]


" hint to keep lines short
autocmd FileType ruby setlocal colorcolumn=80
autocmd FileType eruby setlocal colorcolumn=80
autocmd FileType haml setlocal colorcolumn=80

" highlight trailing spaces in annoying red
" highlight ExtraWhitespace ctermbg=1 guibg=red
" match ExtraWhitespace /\s\+$/
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()

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
" Show file title in terminal tab
set title



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
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

" ctrlp config
let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0

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
map <leader>gr :GitGutterRevertHunk<cr>
map <leader>gp :GitGutterPreviewHunk<cr>
map <leader>gw :Gwrite<cr>
map <leader>gc :Gcommit -a<cr>
map <leader>gs :Gstatus<cr>

" detect changes outside vim
set autoread
au CursorHold * checktime

" tag find
nnoremap <leader>. :CtrlPTag<cr>

" git gutter
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

" remap ; to :
" nnoremap ; :

" use an undo file to preserve history
set undofile
" set a directory to store the undo history
set undodir=~/.vimundo/

let g:airline_powerline_fonts = 1

let g:ctrlp_reuse_window  = 'startify'

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
set completeopt-=preview

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Quickly navigate between buffers
nnoremap gb :ls<CR>:b<Space>
nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>
nnoremap <C-q> <C-^>
