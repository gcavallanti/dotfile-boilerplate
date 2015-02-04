" Preamble ---------------------------------------------------------------- {{{

filetype off
call pathogen#infect()
filetype plugin indent on
set nocompatible

" }}}

" Basic options ----------------------------------------------------------- {{{

" set encoding=utf-8
set modelines=0
set autoindent
set showmode
set hidden
set visualbell
set backspace=indent,eol,start
set number
" These slow things down too much
" set showcmd
set lazyredraw
" set relativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set listchars=tab:»\ ,eol:¬,extends:›,precedes:‹
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set autowrite
set autoread
set shiftround
" set nomagic
set whichwrap+=<,>,h,l,[,]
set title
set diffopt=filler,iwhite
set linebreak
set dictionary=/usr/share/dict/words
" set fillchars=diff:\·,vert:│
set fillchars=diff:\ 
" set cursorline

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

set timeout
" Set mapping delay to 1s so you can think what to type next
set timeoutlen=1000
" Set key code delay to 0.01s
set ttimeoutlen=10

" Set up ins-completions preferences
" set complete=.,w,b,u,t,kspell
set completeopt=longest,menuone,preview
" set omnifunc=syntaxcomplete#Complete

" Resize splits when the window is resized
au VimResized * :wincmd =

" set winheight=6
" set winminheight=6
" set winheight=9999

let mapleader=' '

set pastetoggle=<F11>
     
" set pumheight=10
" Preview {{{
" Turn off previews once a completion is accepted
" autocmd CursorMovedI *  if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
" set previewheight=6
" au BufEnter ?* call PreviewHeightWorkAround()
" func PreviewHeightWorkAround()
"     if &previewwindow
"         res &previewheight
"     endif
" endfunc
" }}}

" cpoptions+=J {{{
" A |sentence| has to be followed by two spaces after the '.', '!' or '?'.  A <Tab> is not recognized as white space.
" augroup twospace
"     au!
"     au BufRead * :set cpoptions+=J
" augroup END

" }}}

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:⋅
    au InsertLeave * :set listchars+=trail:⋅
augroup END
" }}}

" Wildmenu completion {{{
" set wildmenu
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
" Make sure Vim returns to the same line when you reopen a file or buffer
augroup line_return
    au!
    au BufReadPost,BufWinEnter *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"' |
        \ endif
augroup END
" }}}

" Tabs, spaces, wrapping {{{
set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1cl
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
colorscheme plain

" Reload the colorscheme whenever we write the file.
augroup color_trafficlights_dev
    au!
    au BufWritePost trafficlights.vim color trafficlights
    au BufWritePost plain.vim color plain
augroup END
" }}}

" Tabline {{{
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " set up some oft-used variables
      let tab = i + 1 " range() starts at 0
      let winnr = tabpagewinnr(tab) " gets current window of current tab
      let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
      let bufnr = buflist[winnr - 1] " current buffer number
      let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

      let s .= '%' . tab . 'T' " start a tab
      let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
      let s .= ' ' . tab " current tab number
      let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
      if n > 1
        let s .= ':' . n " if there's more than one, add a colon and display the count
      endif
      let bufmodified = ''
      " getbufvar(bufnr, "&mod")
      for b in buflist
        if getbufvar(b, "&mod")
          let bufmodified = 1
          break
        endif
      endfor
      if bufmodified
        let s .= ' +'
      endif
      if bufname != ''
        " let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
        let s .= ' ' . fnamemodify(bufname,":t") . ' ' " outputs the one-letter-path shorthand & filename
      else
        let s .= ' [No Name] '
      endif
      if tab == tabpagenr()
          let s .= '%999X x '
      else
          let s .= '   '
      endif
    endfor
    let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
    let s .= '%T' " resets tab page number?
    let s .= '%=' " seperate left-aligned from right-aligned
    " let s .= '%#TabLine#' " set highlight for the 'X' below
    " let s .= '%999XX' " places an 'X' at the far-right
    return s
  endfunction
  set tabline=%!MyTabLine()
