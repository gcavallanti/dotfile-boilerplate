" Preamble ---------------------------------------------------------------- {{{

filetype off
call pathogen#infect()
filetype plugin indent on
set nocompatible
" }}}

" Basic options ----------------------------------------------------------- {{{

" Change directory to the current buffer when opening files.
" set autochdir
" set encoding=utf-8
set modelines=1
set autoindent
set showmode
set hidden
set visualbell
set backspace=indent,eol,start
set number
set numberwidth=5
" set showtabline=1
" These slow things down too much
" set showcmd
" set lazyredraw
set relativenumber
" set ttyfast
" set ttymouse=xterm2
" set ttyscroll=3
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set listchars=tab:»\ ,eol:¬,extends:›,precedes:‹,space:\·
" set listchars=tab:»\ ,eol:¬,extends:›,precedes:‹
set matchtime=3
" set showbreak=↪
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
set fillchars=diff:\·,vert:│
" set fillchars+=diff:\·,fold:█
set fillchars+=diff:\.
" set cursorline
set winminwidth=10
let &winwidth=float2nr(&columns/1.618)
let &winheight=float2nr(&lines/1.618)

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

let mapleader=' '

set pastetoggle=<F11>
     
set pumheight=10
" Preview {{{
" Turn off previews once a completion is accepted
" autocmd CursorMovedI *  if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
set previewheight=15
" " set previewheight=10
" au BufEnter ?* call PreviewHeightWorkAround()
" func PreviewHeightWorkAround()
"     if &previewwindow
"       exec 'setlocal winheight='.&previewheight
"         " res &previewheight
"     endif
" endfunc

set previewheight=50
au BufEnter ?* call PreviewHeightWorkAround()
func PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunc
" }}}

" cpoptions+=J {{{
" A |sentence| has to be followed by two spaces after the '.', '!' or '?'.  A <Tab> is not recognized as white space.
" augroup twospace
"     au!
"     au BufRead * :set cpoptions+=J
" augroup END

" }}}

" Highlight VCS conflict markers
" match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing           
    au!
    au InsertEnter * :set listchars-=trail:⋅
    au InsertLeave * :set listchars+=trail:⋅
augroup END
" }}}

set wildmode=list

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
set formatoptions=crqnl1
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
augroup plain
    au!
    au BufWritePost plain.vim color plain
augroup END
" }}}

" " Tabline {{{
" if exists("+showtabline")
"   function! MyTabLine()
"     let s = ''
"     for i in range(tabpagenr('$'))
"       " set up some oft-used variables
"       let tab = i + 1 " range() starts at 0
"       let winnr = tabpagewinnr(tab) " gets current window of current tab
"       let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
"       let bufnr = buflist[winnr - 1] " current buffer number
"       let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

"       let s .= '%' . tab . 'T' " start a tab
"       let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
"       " let s .= ' ' . tab " current tab number
"       let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
"       " if n > 1
"       "   let s .= ':' . n " if there's more than one, add a colon and display the count
"       " endif
"       let bufmodified = ''
"       " getbufvar(bufnr, "&mod")
"       for b in buflist
"         if getbufvar(b, "&mod")
"           let bufmodified = 1
"           break
"         endif
"       endfor
"       if bufname != ''
"         " let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
"         let s .= ' ' . fnamemodify(bufname,":t") . '' " outputs the one-letter-path shorthand & filename
"       else
"         let s .= ' [No Name]'
"       endif
"       if bufmodified
"         let s .= '[+]'
"       endif
"       if tab == tabpagenr()
"           let s .= '%999X x '
"       else
"           let s .= '   '
"       endif
"     endfor
"     let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
"     let s .= '%T' " resets tab page number?
"     let s .= '%=' " seperate left-aligned from right-aligned
"     " let s .= '%#TabLine#' " set highlight for the 'X' below
"     " let s .= '%999XX' " places an 'X' at the far-right
"     return s
"   endfunction
"   set tabline=%!MyTabLine()
" endif
" " }}}

