mkdir -p ~/.vim/autoload ~/.vim/bundle;
curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/tpope/vim-sensible.git
git clone https://github.com/gcavn/trafficlights.git
git clone https://github.com/kien/ctrlp.vim.git
git clone https://github.com/jamessan/vim-gnupg.git
git clone https://github.com/AndrewRadev/linediff.vim.git
git clone https://github.com/kien/rainbow_parentheses.vim.git
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/godlygeek/tabular.git
git clone https://github.com/majutsushi/tagbar.git
git clone https://github.com/SirVer/ultisnips.git
git clone https://github.com/mbbill/undotree.git
git clone https://github.com/tpope/vim-abolish.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/Lokaltog/vim-easymotion.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/tpope/vim-repeat.git
git clone https://github.com/tpope/vim-sensible.git
git clone https://github.com/tpope/vim-unimpaired.git

git clone https://github.com/davidhalter/jedi-vim.git
cd jedi-vim
git submodule update --init
cd ..