endif
" }}}

" Statusline {{{
function! ColPad()
    let ruler_width = max([strlen(line('$')), (&numberwidth - 1)])
    let column_width = strlen(virtcol('.'))
    let padding = ruler_width - column_width

    redir =>a|exe "sil sign place buffer=".bufnr('')|redir end
    let signs = split(a, "\n")[1:]
    if !empty(signs)
        let padding = padding + 2
    endif

    if &foldcolumn!=''
        let padding = padding + &foldcolumn
    endif

    if padding <= 0
        return ''
    else
        " + 1 becuase for some reason vim eats one of the spaces
        return repeat(' ', padding + 1)
endfunction

" runtime! autoload/noscrollbar.vim

let &statusline=''
let &statusline.="%{ColPad()}"
let &statusline.='%c'
let &statusline.=" %<%t  %m%r%w%q%y%{&diff?'[diff]':''}"
let &statusline.="%{exists('g:loaded_fugitive')?fugitive#statusline():''}"
let &statusline
\   .="%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}"
let &statusline.="%="
let &statusline
\   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'■','◫',['◧'],['◨']):''} "
" \   .=" %{exists('*noscrollbar#statusline')?noscrollbar#statusline(20,'■','◫',['◧'],['◨']):''} "
" \   .=" %{noscrollbar#statusline()} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'■','◫',['◧'],['◨']):''} "
" \   .=" %3*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(30,' ','▓',['▐'],['▌']):''}%0*"
" \   .="[%3*%{noscrollbar#statusline(20,'_','-',[],[],'l')}%1*%{noscrollbar#statusline(20,'_','-',[],[],'m')}%3*%{noscrollbar#statusline(20,'_','-',[],[],'r')}%0*]"
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''} "
" \   .=" %{noscrollbar#statusline(20,'■','-',[],[],'l')}%3*%{noscrollbar#statusline(20,'■','■',[],[],'m')}%0*%{noscrollbar#statusline(20,'■','-',[],[],'r')}" 
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''} "
" \   .=" %3*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(30,' ','▓',['▐'],['▌']):''}%0*"
" \   .=" %3*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(30,' ','█',['▐'],['▌']):''}%0*"
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(10,'_','0',['o','O'],['o','O']):''}]"
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'■','◫',['◧'],['◨']):''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'■','◫',['◧'],['◨']):''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''} "
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,' ','▌'):''}]"
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(10,'_','0',['o','O'],['o','O']):''}]"
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(30,' ','█',['░','▒','▓'],['░','▒','▓']):''}]"
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''}]"
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'\ ','-'):''}]"
" \   .=" %{noscrollbar#statusline(20,'■','-',[],[],'l')}%3*%{noscrollbar#statusline(20,'■','■',[],[],'m')}%0*%{noscrollbar#statusline(20,'■','-',[],[],'r')}" 
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'■',' '):''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(25,'■','◫',['◧'],['◨'],'a'):''} "
" \   .=" %{exists('g:noscrollbar_loaded')?noscrollbar#statusline(25,'■','◫',['','◧'],['','◨'],'a'):''} "
" \   .=" [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'\ ','-'):''}]"
let &statusline.="%3*%{&paste?'  paste ':''}%0*"
" }}}

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{noscrollbar#statusline()}
" " Signs {{{
" augroup signs
"   autocmd!
"   autocmd BufEnter * sign define dummy
"   autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
" augroup END
" " }}}

" }}}

" Abbreviations ----------------------------------------------------------- {{{

iabbrev gcavn@ gcavn@gcavn.com

" }}}

" Convenience mappings ---------------------------------------------------- {{{

cnoremap <f1> <C-c>:<up>

vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Easy window resizing
nnoremap <silent> <C-w><C-up> 10<c-w>+
nnoremap <silent> <C-w><C-down> 10<c-w>-
nnoremap <silent> <C-w><C-left> 10<c-w><
nnoremap <silent> <C-w><C-right> 10<c-w>>

" Grep the last search pattern and open the quickfix list 
nnoremap <silent> <leader>/ :execute 'vimgrep /' . @/ . '/g %'<CR>:copen<CR>

" nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>
" nnoremap <leader>d "_d
" vnoremap <leader>d "_d

" Paste the text from most recent yank command
nnoremap <leader>p "0p
nnoremap <leader>P "0P

" Convert hard wraps to soft wraps
command! -range=% SoftWrap <line2>put _ | <line1>,<line2>g/.\+/ .;-/^$/ join |normal $x

" Clean trailing whitespace
" nnoremap <leader>j mz:s/\s\+$//<cr>:let @/=''<cr>`z
" command! DeleteTrailing normal mz<r>:s/\s\+$//

" Kill window           
nnoremap <leader>q :confirm qa<cr>

" Write buffer to file
nnoremap <leader>w :w<cr>

" A tab is like a paGe
nnoremap [g :tabprev<cr>
nnoremap ]g :tabnext<cr>
nnoremap ]G :tablast<cr>
nnoremap [G :tabfirst<cr>

" Make Y move like D and C
noremap Y y$

" Rebuild Ctags (mnemonic RC -> CR -> <cr>)
" nnoremap <leader><cr> :silent !myctags<cr>:redraw!<cr>

nnoremap <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Select entire buffer
nnoremap <leader>a ggVG

" Easier reselection of what you just pasted.
nnoremap <expr> <leader>v '`[' . strpart(getregtype(), , 1) . '`]'
xnoremap > >gv
xnoremap < <gv
" Indent/dedent/autoindent what you just pasted.
nnoremap <lt>> V`]<
nnoremap ><lt> V`]>
nnoremap =- V`]=

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Directional Keys
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Switch inner word caSe
inoremap <C-s> <esc>mzg~iw`za

