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
    au InsertEnter * :set listchars-=trail:␣
    au InsertLeave * :set listchars+=trail:␣
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

function! IsHelp()
  return &bu:ftype=='help'?' (help) ':''
endfunction

function! GetName()
  return expand("%:t")==''?'<none>':expand("%:t")
endfunction

 " hi User1 ctermfg=250 ctermbg=33
 " hi User3 ctermfg=242 
 " hi User4 ctermfg=255
" " hi User5 ctermfg=242 ctermbg=236
" hi User6 ctermfg=250 ctermbg=235
 " hi User1 ctermfg=250 ctermbg=235
 " hi User3 ctermfg=242 ctermbg=235
 " hi User4 ctermfg=255 ctermbg=235
" "
set statusline=\ \ %1*%t%3*
set statusline+=%4*%m%3*
set statusline+=%4*%h%3*
set statusline+=%4*%r%3*
set statusline+=%3*%4*%{&bomb?'[bomb]':''}%3*
set statusline+=%4*%{fugitive#statusline()}%3*
set statusline+=\ \ %3*fenc:%4*%{(&fenc!='')?&fenc:'none'}%3*\ \ 
set statusline+=%3*ff:%4*%{&ff}%3*\ \ 
set statusline+=%3*ft:%4*%{(&ft!='')?&ft:'<none>'}\ \ 
" set statusline+=%5*%{v:register}%3*\ \ 
" set statusline+=%3*tab:%4*%{&ts}
" set statusline+=%3*,%4*%{&sts}
" set statusline+=%3*,%4*%{&sw}
" set statusline+=%3*,%4*%{&et?'et':'noet'}\ \ 
set statusline+=%<%3*cwd:%4*%{getcwd()}\ \ 
set statusline+=%0*%=
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%4*%{&paste?'[paste]':''}%3*
set statusline+=\ \ %3*mode:%4*%{mode()}%3*\ \ 
set statusline+=%5*%{ProgressBar(20)}%3*\ \ 
"set statusline+=%3*pos:%4*%3P%3*\ \ 
set statusline+=%3*col:%4*%2c\ \ 
set statusline+=%3*line:%4*%3l/%3L\ \ 

function! ProgressBar(...)
    let top_line = line("w0")
    let bottom_line = line("w$")
    let current_line = line('.')
    let lines_count = line('$')

    if a:1 
        let size = str2nr(a:1)
    else
        let size = 10
    endif
    let pos = float2nr((current_line * 1.0) / (lines_count * 1.0) * size)
    let progress_bar = repeat(' ', pos) . '==' . repeat(' ',size-pos)
    return progress_bar
endfunction

function! Mode()
    redraw
    let l:mode = mode()
    
    if mode ==# "n" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=235' | return "NORMAL"
    elseif mode ==# "i" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=235' | return "INSERT"
    elseif mode ==# "R" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=235' | return "REPLACE"
    elseif mode ==# "v" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=235' | return "VISUAL"
    elseif mode ==# "V" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=235' | return "V-LINE"
    elseif mode ==# "" | exec 'hi User1 ' . 'ctermfg=250 ctermbg=235' | return "V-BLOCK"
    else | return l:mode
    endif
endfunc 

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

"find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning = '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)
    let line_lens = map(getline(1,'$'), 'len(substitute(v:val, "\\t", spaces, "g"))')
    return filter(line_lens, 'v:val > threshold')
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

" set statusline=
" set statusline+=%7*\[%n]                                  "buffernr
" set statusline+=%1*\ %<%F\                                "File+path
" set statusline+=%2*\ %y\                                  "FileType
" set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
" set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
" set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..) 
" set statusline+=%5*\ %{&spelllang}\%{HighlightSearch()}\  "Spellanguage & Highlight on?
" set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
" set statusline+=%9*\ col:%03c\                            "Colnr
" set statusline+=%0*\ \ %m%r%w\ %{v:register}\ C%P\ \                      "Modified? Readonly? Top/bot.

" function! HighlightSearch()
"   if &hls
"     return 'H'
"   else
"     return ''
"   endif
" endfunction

" hi User1 guifg=#ffdad8  guibg=#880c0e
" hi User2 guifg=#000000  guibg=#F4905C
" hi User3 guifg=#292b00  guibg=#f4f597
" hi User4 guifg=#112605  guibg=#aefe7B
" hi User5 guifg=#051d00  guibg=#7dcc7d
" hi User7 guifg=#ffffff  guibg=#880c0e gui=bold
" hi User8 guifg=#ffffff  guibg=#5b7fbb
" hi User9 guifg=#ffffff  guibg=#810085
" hi User0 guifg=#ffffff  guibg=#094afe

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}




