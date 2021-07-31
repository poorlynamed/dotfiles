#!/bin/bash

GLOBIGNORE=".:.."

# set up backup directory
backupDir="$HOME/.dotfiles_backup-$(date +'%s')"
mkdir "$backupDir" || exit 1

for cfgFile in *; do
  # populate neovim init file since it's just pointed to ~/.vimrc anyway
  mkdir -p "$HOME/.config/nvim"
  echo 'set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc' > "$HOME/.config/nvim/init.vim"

  # skip dotfiles & install/bootstrap scripts
  [[ $cfgFile =~ (install.sh|bootstrap.sh|.git|.gitignore) ]] && continue

  # if dotfile exists in home dir, move it to backup folder
  if [[ $OSTYPE =~ "darwin"* ]] && [[ $cfgFile =~ bashrc ]]; then
    [[ -f $HOME/.bash_profile ]] && mv "$HOME/.bash_profile" "$backupDir/bash_profile"
  else
    [[ -f $HOME/.$cfgFile ]] && mv "$HOME/.$cfgFile" "$backupDir/$cfgFile"
  fi

  if [[ $OSTYPE =~ "darwin"* ]] && [[ $cfgFile =~ bashrc ]]; then
    cp "$cfgFile" "$HOME/.bash_profile" && printf "Copied ~/.%s\n" "bash_profile"
  else
    cp "$cfgFile" "$HOME/.$cfgFile" && printf "Copied ~/.%s\n" "$cfgFile"
  fi
done

printf -- "done -- original configs backed up to %s\n" "$backupDir"