" Easier editing of alternate file
nnoremap <BS> <C-^>

" Ins-completion mode {{{
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr><TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
" inoremap . .<C-x><C-o>
" inoremap <expr>. IsValidSuffix() ? ".\<C-x>\<C-o>" : "."
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" inoremap <C-Space> <C-x><C-o><C-n><C-p>
inoremap <expr><C-Space> (pumvisible() ? "\<C-y>\<C-x>\<C-o>\<C-n>\<C-p>" : "\<C-x>\<C-o>\<C-n>\<C-p>" )
imap <C-@> <C-Space>
inoremap <C-l> <C-X><C-U>
inoremap <expr><C-j> pumvisible() ? '<C-y><C-n><down><up><c-n><c-p>' : "\<C-n>\<down>\<up>\<C-n>\<C-p>"
inoremap <C-h> <C-x><C-f>
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

function IsValidSuffix()
  if col('.') == 1
    return 0
  endif
  let d = synIDattr(synID(line("."), col("."), 1), "name")
  if match(d, 'omment\|tring') >= 0
    return 0
  endif
  let suffix = getline('.')[col('.') - 2]
  if match(suffix, '\a') >= 0
    return 1
  else
    return 0
  endif
endfunction

" }}}

" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>eh :e ~/.<cr>
nnoremap <leader>ef :e %:p:h<cr>
nnoremap <leader>e. :e .<cr>

" }}}

" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
" nnoremap / /\v
" vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
" set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

" }}}

" Folding ----------------------------------------------------------------- {{{

set foldlevelstart=99
" Space to toggle folds.
nnoremap <leader>l za
vnoremap <leader>l za
" }}}

" Filetype-specific ------------------------------------------------------- {{{

" Bash {{{
augroup ft_bash
    au!
    au BufNewFile,BufRead *.sh setlocal filetype=zsh
    au FileType sh let b:is_bash=1
    au FileType sh setlocal filetype=zsh
augroup END
" }}}

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

    " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
    " au Filetype javascript inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END
" }}}

