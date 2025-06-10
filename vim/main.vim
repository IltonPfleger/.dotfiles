"----------------------------------------------------------
" Fundamental Configuration
"----------------------------------------------------------
syntax enable
filetype indent on
filetype plugin on
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
set laststatus=2
set nowrap
set guiheadroom=0

hi CursorLineNr gui=bold cterm=bold term=bold guibg=#303030
hi Normal guibg=NONE ctermbg=NONE

"----------------------------------------------------------
" Editing Behavior
"----------------------------------------------------------
set nospell
set hidden
set autoindent
set smartindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

"----------------------------------------------------------
" Search
"----------------------------------------------------------
set hlsearch
nnoremap <silent> <Esc> :noh<CR>

"----------------------------------------------------------
" File Management
"----------------------------------------------------------
set nobackup
set noswapfile
set wildmenu
set wildcharm=<Tab>

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
vnoremap <leader>y :w !wl-copy<CR><CR>
nnoremap <leader>p :r !wl-paste<CR>

"----------------------------------------------------------
" Replace command
"----------------------------------------------------------
nnoremap <silent> r :exec '%s/' . input('Pattern: ') . '/' . input('Replace: ') . '/g'<CR>

"----------------------------------------------------------
" Autocomplete suggestions in tab
"----------------------------------------------------------
inoremap <expr> <Tab> getline('.')[col('.')-2] !~ '^\s\?$' \|\| pumvisible() ? '<C-N>' : '<Tab>'

"----------------------------------------------------------
" Back to line when exit
"----------------------------------------------------------
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

"----------------------------------------------------------
" Language-Specific Configuration
"----------------------------------------------------------
augroup language_support
  autocmd!
  " C/C++
  " Function For Call Clang-Format
  function! ClangFormat() range
	  let l:binary = '/home/pj/.dotfiles/bin/clang-format'
	  let l:style = ' --style="{BasedOnStyle: Google, IndentWidth: 4, UseTab: Never, AlignConsecutiveAssignments: true}"'
	  let l:lines = getline(1, '$')
	  let l:lines = map(l:lines, {_, v -> substitute(v, '^\s*\([a-zA-Z ]*:\)', '\= "//__XXX__" . submatch(1)', '')})
	  let l:text = join(l:lines, "\n")
	  let l:current_line = getpos('.')

	  let l:command = l:binary . l:style . ' -assume-filename=' . expand('%:p')
	  let l:formatted_text = system(l:command, l:text)

	  let l:formatted_lines = split(l:formatted_text, "\n")
	  let l:formatted_lines = map(l:formatted_lines, {_, v -> substitute(v, '//__XXX__', '', '')})

	  if v:shell_error != 0
		  echoerr "ERROR: ClangFormat Failed!"
		  return
	  endif

	  silent! execute '1,' . line('$') . 'delete _'
	  call setline(1, l:formatted_lines)
	  call setpos('.', l:current_line)
  endfunction
  autocmd FileType c,cpp,h,objc,objective-c nnoremap <buffer> <leader>= :call ClangFormat()<CR>zz
augroup END

"----------------------------------------------------------
" Compilation and Execution
"----------------------------------------------------------
augroup compilation
  autocmd!
  " C, C++
  autocmd FileType c nnoremap <leader>r :w \| :!gcc -Iinclude -Wall -Wextra -g % -o %:r && ./%:r<CR>
  autocmd FileType cpp nnoremap <leader>r :w \| :!g++ -Iinclude -Wall -Wextra % -o %:r && ./%:r<CR>
  autocmd FileType c,cpp nnoremap <leader>m :w \|:!make<CR>

  " Python
  autocmd FileType python nnoremap <buffer> <F1> :w \| !python3 %<CR>
  
  " JavaScript
  autocmd FileType javascript nnoremap <buffer> <F1> :w \| !node %<CR>
augroup END
