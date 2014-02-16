" based on https://bitbucket.org/sjl/dotfiles/src/10f4bf76eddda27da7e273fc26a31a96aef97b9d/vim/vimrc






" Preamble ---------------------------------------------------------------- {{{

filetype off
call pathogen#infect()
filetype plugin indent on
set nocompatible

" }}}

" Basic options ----------------------------------------------------------- {{{

set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set ruler
set backspace=indent,eol,start
set number
" set relativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set autowrite
set autoread
set shiftround
set title
set cursorline
"set linebreak
"set dictionary=/usr/share/dict/words
"set spellfile=~/.vim/custom-dictionary.utf-8.add
"set colorcolumn=+1

" iTerm2 is currently slow as ball at rendering the nice unicode lines, so for
" now I'll just use ascii pipes.  They're ugly but at least I won't want to kill
" myself when trying to move around a file.
set fillchars=diff:⣿,vert:│
"set fillchars=diff:⣿,vert:\|

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
"set notimeout
"set ttimeout
"set ttimeoutlen=10

" Make Vim able to edit crontab files again.
" set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
"set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" Turn off previews once a completion is accepted
"autocmd CursorMovedI *  if pumvisible() == 0|silent! pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Resize splits when the window is resized
au VimResized * :wincmd =

" Leader
"let mapleader = ","
"let maplocalleader = "\\"

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" }}}

" cpoptions+=J {{{
" A |sentence| has to be followed by two spaces after the '.', '!' or '?'.  A <Tab> is not recognized as white space.
augroup twospace
    au!
    au BufRead * :set cpoptions+=J
augroup END

" }}}

" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:⋅
    au InsertLeave * :set listchars+=trail:⋅
augroup END
" }}}

" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX files

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files
" }}}

" Line Return {{{
" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"' |
        \ endif
augroup END
" }}}
       
" Tabs, spaces, wrapping {{{
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=80
"set formatoptions=qrn1
"set colorcolumn=+1

" }}}
" Backups {{{

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}
" Color scheme {{{

syntax on
set background=dark
let g:trafficlights_tabline = 2
let g:trafficlights_darkgutter = 0 
let g:trafficlights_html_link_underline = 0
colorscheme trafficlights

" Reload the colorscheme whenever we write the file.
augroup color_trafficlights_dev
    au!
    au BufWritePost trafficlights.vim color trafficlights
augroup END

function! GetCWD()
  return expand(":pwd")
endfunction

set statusline=\ \ %4*%F%3*\ \ 
set statusline+=%4*%m%3*
set statusline+=%4*%h%3*
set statusline+=%4*%r%3*
set statusline+=%4*%w%3*
set statusline+=%4*%q%3*
set statusline+=%3*%4*%{&bomb?'[bomb]':''}%3*
set statusline+=%4*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%3*
"set statusline+=%4*%{fugitive#statusline()}%3*
set statusline+=\ \ %3*fenc:%4*%{(&fenc!='')?&fenc:'none'}%3*\ \ 
set statusline+=%3*ff:%4*%{&ff}%3*\ \ 
set statusline+=%3*ft:%4*%{(&ft!='')?&ft:'<none>'}\ \ 
" set statusline+=%3*ft:%4*%{(&ft!='')?((&ft!='vim')?&ft:''):'<none>'}\ \ 
" set statusline+=%5*%{v:register}%3*\ \ 
" set statusline+=%3*tab:%4*%{&ts}
" set statusline+=%3*,%4*%{&sts}
" set statusline+=%3*,%4*%{&sw}
" set statusline+=%3*,%4*%{&et?'et':'noet'}\ \ 
set statusline+=%0*%=
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%5*%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}%3*\ \ 
set statusline+=%4*%{&paste?'[paste]':''}%3*
set statusline+=\ \ %3*mode:%1*%{Mode()}%3*\ \ 
"set statusline+=%5*%{ScrollBar(20)}%3*\ \ 
set statusline+=%5*%{exists('g:scrollbar_loaded')?ScrollBar(20):''}%3*\ \ 
"set statusline+=%3*pos:%4*%3P%3*\ \ 
set statusline+=%3*col:%4*%3c\ \ 
set statusline+=%3*line:%4*%3l/%3L\ \ 