" Markdown {{{
augroup ft_mardakdown
    au!
    au BufNewFile,BufRead {*.md,*.mkd,*.markdown} setl filetype=markdown 
    au FileType text call Prose()
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
    au Filetype qf setlocal colorcolumn=0 nolist nonumber norelativenumber nocursorline nowrap tw=0
    au Filetype qf setlocal stl=%t\ (%l\ of\ %L)%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ [%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'\ ','-'):''}]
augroup END
" }}}

" Text {{{
augroup ft_text
    au!
    " autocmd BufReadPost,BufNewFile *.txt setlocal filetype=text 
    au FileType text call Prose()
augroup END
" }}}

" Vim {{{
augroup ft_vim
    au!
    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au FileType vim setlocal formatoptions=qrn1cl
    " au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END
" }}}

" Python {{{
augroup ft_python
    au!
    au FileType python setl foldmethod=expr
    au FileType python setl foldexpr=g:Pymodefoldingexpr(v:lnum)
    au FileType python setl omnifunc=pythoncomplete#Complete
augroup END

" }}}

" YAML {{{
augroup ft_yaml
    au!
    au FileType yaml setl shiftwidth=2
augroup END
" }}}

" latex {{{
augroup ft_latex
    au!
    let g:tex_flavor = "latex"
augroup END
" }}}

" XML {{{
augroup ft_xml
    au!
    au FileType xml setl foldmethod=manual
augroup END
" }}}

" }}}

" }}}

" Plugin settings --------------------------------------------------------- {{{

" Latex-Box {{{
let g:LatexBox_autojump=0
let g:LatexBox_no_mappings=1
" }}}

" EasyAlign {{{
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
" }}}

" DelimitMate {{{
let delimitMate_expand_cr = 1
" }}}

" Ctrl-P {{{
let g:ctrlp_match_window = 'bottom,order:ttb,min:20,max:20'
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_switch_buffer = 0
" let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_mruf_exclude = '/var/folders/.*\|/private/var/folders/.*\|.*\.DS_Store\|\.vim/bundle/.*/doc/.*\|/usr/share/.*doc/.*'
" /usr/local/Cellar/.*doc\|
" }}}

" Tagbar {{{
" let g:tagbar_iconchars = ['+','-']
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_indent = 2
let g:tagbar_left = 1
let g:tagbar_foldlevel = 0
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }
nnoremap <silent> <F9> :TagbarToggle<CR>
" }}}

" Syntastic {{{
let g:syntastic_mode_map = { "mode": "passive"}
let g:syntastic_enable_highlighting = 0
nnoremap <leader>sc :SyntasticCheck<cr>
nnoremap <leader>sr :SyntasticReset<cr>
" }}}

" undotree {{{
nnoremap <F5> :UndotreeToggle<cr>
let g:undotree_WindowLayout = 4
let g:undotree_SplitWidth = 50
let g:undotree_DiffCommand = "diff --context=1"
let g:undotree_DiffpanelHeight = 20
" }}}

" jedi {{{
let g:jedi#auto_vim_configuration = 0
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures = 0
let g:jedi#auto_close_doc = 0
 " }}}

 " tern {{{
let g:tern_show_signature_in_pum=0
let g:tern_show_argument_hints='no'
 " }}}

" eclim {{{
let g:EclimCompletionMethod = 'omnifunc'
" }}}

" " neocomplete {{{
" let g:neocomplete#enable_at_startup = 0
" let g:neocomplete#enable_fuzzy_completion = 0
" let g:neocomplete#manual_completion_start_length = 0
" let g:neocomplete#enable_auto_select = 0
" let g:neocomplete#disable_auto_complete = 1
" let g:neocomplete#enable_insert_char_pre = 1
" " inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"
" " inoremap <expr><C-Space> neocomplete#start_manual_complete()
" " imap <C-@> <C-Space>
" let g:neocomplete#force_omni_input_patterns = {}
" let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'
" let g:neocomplete#force_omni_input_patterns.cpp = '[^. *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
" " }}}

" Yankstack {{{
" nmap <esc>p <Plug>yankstack_substitute_older_paste
" nmap <esc>P <Plug>yankstack_substitute_newer_paste
" }}}

