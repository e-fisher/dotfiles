#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

# Include files names starting with dot
shopt -s dotglob
shopt -s extglob

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in !(.|..|.git|.gitmodules|install.sh|README.md); do
    mv ~/$file $olddir/
    echo "== creating symlink $dir/$file ~/$file"
    ln -sT $dir/$file ~/$file
done

# symlink nvim config
ln -s ~/.vimrc ~/.config/nvim/init.vim