" Statusline {{{
" function! ColPad()
"     let ruler_width = max([strlen(line('$')), (&numberwidth - 1)])
"     let column_width = strlen(virtcol('.'))
"     let padding = ruler_width - column_width

"     redir =>a|exe "sil sign place buffer=".bufnr('')|redir end
"     let signs = split(a, "\n")[1:]
"     if !empty(signs)
"         let padding = padding + 2
"     endif

"     if &foldcolumn!=''
"         let padding = padding + &foldcolumn
"     endif

"     if padding <= 0
"         return ''
"     else
"         " + 1 becuase for some reason vim eats one of the spaces
"         return repeat(' ', padding + 1)
" endfunction

" function! Mytabs()
"   let tabstatus = ''
"   for i in range(tabpagenr('$'))
"     " set up some oft-used variables
"     let tab = i + 1 " range() starts at 0
"     if (tab == tabpagenr())
"       let tabstatus .= '*'
"     else
"       let tabstatus .= '.'
"     endif
"   endfor
"   return tabstatus
" endfunction

" function! MyStatusLine()

"     let curwin = winnr()

"     let stl=''.curwin.':'
"     let stl=''
"     " let stl.='%1* %{winnr()} %* '
"     let stl.="%1*%{winnr()==".curwin."?'  ' . &ft . ' ':''}%*"

"     let stl.=" %*%f%*"
"     let stl.="%m "
"     let stl.="%*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*"
"     let stl.="%*%{exists('g:loaded_gitgutter')?'+'.GitGutterGetHunkSummary():''}%*"
"     let stl.="%*%r%w%q%{&diff?'[diff]':''}%*"
"     let stl.="%<"
"     let stl.="%="
"     let stl.="%*%{&paste?'[paste]':''}%*"
"     let stl.="%*%{&hls?'[hls]':''}%*"
"     let stl.="%2*%5l/%L : %*"
"     let stl
"     \   .="%2*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline():''}"
"     let stl.=" %P "
"     let stl.=": %3c/%-3{len(getline(line('.')))} %*"

"     return stl
" endfunc
" function! Mode()
"     " redraw
"     " let l:mode = mode()
"     let l:mode = &filetype

"     if mode ==# "n" | exec 'hi User1 ' . 'ctermfg=255 ctermbg=236' | return l:mode
"     elseif mode ==# "i" | exec 'hi User1 ' . 'ctermfg=243 ctermbg=236' | return l:mode
"     elseif mode ==# "vim" | exec 'hi User1 ' . 'ctermfg=134 ctermbg=236' | return l:mode
"     elseif mode ==# "v" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return l:mode
"     elseif mode ==# "V" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return l:mode
"     elseif mode ==# "^V" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return l:mode
"     else | exec 'hi User1 ' . 'ctermfg=250 ctermbg=236' | return l:mode
"     endif
" endfunc
" " set statusline=
" " set statusline+=%*\[%n]                                  "buffernr
" " set statusline+=%*\ %<%F\                                "File+path
" " set statusline+=%*\ %y\                                  "FileType
" " set statusline+=%*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
" " set statusline+=%*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
" " set statusline+=%*\ %{&ff}\                              "FileFormat (dos/unix..) 
" " set statusline+=%*\ %{&spelllang}\%{HighlightSearch()}\  "Spellanguage & Highlight on?
" " set statusline+=%*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
" " set statusline+=%*\ col:%03c\                            "Colnr
" " set statusline+=%*\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.
" " runtime! autoload/noscrollbar.vim
" " hi User1 guifg=#ffdad8  guibg=#880c0e
" " hi User2 guifg=#000000  guibg=#F4905C
" " hi User3 guifg=#292b00  guibg=#f4f597
" " hi User4 guifg=#112605  guibg=#aefe7B
" " hi User5 guifg=#051d00  guibg=#7dcc7d
" " hi User7 guifg=#ffffff  guibg=#880c0e gui=bold
" " hi User8 guifg=#ffffff  guibg=#5b7fbb
" " hi User9 guifg=#ffffff  guibg=#810085
" " hi User0 guifg=#ffffff  guibg=#094afe

