"----------------------------------------------------------
" Fundamental Configuration
"----------------------------------------------------------
syntax enable
filetype indent on
set encoding=utf-8
set shell=$SHELL

"----------------------------------------------------------
" Visual Configuration
"----------------------------------------------------------
colorscheme retrobox
set termguicolors
set background=dark
set number
set relativenumber
set cursorline
set title
set showmatch
set laststatus=2
set nowrap

hi CursorLineNr gui=bold cterm=bold term=bold guibg=#303030

"----------------------------------------------------------
" Editing Behavior
"----------------------------------------------------------
set hidden
set autoindent
set smartindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround

"----------------------------------------------------------
" File Management
"----------------------------------------------------------
set nobackup
set noswapfile
set wildmenu
set wildcharm=<Tab>

"----------------------------------------------------------
" Window Management
"----------------------------------------------------------
set splitbelow
set termwinsize=10x0

"----------------------------------------------------------
" Status Line Configuration
"----------------------------------------------------------
set statusline=
set statusline+=%#Error#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#Search#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffChange#%{(mode()=='R')?'\ \ REPLACE\ ':''}
set statusline+=%#DiffText#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#DiffAdd#%{(mode()=='c')?'\ \ COMMAND\ ':''}
set statusline+=%m%*
set statusline+=%#DiffAdd#\ %<%F%*
set statusline+=%#Directory#
set statusline+=\%=
set statusline+=%#Directory#
set statusline+=%#DiffAdd#\ %Y\ %*
set statusline+=\ %c\ %l/%L\ %P\ 

"----------------------------------------------------------
" Key Mappings
"----------------------------------------------------------
nnoremap <silent> q :q<CR>
nnoremap <silent> w :w<CR>
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap vv <C-v><CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
vnoremap Y "+y

" Improved safe replace command
"nnoremap <silent> r :let @/=input('Pattern: ')<CR>:%s//\=input('Replace: ')/g<CR>
nnoremap <silent> r :exec '%s/' . input('Pattern: ') . '/' . input('Replace: ') . '/g'<CR>

" Autocomplete suggestions in tab
inoremap <expr> <Tab> getline('.')[col('.')-2] !~ '^\s\?$' \|\| pumvisible() ? '<C-N>' : '<Tab>'

"----------------------------------------------------------
" Language-Specific Configuration
"----------------------------------------------------------
augroup language_support
  autocmd!
  " C/C++
  " Function For Call Clang-Format
  function! ClangFormat() range
	  let l:binary = 'clang-format'
	  let l:style = ' --style="{BasedOnStyle: Google, IndentWidth: 4, AlignConsecutiveAssignments: true, ColumnLimit: 150, BreakBeforeBraces: Linux}"'
	  let l:start_line = line("'<")
	  let l:end_line = line("'>")
	  let l:lines = getline(1, '$')
	  let l:text = join(l:lines, "\n")
	  let l:current_line = getpos('.')

	  let l:command = l:binary . l:style . ' -assume-filename=' . expand('%:p')
	  let l:formatted_text = system(l:command, l:text)

	  let l:formatted_lines = split(l:formatted_text, "\n")
	  silent! execute '1,' . line('$') . 'd'
	  call setline(1, l:formatted_lines)
	  call setpos('.', l:current_line)
  endfunction

  autocmd BufWritePre *.c,*.cc,*.cpp,*.h,*.hpp call ClangFormat()
  
  " Python
  autocmd FileType python nnoremap <buffer> <F1> :w \| !python3 %<CR>
  
  " JavaScript
  autocmd FileType javascript nnoremap <buffer> <F1> :w \| !node %<CR>
  
  " Go
  autocmd FileType go setlocal noexpandtab
  autocmd FileType go setlocal tabstop=4
  autocmd FileType go setlocal shiftwidth=4
augroup END

"----------------------------------------------------------
" Compilation and Execution
"----------------------------------------------------------
augroup compilation
  autocmd!
  " C, C++
  autocmd FileType c nnoremap <F1> :w \| :!gcc -Iinclude -Wall -Wextra % -o %:r && ./%:r<CR>
  autocmd FileType cpp nnoremap <F1> :w \| :!g++ -Iinclude -Wall -Wextra % -o %:r && ./%:r<CR>
  autocmd FileType c,cpp nnoremap <F2> :w \|:!make<CR>
augroup END

"----------------------------------------------------------
" Maintenance and Cleanup
"----------------------------------------------------------
" Remove deprecated configuration
let c_no_curly_error=1

" Ensure clean exit on :q
autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif
