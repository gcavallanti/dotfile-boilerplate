# set -x

# Utility functions
function local_dir() {
    gitrepo="${1##*/}"
    echo "${gitrepo%.git}"
}

function get_git() {
    
    echo "$FUNCNAME $1"
    ldir=$(local_dir "$1")
    mv "$tmp_bundle_dir/$ldir" "$bundle_dir/" 2> /dev/null
    if cd "$ldir"; then git pull -q ; cd .. ; else git clone -q "$1"; fi
}

function get_download() {

    echo "$FUNCNAME $1"
    mv "$tmp_bundle_dir/$ldir" "$bundle_dir/" 2> /dev/null

    #download
}

bundle_dir="$HOME/.vim/bundle"
tmp_bundle_dir="$HOME/.vim/tmp_bundle"

# Initiate a poor man's mark and sweep
[[ -d  "$tmp_bundle_dir" ]] && { echo "$tmp_bundle_dir already exists!" ; exit 1; }
mv "$bundle_dir" "$tmp_bundle_dir"


# Install pathogen
mkdir -p "${HOME}/.vim/autoload" "$bundle_dir"
curl -LSso "${HOME}/.vim/autoload/pathogen.vim" "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"

# Get plugins
cd "$bundle_dir"

# Get matchit
rm -rf "$tmp_bundle_dir/matchit"
VIMRUNTIME=`vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015' `
mkdir -p matchit/plugin matchit/doc
cp "$VIMRUNTIME/macros/matchit.vim" matchit/plugin
cp "$VIMRUNTIME/macros/matchit.txt" matchit/doc

# Get other plugins
get_git "https://github.com/kien/ctrlp.vim.git"
get_git "https://github.com/davidhalter/jedi-vim.git"
(cd jedi-vim ; git submodule update --init )
# get_git "https://github.com/scrooloose/syntastic.git"
get_git "https://github.com/majutsushi/tagbar.git"
get_git "https://github.com/marijnh/tern_for_vim.git"
(cd tern_for_vim ; npm install )
# get_git "https://github.com/gcavallanti/trafficlights.git"
get_git "https://github.com/gcavallanti/plain.git"
get_git "https://github.com/SirVer/ultisnips.git"
get_git "https://github.com/mbbill/undotree.git"
get_git "https://github.com/gummesson/note.vim.git"
# get_git "https://github.com/tpope/vim-abolish.git"
get_git "https://github.com/tpope/vim-commentary.git"
# get_git "https://github.com/octol/vim-cpp-enhanced-highlight.git"
# get_git "https://github.com/hail2u/vim-css3-syntax.git"
get_git "https://github.com/godlygeek/tabular.git"
get_git "https://github.com/tpope/vim-fugitive.git"
get_git "https://github.com/airblade/vim-gitgutter.git"
get_git "https://github.com/jamessan/vim-gnupg.git"
# get_git "https://github.com/pangloss/vim-javascript.git"
get_git "https://github.com/tpope/vim-markdown.git"
get_git "https://github.com/tpope/vim-repeat.git"
get_git "https://github.com/honza/vim-snippets.git"
get_git "https://github.com/tpope/vim-surround"
get_git "https://github.com/tpope/vim-unimpaired.git"
# get_git "https://github.com/maxbrunsfeld/vim-yankstack.git"
get_git "https://github.com/gcavallanti/vim-noscrollbar.git"

echo "Bundles downloaded."
rmdir "$tmp_bundle_dir" 