" Markdown {{{
let g:markdown_folding=1
let g:markdown_fenced_languages = ['python', 'ruby']
" }}}


" Ultisnips {{{
" let g:UltiSnipsListSnippets="<c-j>"
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"

function! SnipComplete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    else
        let suggestions = []
        let ultidict = UltiSnips#SnippetsInCurrentScope()
        for entry in items(ultidict)
            if entry[0] =~ '^' . a:base
                call add(suggestions, {'word': entry[0], "menu": entry[1]})
            endif
        endfor
        return suggestions
endfunction
set completefunc=SnipComplete

" }}}
" }}}

" Miniplugins ------------------------------------------------------------ {{{

" Prose {{{
function Prose()
    inoremap <buffer><expr><C-Space> pumvisible() ? '<C-y><C-x><C-k><down><up><c-n><c-p>' : "\<C-x><C-k>\<down>\<up>\<C-n>\<C-p>"
    setlocal fo+=t
    inoremap <buffer> . .<C-G>u
    inoremap <buffer> , ,<C-G>u
    inoremap <buffer> ! !<C-G>u
    inoremap <buffer> ? ?<C-G>u
endfunction
" }}}

" MRU {{{
function! MRUComplete(ArgLead, CmdLine, CursorPos)
  let my_oldfiles = filter(copy(v:oldfiles), 'v:val =~ a:ArgLead')
  if len(my_oldfiles) > 16
    call remove(my_oldfiles, 17, len(my_oldfiles) - 1)
  endif
  return my_oldfiles
endfunction
function! MRU(command, arg)
  if a:command == "tabedit"
    execute a:command . " " . a:arg . "\|lcd %:p:h"
  else
    execute a:command . " " . a:arg
  endif
endfunction
command! -nargs=1 -complete=customlist,MRUComplete ME call MRU('edit', <f-args>)
" }}}

" Diff orig {{{
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

nnoremap <F8> :call SynStack()<CR>
" }}}

" Diff Last Saved {{{
function! s:MyDiffLastSaved()
  if &modified
    let winnum = winnr()
    let filetype=&ft
    vertical botright new | r #
    1,1delete _

    diffthis
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal nobuflisted
    setlocal noswapfile
    setlocal readonly
    exec "setlocal ft=" . filetype
    let diffnum = winnr()

    augroup diff_saved
      autocmd! BufUnload <buffer>
      autocmd BufUnload <buffer> :diffoff!
    augroup END

    " exec winnum . "winc w"
    " diffthis

    " for some reason, these settings only take hold if set here.
    call setwinvar(diffnum, "&foldmethod", "diff")
    call setwinvar(diffnum, "&foldlevel", "0")
  else
    echo "No changes"
  endif
endfunction
command! -nargs=0 MyDiffLastSaved call s:MyDiffLastSaved()
" }}}