" Abbreviations ----------------------------------------------------------- {{{
iabbrev gcavn@ gcavn@gcavn.com

" }}}




" Convenience mappings ---------------------------------------------------- {{{


" Toggle line numbers
" nnoremap <leader>n :setlocal number!<cr>

" Sort lines
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" Tabs
" nnoremap <leader>( :tabprev<cr>
" nnoremap <leader>) :tabnext<cr>

" Rebuild Ctags (mnemonic RC -> CR -> <cr>)
" nnoremap <leader><cr> :silent !myctags<cr>:redraw!<cr>

" Highlight Group(s)
"nnoremap <F8> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"                        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"                        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Clean trailing whitespace
" nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Send visual selection to paste.stevelosh.com
"vnoremap <c-p> :w !curl -sF 'sprunge=<-' 'http://paste.stevelosh.com' \| tr -d '\n ' \| pbcopy && open `pbpaste`<cr>

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" "Uppercase word" mapping.
"
" This mapping allows you to press <c-u> in insert mode to convert the current
" word to uppercase.  It's handy when you're writing names of constants and
" don't want to use Capslock.
"
" To use it you type the name of the constant in lowercase.  While your
" cursor is at the end of the word, press <c-u> to uppercase it, and then
" continue happily on your way:
"
"                            cursor
"                            v
"     max_connections_allowed|
"     <c-u>
"     MAX_CONNECTIONS_ALLOWED|
"                            ^
"                            cursor
"
" It works by exiting out of insert mode, recording the current cursor location
" in the z mark, using gUiw to uppercase inside the current word, moving back to
" the z mark, and entering insert mode again.
"
" Note that this will overwrite the contents of the z mark.  I never use it, but
" if you do you'll probably want to use another mark.
inoremap <C-u> <esc>mzgUiw`za

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Press F4 to toggle highlighting on/off, and show current value.
:noremap <F4> :set hlsearch! hlsearch?<CR>

" Press F8 to search the word under the cursor without jumping to the next match
nnoremap <F8> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" }}}




" Quick editing ----------------------------------------------------------- {{{
"
" nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"
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
" let g:ctrlp_dont_split = 'NERD_tree_2'
" let g:ctrlp_jump_to_buffer = 0
" let g:ctrlp_working_path_mode = 0
" let g:ctrlp_match_window_reversed = 1
" let g:ctrlp_split_window = 0
" let g:ctrlp_max_height = 20
" let g:ctrlp_extensions = ['tag']

" let g:ctrlp_map = '<leader>,'
" nnoremap <leader>. :CtrlPTag<cr>

" let g:ctrlp_prompt_mappings = {
" \ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
" \ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
" \ 'PrtHistory(-1)':       ['<c-n>'],
" \ 'PrtHistory(1)':        ['<c-p>'],
" \ 'ToggleFocus()':        ['<c-tab>'],
" \ }

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

nnoremap <silent> <Plug>unimpairedTabLeft   :tabNext<CR>
nnoremap <silent> <Plug>unimpairedTabRight  :tabnext<CR>
xnoremap <silent> <Plug>unimpairedTabLeft   :tabNext<CR>
xnoremap <silent> <Plug>unimpairedTabRight  :tabnext<CR>

nmap [g <Plug>unimpairedTabLeft
nmap ]g <Plug>unimpairedTabRight
xmap [g <Plug>unimpairedTabLeft
xmap ]g <Plug>unimpairedTabRight

nnoremap <silent> <Plug>unimpairedTabFirst   :tabfirst<CR>
nnoremap <silent> <Plug>unimpairedTabLast    :tablast<CR>
xnoremap <silent> <Plug>unimpairedTabFirst   :tabfirst<CR>
xnoremap <silent> <Plug>unimpairedTabLast    :tablast<CR>

nmap [G <Plug>unimpairedTabFirst
nmap ]G <Plug>unimpairedTabLast
xmap [G <Plug>unimpairedTabFirst
xmap ]G <plug>unimpairedTabLast
" }}}

" }}}




" Text objects ------------------------------------------------------------ {{{

" }}}




" Mini-plugins ------------------------------------------------------------ {{{
command DiffOrig let g:diffline = line('.') | vert new | set bt=nofile | r # | 0d_ | diffthis | :exe "norm! ".g:diffline."G" | wincmd p | diffthis | wincmd p
nnoremap <Leader>do :DiffOrig<cr>
nnoremap <leader>dc :q<cr>:diffoff<cr>:exe "norm! ".g:diffline."G"<cr>
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
    set clipboard=unnamedplus
endif

" }}}
