syn on
set ai et ts=4
set number
set mouse=a
set ttymouse=xterm2


set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'Vundle/Vundle.vim'

Plugin 'altercation/vim-colors-solarized.git'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-sensible.git'

call vundle#end()

filetype plugin indent on
colorscheme solarized