function! Mode()
    redraw
    let l:mode = mode()

    if mode ==# "n" | exec 'hi User1 ' . 'ctermfg=255 ctermbg=236' | return "NORMAL"
    elseif mode ==# "i" | exec 'hi User1 ' . 'ctermfg=243 ctermbg=236' | return "INSERT"
    elseif mode ==# "R" | exec 'hi User1 ' . 'ctermfg=134 ctermbg=236' | return "REPLACE"
    elseif mode ==# "v" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return "VISUAL"
    elseif mode ==# "V" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return "V-LINE"
    elseif mode ==# "" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return "V-BLOCK"
    else | return l:mode
    endif
endfunc 

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}


" Abbreviations ----------------------------------------------------------- {{{
iabbrev gcavn@ gcavn@gcavn.com

" }}}




" Convenience mappings ---------------------------------------------------- {{{

" Kill window
nnoremap <leader>q :q<cr>

" Write buffer to file
nnoremap <leader>w :w<cr>

" Sort lines
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" Tabs
" nnoremap <leader>( :tabprev<cr>
" nnoremap <leader>) :tabnext<cr>

" Rebuild Ctags (mnemonic RC -> CR -> <cr>)
" nnoremap <leader><cr> :silent !myctags<cr>:redraw!<cr>

" Clean trailing whitespace
" nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

nnoremap <F8> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Easier linewise reselection of what you just pasted.
nnoremap <leader>V V`]

" Indent/dedent/autoindent what you just pasted.
nnoremap <lt>> V`]<
nnoremap ><lt> V`]>
nnoremap =- V`]=


" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
noremap ^ H
noremap $ L
"
" }}}

" Directional Keys {{{
"
" " It's 2013.
noremap j gj
noremap k gk
noremap gj j
noremap gk k
"
" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
"
" }}}



" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>ev :e ~/.vimrc<cr>
"nnoremap <leader>eV :vsplit scp://vagrant//<cr>
"nnoremap <leader>ed :vsplit ~/.vim/custom-dictionary.utf-8.add<cr>
nnoremap <leader>en :e ~/notes/<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>
nnoremap <leader>eh :e ~/.<cr>
nnoremap <leader>ef :e %:p:h<cr>
nnoremap <leader>e. :e .<cr>


" }}}
" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

" }}}





" Folding ----------------------------------------------------------------- {{{

set foldlevelstart=99

" }}}




" Filetype-specific ------------------------------------------------------- {{{

" C {{{

augroup ft_bash
    au!
    au BufNewFile,BufRead *.sh setlocal filetype=zsh
    au FileType sh let b:is_bash=1
augroup END

" }}}
"
" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}

" CSS and LessCSS {{{

augroup ft_css
    au!

    au BufNewFile,BufRead *.less setlocal filetype=less

    au Filetype less,css setlocal foldmethod=marker
    au Filetype less,css setlocal foldmarker={,}
    au Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
    au Filetype less,css setlocal iskeyword+=-

    " Use <leader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "
    "         ...
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "
    "         ...
    "     }
    au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
"    au BufNewFile,BufRead *.less,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END

" }}}

" Java {{{

augroup ft_java
    au!

    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,}
augroup END

" }}}

" Javascript {{{
augroup ft_javascript
    au!

    au FileType javascript setlocal foldmethod=marker
    au FileType javascript setlocal foldmarker={,}
"
"    " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
"    " positioned inside of them AND the following code doesn't get unfolded.
"    au Filetype javascript inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END
" }}}


" Markdown {{{
augroup ft_markdown
    au!

    au BufNewFile,BufRead {*.md,*.mkd,*.markdown} setlocal filetype=markdown foldlevel=1

augroup END
" }}}

" Postgresql {{{
augroup ft_postgres
    au!

    au BufNewFile,BufRead *.sql set filetype=pgsql
    au FileType pgsql set foldmethod=indent
    au FileType pgsql set softtabstop=2 shiftwidth=2
    au FileType pgsql setlocal commentstring=--\ %s comments=:--
augroup END
" }}}

" QuickFix {{{
augroup ft_quickfix
    au!
    au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap tw=0
augroup END
" }}}

" Vim {{{
augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END
" }}}

" Python {{{

augroup ft_python
    au!

    au FileType python set omnifunc=pythoncomplete#Complete
augroup END

" }}}

" YAML {{{
augroup ft_yaml
    au!

    au FileType yaml set shiftwidth=2
augroup END
" }}}

" XML {{{
augroup ft_xml
    au!

    au FileType xml setlocal foldmethod=manual
augroup END
" }}}