" Python-mode folding functions {{{
let g:def_regex = '^\s*\%(class\|def\) \w\+'
let g:blank_regex = '^\s*$'
let g:decorator_regex = '^\s*@'
let g:doc_begin_regex = '^\s*\%("""\|''''''\)'
let g:doc_end_regex = '\%("""\|''''''\)\s*$'
let g:doc_line_regex = '^\s*\("""\|''''''\).\+\1\s*$'
let g:symbol = matchstr(&fillchars, 'fold:\zs.')  " handles multibyte characters
if g:symbol == ''
    let g:symbol = ' '
endif

" fun! g:pymodefoldingtext() " {{{
"     let fs = v:foldstart
"     while getline(fs) =~ '\%(^\s*@\)\|\%(^\s*\%("""\|''''''\)\s*$\)'
"         let fs = nextnonblank(fs + 1)
"     endwhile
"     let line = getline(fs)

"     let nucolwidth = &fdc + &number * &numberwidth
"     let windowwidth = winwidth(0) - nucolwidth - 6
"     let foldedlinecount = v:foldend - v:foldstart

"     " expand tabs into spaces
"     let onetab = strpart('          ', 0, &tabstop)
"     let line = substitute(line, '\t', onetab, 'g')

"     let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
"     let line = substitute(line, '\%("""\|''''''\)', '', '')
"     let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
"     return line . '…' . repeat(g:symbol, fillcharcount) . ' ' . foldedlinecount . ' '
" endfunction "}}}

fun! g:Pymodefoldingexpr(lnum) "{{{

    let line = getline(a:lnum)
    let indent = indent(a:lnum)
    let prev_line = getline(a:lnum - 1)

    if line =~ g:def_regex || line =~ g:decorator_regex
        if prev_line =~ g:decorator_regex
            return '='
        else
            return ">".(indent / &shiftwidth + 1)
        endif
    endif

    if line =~ g:doc_begin_regex && line !~ g:doc_line_regex && prev_line =~ g:def_regex
        return ">".(indent / &shiftwidth + 1)
    endif

    if line =~ g:doc_end_regex && line !~ g:doc_line_regex
        return "<".(indent / &shiftwidth + 1)
    endif

    if line =~ g:blank_regex
        if prev_line =~ g:blank_regex
            if indent(a:lnum + 1) == 0 && getline(a:lnum + 1) !~ g:blank_regex
                return 0
            endif
            return -1
        else
            return '='
        endif
    endif

    if indent == 0
        return 0
    endif

    return '='

endfunction "}}}
" }}}

" Highlight Word {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction " }}}

" Mappings {{{

nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>

" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" }}}
" Show context-preview {{{
function! ShowContextPreview()
    let l:winview = winsaveview()
    call searchpair('(', '', ')', 'bW', 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"')
    let pos = col('.')
    call ShowCurrentPreview(pos-1)
    call winrestview(l:winview)
endfunc

function! ShowCurrentPreview(pos)
    let startpos=function(&omnifunc)(a:pos,'')
    if type(startpos) == 3
        let completions=startpos
    elseif type(startpos) == 0
        echom startpos
        if startpos > -1
            let line=getline('.')
            let matchstring=strpart(line,startpos,a:pos-startpos)
            let completions=function(&omnifunc)(0,matchstring)
        endif
    endif
    if completions == [] || len(completions) == 0 || has_key(completions[0],'info')==0 || completions[0]['info']==''
        return
    endif
    silent! wincmd P
    if &previewwindow
        setlocal modifiable
        %delete _
    else
        new
        setlocal previewwindow
        setlocal buftype=nofile
        setlocal bufhidden=wipe
        setlocal noswapfile
    endif
    resize 5
    put =completions[0]['info']
    setlocal nomodifiable
    wincmd p
endfunc
nnoremap <F2> :silent! call ShowContextPreview()<CR>
inoremap <F2> <C-O>:silent! call ShowContextPreview()<CR>
nnoremap <leader>kc :silent! call ShowCurrentPreview(col('.'))<CR>
" }}}

" Online help {{{
function! OnlineHelp()
    if exists("b:source") && b:source != ''
        let b:source = input("Choose source: ", b:source)
    else
        let b:source = input("Choose source: ", &ft)
    endif
    let l:keyword = input("Search for: ", expand("<cword>"))
    call system('/Users/ioacvl/.dotfiles/bin/ioadoc ' . b:source . ' ' . l:keyword)
endfunc
nnoremap <F12> :call OnlineHelp()<CR>
" }}}



" }}}

" Environments (GUI/Console) ---------------------------------------------- {{{

if has('gui_running')
    if has("gui_macvim")

    else

    end
else
    if has("mac")
        set clipboard=unnamed
    else
        set clipboard=unnamedplus
    endif
    set mouse=a
    if &term =~ '^screen'

        " tmux knows the extended mouse mode
        set ttymouse=xterm2

        " change cursor shape when switching from normal to insert mode and back
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

        " support for shift + arrow keys
        execute "set <xUp>=\e[1;*A"
        execute "set <xDown>=\e[1;*B"
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
    else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif
endif

" }}}