let &statusline=" "
" let &statusline.="%{ColPad()}"
" let &statusline.='%c'
" " let &statusline.=" %<%t  %m%r%w%q%y%{&diff?'[diff]':''}"
" let &statusline.=" %<%1* [%n]:%f%*"
" let &statusline.="  %M%R%W%q%Y%{&diff?'[diff]':''}"
" let &statusline.="%{exists('g:loaded_fugitive')?fugitive#statusline():''}"
" " let &statusline.="%{exists('g:loaded_fugitive')?fugitive#head(7):''}"
" " set statusline+=%#WarningMsg#
" let &statusline
" \   .="%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}"
" let &statusline.="%="
" " let &statusline.="%{fnamemodify(getcwd(),':p:~')}             "
" let &statusline
" \   .=" %*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'-','='):''}%* "

" let &statusline='%2* paste hls %*'
" let &statusline='%1* %{Mode()} %* '
" let &statusline='%1* %Y%* '
" let &statusline='%{GitGutterGetHunkSummary()}'
" let &statusline="%1*%{&ft!=''?'  '.&ft.' ':''}%*"
" let &statusline="%1*%{&ft!=''?'  '.&ft.' ':''}%*"
" let &statusline.="%*%{Mytabs()}%* : "
" let &statusline.="%*%{ColPad()}%*"
" let &statusline.="%*%c %*"
" let &statusline.="%5l/%-5L %*"
" let &statusline.="%3c/%-3{len(getline(line('.')))} %*"
" let &statusline.='%{mode()} '
" let &statusline.="%* %n %*:"
" let &statusline.="%1*%{&ft!=''?'  '.&ft.' ':''}%*"
" let &statusline.="%1*%y%*"
let &statusline.="%* -  "
let &statusline.="%*%n:%1*%t%*"
let &statusline.="%m%r  "
" let &statusline.="%1*%{exists('g:loaded_fugitive')?fugitive#head(6):''}%*"
" let &statusline.="%1*%{exists('g:loaded_gitgutter')?'[+'.GitGutterGetHunkSummary()[0].',~'.GitGutterGetHunkSummary()[1].',-'.GitGutterGetHunkSummary()[2].']':''}%*"
" let &statusline.="%*%r%w%q%y%{&diff?'[diff]':''}%*"
let &statusline.="%*%y%w%q%*"
let &statusline.="%*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*"
let &statusline.="  %*%{&diff?'[diff]':''}%*"
let &statusline.="  %*%{&paste?'[paste]':''}%*"
let &statusline.="%*%{&hls?'[hls]':''}  %*"
" let &statusline.="%*%{'['.(&fenc!=''?&fenc:&enc).']'}"
" let &statusline.="%*%{(&bomb?\",BOM\":\"\")}"
" let &statusline.="%*[%{&ff}]"
" let &statusline.="%*[%{&spelllang}]"
" let &statusline.="%6*:%c "
let &statusline.="%<"
let &statusline.="%="
" let &statusline.="%= %{fnamemodify(getcwd(),':p:~')} "
" let &statusline
" \   .="%*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'-','#'):''}"
" let &statusline.="(%l/%L%*"
let &statusline.="L:%l/%L "
let &statusline.="%5(C:%c%)/%-3{len(getline(line('.')))} %*"
" let &statusline.=" %{tabpagenr()}/%{tabpagenr('$')}%* "
" let &statusline.=",%c/%{len(getline(line('.')))}) %*"
let &statusline
\   .="%* P:%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'-','#'):''}"
let &statusline.="(%P) "

" set statusline=%!MyStatusLine()
" let &statusline.="| %{tabpagenr()}/%{tabpagenr('$')}%* "
" let &statusline.="%{tabpagenr('$')!=1?'| '.tabpagenr().'/'.tabpagenr('$'):''}%* "
" let &statusline.="%8* %{fnamemodify(getcwd(),':p:~')} "
" let &statusline.="%5l/%-5L %*"
" let &statusline.="%5l[%{line('w0').'-'.line('w$')}]/%-5L %*"
" let &statusline.=": %3c/%-3{len(getline(line('.')))} %*"
" let &statusline.=" %P "
" let &statusline.="%{exists('g:loaded_fugitive')?fugitive#statusline():''}"
" let &statusline.="%{exists('g:loaded_fugitive')?fugitive#head(7):''}"
" set statusline+=%#WarningMsg#
" let &statusline
" \   .="%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}"
" let &statusline.="%="
" let &statusline.="%{fnamemodify(getcwd(),':p:~')}             "
" let &statusline
" \   .=" %*%{exists('g:noscrollbar_loaded')?noscrollbar#statusline(20,'-','='):''}%* "


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
" let &statusline.="%3*%{&paste?'  paste ':''}%0*"
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

" iabbrev gcavn@ gcavn@gcavn.com

" }}}


" Convenience mappings ---------------------------------------------------- {{{

set wildcharm=<C-z>
" cnoremap <tab> <C-c>:<C-l><up><C-z><C-z>
" cnoremap <tab> <C-c>:<c-l><up><C-z><C-z><space><BS>
cnoremap <C-@> <C-c>:<up><C-d>
" cnoremap <tab> a<bs><C-c>:<up><C-z>
" cnoremap <expr> <Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
" cmap <tab> <f1><C-z>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" Easy window resizing
" nnoremap <silent> <C-w><C-up> 10<c-w>+
" nnoremap <silent> <C-w><C-down> 10<c-w>-
" nnoremap <silent> <C-w><C-left> 10<c-w><
" nnoremap <silent> <C-w><C-right> 10<c-w>>

" Grep the last search pattern and open the quickfix list 
nnoremap <silent> <leader>/ :execute 'vimgrep /' . @/ . '/g %'<CR>:copen<CR>

" nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>
nnoremap <c-z> mzzMzvzz15<c-e>`z<cr>
" nnoremap <leader>d "0d
" vnoremap <leader>d "0d
" nnoremap <leader>x "_x
" vnoremap <leader>x "_x

nnoremap s "0d
vnoremap s "0d
" Paste the text from from recent yank command
nnoremap <leader>p "0p
vnoremap <leader>p "0p
nnoremap <leader>P "0P

" Convert hard wraps to soft wraps
command! -range=% SoftWrap <line2>put _ | <line1>,<line2>g/.\+/ .;-/^$/ join |normal $x

" Clean trailing whitespace
" nnoremap <leader>j mz:s/\s\+$//<cr>:let @/=''<cr>`z
" command! DeleteTrailing normal mz<r>:s/\s\+$//

" Kill window           
" nnoremap <leader>q :confirm qa<cr>

" Write buffer to file
" nnoremap <leader>w :w<cr>

" A tab is like a paGe
" nnoremap [g :tabprev<cr>
" nnoremap ]g :tabnext<cr>
" nnoremap ]G :tablast<cr>
" nnoremap [G :tabfirst<cr>

" nnoremap <esc>n<esc>n :tabnew<cr>
" nnoremap <esc>w<esc>w :tabprev<cr>
" nnoremap <esc>[<esc>[ :tabprev<cr>
" nnoremap <esc>]<esc>] :tabnext<cr>
" Make Y move like D and C
noremap Y y$

" Rebuild Ctags (mnemonic RC -> CR -> <cr>)
" nnoremap <leader><cr> :silent !myctags<cr>:redraw!<cr>

nnoremap <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Select entire buffer
nnoremap <leader>a ggVG

" Easier reselection of what you just pasted.
nnoremap <expr> <leader>v '`[' . strpart(getregtype(), 0, 1) . '`]'
xnoremap > >gv
xnoremap < <gv

" Source
vnoremap <leader>s y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>s ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Directional Keys
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Switch inner word caSe
inoremap <C-s> <esc>mzg~iw`za
noremap <C-s> :%s/

" Diff 
" nnoremap <leader>du :diffupdate<cr>
" nnoremap <leader>dl :DiffLastSaved<cr>

" Easier editing of alternate file
nnoremap <BS> <C-^>

" Ins-completion mode {{{
" inoremap <expr>. IsValidSuffix() ? ".\<C-x>\<C-o>" : "."
" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" basic mappings useful when the completion popup is visible
" inoremap <expr><cr> pumvisible() ? "\<c-y>" : "\<cr>"
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : exists("g:loaded_snips") ? "\<C-r>=TriggerSnippet()\<CR>" : "\<Tab>"
" inoremap <expr><tab> pumvisible() ? "\<c-y>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" omni completion
inoremap <c-x><c-o> <c-x><c-o><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>
inoremap <c-@> <c-x><c-o><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>
inoremap <c-j> <c-x><c-o><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>
" inoremap . .<c-x><c-o><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>
" inoremap c c<c-x><c-o><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>
" inoremap e e<c-r>=IsValidSuffix() ? "" : ""<cr>
" inoremap e e<c-r>=HasCompletions() ? "" : "\<lt>c-x>\<lt>c-o>"<cr>
" inoremap e e<c-r>=HasCompletions() ? "\<lt>c-x>\<lt>c-o>" : ""<cr>

" user defined completion   
inoremap <c-x><c-u> <c-x><c-u><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>
inoremap <c-l> <c-x><c-u><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>

inoremap <c-f> <c-x><c-f>
" generic completion, look in places specified in 'complete'
inoremap <c-n> <c-n><c-r>=pumvisible() ? "\<lt>c-n>\<lt>c-p>\<lt>down>" : ""<cr>

" for i in split('abcdefgdefghijklmnopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ0123456789_', '\zs')
"  execute printf('inoremap <silent> %s %s<c-r>=HasCompletions() ? "" : "\<lt>c-x>\<lt>c-o>"<cr>', i, i)
" endfor
" execute printf('inoremap <silent> %s <c-e>%s<c-r>=HasCompletions() ? "" : "\<lt>c-x>\<lt>c-o>"<cr>', '.', '.')
" au BufEnter * let b:ison=0
au CompleteDone * let b:ison=0
function HasCompletions()
  let l:da = synIDattr(synID(line("."), col("."), 1), "name")
  echom synID(line("."), col("."), 1)
  if match(da, 'omment\|tring') >= 0
    return 1
  endif
  if exists('b:ison') && b:ison == 1
    return 1
  else
    let res = call(&omnifunc, [0, ''])
    if res != []
      let b:ison=1
      return 0
    else
      return 1
    endif
  endif
  " try
  "   norm! i
  "   return 1
  " catch
  "   return 0
  " endtry
  " let res = call(&omnifunc, [0, ''])
  " return res != []
  " return pumvisible()
endfunction

function IsValidSuffix()
  if col('.') == 1
    return 0
  endif
  let d = synIDattr(synID(line("."), col("."), 1), "name")
  if match(d, 'omment\|tring') >= 0
    return 0
  endif
  let suffix = getline('.')[col('.') - 3]
  echom suffix
  if match(suffix, 'a') >= 0
    return 1
  else
    return 0
  endif
endfunction

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <f3> :ZoomToggle<CR>
" }}}

" Quick editing ----------------------------------------------------------- {{{

" nnoremap <leader>eh :e ~/<c-l>
" nnoremap <leader>ef :e %:p:h<c-l>
nnoremap <leader>e :e <c-d>
" nnoremap <leader>en :enew<cr> 

nnoremap <leader>b :ls<cr>:b 

" }}}

" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
" nnoremap / /\v
" vnoremap / /\v

set ignorecase
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
" nnoremap <leader>l za
" vnoremap <leader>l za
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
    " au FileType python setl foldmethod=expr
    " au FileType python setl foldexpr=g:Pymodefoldingexpr(v:lnum)
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

" crontab {{{
augroup ft_crontab
  au filetype crontab setl nobackup nowritebackup
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

" Fugitive {{{
" nnoremap <leader>gd :Gdiff<cr>
" nnoremap <leader>gs :Gstatus<cr>
" nnoremap <leader>gw :Gwrite<cr>
" nnoremap <leader>ga :Gadd<cr>
" nnoremap <leader>gb :Gblame<cr>
" nnoremap <leader>gco :Gcheckout<cr>
" nnoremap <leader>gci :Gcommit<cr>
" nnoremap <leader>gm :Gmove<cr>
" nnoremap <leader>gr :Gremove<cr>
" nnoremap <leader>gl :sp<cr>:Git! lgd<cr>:set ft=git<cr>
" }}}

" Ctrl-P {{{
" let g:ctrlp_notational_dir = '~/tmp/notes/origenc/'
" let g:ctrlp_notational_decrypt_cmd = 'openssl rc4 -d -k bla -in '
" let g:ctrlp_notational_decrypt_cmd = 'gpg -q --batch --passphrase bla --no-mdc-warning -d '
" let g:ctrlp_notational_decrypt_ext = 'gpg'
let g:ctrlp_switch_buffer = 'VHT'
let g:ctrlp_match_window = 'bottom,order:ttb,min:20,max:20'
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_cmd = 'CtrlPBuffer'
" let g:ctrlp_switch_buffer = 0
" let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_mruf_exclude = '/var/folders/.*\|/private/var/folders/.*\|.*\.DS_Store\|\.vim/bundle/.*/doc/.*\|/usr/share/.*doc/.*'
" /usr/local/Cellar/.*doc\|
" let g:ctrlp_extensions = ['notational', 'buffertag', 'bookmarkdir','undo']
let g:ctrlp_extensions = ['cmdline', 'menu']

com! -n=? -com=dir CtrlPnotational         cal ctrlp#init(ctrlp#notational#id(), { 'dir': <q-args> })
nnoremap <c-q> :CtrlPnotational ~/notes/<cr>

" }}}

" Syntastic {{{
" let g:syntastic_mode_map = { "mode": "passive"}
" let g:syntastic_enable_highlighting = 0
nnoremap <leader>sc :SyntasticCheck<cr>
nnoremap <leader>sr :SyntasticReset<cr>
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = "-"
let g:syntastic_warning_symbol = "-"
let g:syntastic_style_error_symbol = "~"
let g:syntastic_style_warning_symbol = "~"
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

" mRu {
function! MRUComplete(ArgLead, CmdLine, CursorPos)
    return filter(copy(v:oldfiles), 'v:val =~ a:ArgLead && v:val !~ "Cellar"')[0:10]
endfunction

command! -nargs=1 -complete=customlist,MRUComplete R execute 'edit ' . <f-args>
nnoremap <leader>r :R<space><C-z>
" }}}

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

" Synstack {{{
" Show the stack of syntax hilighting classes affecting whatever is under the
" cursor.
function! SynStack()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc

nnoremap <F8> :call SynStack()<CR>
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
    " resize 5
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
" nnoremap <F12> :call OnlineHelp()<CR>
" }}}

" Toggle lists {{{
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>ll :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>lq :call ToggleList("Quickfix List", 'c')<CR>
" }}}

" Project directory {{{
" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
  let current_file = expand('%:p')
  " do not mess with 'fugitive://' etc
  if current_file =~ '^\w\+:/' || &filetype =~ '^git'
    return
  endif
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if (git_dir != "") && empty(is_not_git_dir)
    lcd `=git_dir`
  endif
endfunction
" follow symlinked file
function! FollowSymlink()
  let current_file = expand('%:p')
  " do not mess with 'fugitive://' etc
  if current_file =~ '^\w\+:/' || &filetype =~ '^git'
    return
  endif
  if getftype(current_file) == 'link'
    let actual_file = resolve(current_file)
    silent! execute 'file ' . actual_file
  end
endfunction
" }}}

" DiffToggle {{{
function! DiffToggle()
  if &diff
    diffoff
  else
    diffthis
  endif
endfunction

nmap <silent> <f10> :call DiffToggle()<cr>
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
