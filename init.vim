"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on



" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'mhinz/vim-startify'
" Plug 'glepnir/dashboard-nvim'
" Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'liuchengxu/vista.vim'
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
" Plug 'itchyny/lightline.vim'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'tpope/vim-fugitive'
Plug 'neomake/neomake'


if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/tagbar'


" List ends here. Plugins become visible to Vim after this call.
call plug#end()


au BufNewFile,BufRead *.py
    \ set expandtab         |
    \ set autoindent        |
    \ set tabstop=4         |
    \ set softtabstop=4     |
    \ set shiftwidth=4      |
    \ set foldmethod=manual |

nnoremap <space> za

let g:ale_linters = {
    \ 'python' : ['flake8', 'pylint']
    \}

let g:ale_fixers = {
    \ 'python': ['yapf']
    \ }

function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '✨ all good ✨' : printf(
        \   '😞 %dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endfunction

set statusline=
set statusline+=%m
set statusline+=\ %f
set statusline+=%=
set statusline+=\ %{LinterStatus()}

" let g:lightline = {
"     \ 'colorscheme': 'material',
"     \ 'active': {
"     \   'left': [ [ 'mode', 'paste' ],
"     \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
"     \ },
"     \ 'component_function': {
"     \   'gitbranch': 'FugitiveHead'
"     \ },
"     \ }


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

let g:material_theme_style = 'darker'
let g:material_terminal_italics = 1

nnoremap <F5> :NvimTreeToggle<CR>

set noshowmode

colorscheme material
let g:airline_powerline_fonts = 1
let g:airline_theme = 'material'


nmap <F8> :TagbarToggle<CR>
set splitbelow
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nmap <F4> :bo split \| :resize 10 \| :term<CR>

