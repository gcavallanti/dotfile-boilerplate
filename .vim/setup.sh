#! /bin/bash
# set -x

# Utility functions
function local_dir() {
    gitrepo="${1##*/}"
    echo "${gitrepo%.git}"
}

function get_git() {
    
    r=$(local_dir "$1")
    mv "${HOME}/.vim/tmp_bundle/$r" "${HOME}/.vim/bundle/"
    if cd "$r"; then git pull -q; cd .. ; else git clone -q "$1"; fi
}

function get_download() {
    mv "${HOME}/.vim/tmp_bundle/$r" "${HOME}/.vim/bundle/"
    #download
}

# Move current bundles and start a poor man's mark and sweep
mv "$HOME/.vim/bundle/$r" "$HOME/.vim/tmp_bundle/"

# Get pathogen
mkdir -p "${HOME}/.vim/autoload" "${HOME}/.vim/bundle"
curl -Sso "${HOME}/.vim/autoload/pathogen.vim" "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"

cd ~/.vim/bundle

# Get plugins
get_git "https://github.com/kien/ctrlp.vim.git"
get_git "https://github.com/davidhalter/jedi-vim.git"
(cd jedi-vim ; git submodule update --init )
get_git "https://github.com/scrooloose/syntastic.git"
get_git "https://github.com/majutsushi/tagbar.git"
get_git "https://github.com/marijnh/tern_for_vim.git"
(cd tern_for_vim ; npm install )
get_git "https://github.com/gcavn/trafficlights.git"
get_git "https://github.com/SirVer/ultisnips.git"
get_git "https://github.com/mbbill/undotree.git"
# get_git "https://github.com/tpope/vim-abolish.git"
get_git "https://github.com/tpope/vim-commentary.git"
# get_git "https://github.com/octol/vim-cpp-enhanced-highlight.git"
# get_git "https://github.com/hail2u/vim-css3-syntax.git"
get_get "https://github.com/godlygeek/tabular.git"
get_git "https://github.com/tpope/vim-fugitive.git"
# get_git "https://github.com/airblade/vim-gitgutter.git"
get_git "https://github.com/jamessan/vim-gnupg.git"
# get_git "https://github.com/pangloss/vim-javascript.git"
get_git "https://github.com/tpope/vim-markdown.git"
get_git "https://github.com/tpope/vim-repeat.git"
get_git "https://github.com/honza/vim-snippets.git"
get_git "https://github.com/tpope/vim-surround"
get_git "https://github.com/tpope/vim-unimpaired.git"
get_git "https://github.com/maxbrunsfeld/vim-yankstack.git"
get_git "https://github.com/gcavn/vimpos.git"

echo "Bundles downloaded. Check tmp_bundle/"