" }}}




" Plugin settings --------------------------------------------------------- {{{

" Ctrl-P {{{
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_match_window = 'order:ttb,max:20'
" let g:ctrlp_extensions = ['tag']

" let ctrlp_filter_greps = "".
"     \ "egrep -iv '\\.(" .
"     \ "jar|class|swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
"     \ ")$' | " .
"     \ "egrep -v '^(\\./)?(" .
"     \ "deploy/|lib/|classes/|libs/|deploy/vendor/|.git/|.hg/|.svn/|.*migrations/|docs/build/" .
"     \ ")'"

" let my_ctrlp_user_command = "" .
"     \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
"     \ ctrlp_filter_greps

" let my_ctrlp_git_command = "" .
"     \ "cd %s && git ls-files --exclude-standard -co | " .
"     \ ctrlp_filter_greps

" let my_ctrlp_ffind_command = "ffind --semi-restricted --dir %s --type e -B -f"

" let g:ctrlp_user_command = ['.git/', my_ctrlp_ffind_command, my_ctrlp_ffind_command]
" " }}}


" Fugitive {{{
let g:fugitive_github_domains = ['github.banksimple.com']

nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>

augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
augroup END

" "Hub"
vnoremap <leader>H :Gbrowse<cr>
" }}}

" Linediff {{{
vnoremap <leader>l :Linediff<cr>
nnoremap <leader>L :LinediffReset<cr>
" }}}

" Syntastic {{{

"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0

"let g:syntastic_java_checker = 'javac'
"let g:syntastic_mode_map = {

"            \ "active_filetypes": [],
"            \ "passive_filetypes": ['java', 'html', 'rst']
"            \ }
"let g:syntastic_stl_format = '[%E{%e Errors}%B{, }%W{%w Warnings}]'
"let g:syntastic_jsl_conf = '$HOME/.vim/jsl.conf'
"let g:syntastic_scala_checkers = ['fsc']
"
nnoremap <leader>C :SyntasticCheck<cr>
" }}}

" vim-unimpaired {{{

" nnoremap <silent> <Plug>unimpairedTabLeft   :tabNext<CR>
" nnoremap <silent> <Plug>unimpairedTabRight  :tabnext<CR>
" xnoremap <silent> <Plug>unimpairedTabLeft   :tabNext<CR>
" xnoremap <silent> <Plug>unimpairedTabRight  :tabnext<CR>

" nmap [g <Plug>unimpairedTabLeft
" nmap ]g <Plug>unimpairedTabRight
" xmap [g <Plug>unimpairedTabLeft
" xmap ]g <Plug>unimpairedTabRight

" nnoremap <silent> <Plug>unimpairedTabFirst   :tabfirst<CR>
" nnoremap <silent> <Plug>unimpairedTabLast    :tablast<CR>
" xnoremap <silent> <Plug>unimpairedTabFirst   :tabfirst<CR>
" xnoremap <silent> <Plug>unimpairedTabLast    :tablast<CR>

" nmap [G <Plug>unimpairedTabFirst
" nmap ]G <Plug>unimpairedTabLast
" xmap [G <Plug>unimpairedTabFirst
" xmap ]G <plug>unimpairedTabLast

" }}}
" undotree ---------------------------------------------------------------- {{{
nnoremap <F5> :UndotreeToggle<cr>

" }}}



" }}}




" Text objects ------------------------------------------------------------ {{{

" }}}




" Mini-plugins ------------------------------------------------------------ {{{
command DiffOrig let g:diffline = line('.') | vert new | set bt=nofile | r # | 0d_ | diffthis | :exe "norm! ".g:diffline."G" | wincmd p | diffthis | wincmd p
nnoremap <Leader>do :DiffOrig<cr>
nnoremap <leader>dc :q<cr>:diffoff<cr>:exe "norm! ".g:diffline."G"<cr>
" }}}

" Synstack {{{

" Show the stack of syntax hilighting classes affecting whatever is under the
" cursor.
function! SynStack()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc

nnoremap <F7> :call SynStack()<CR>

" }}}



" Environments (GUI/Console) ---------------------------------------------- {{{

if has('gui_running')
    if has("gui_macvim")

    else

    end
else
    set mouse=a
        if &term =~ '^screen'
            " tmux knows the extended mouse mode
            set ttymouse=xterm2
        endif
    set clipboard=unnamed,unnamedplus
endif

" }}}
