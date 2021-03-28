#!/bin/bash

backupDir=~/.dotfiles_backup-$(date +'%s')
configFiles=("zshrc" "bashrc" "vimrc" "tmux.conf" "screenrc")

printf -- "-- backing up any pre-existing configs to %s\n" "$backupDir"
mkdir $backupDir || exit 1
for cfgFile in ${cfgFiles[@]}; do
  [[ -e ~/.$cfgFile ]] && mv ~/.$cfgFile $backupDir/$cfgFile
done

echo "-- copying configs to home directory"
for cfgFile in ${cfgFiles[@]};do cp $cfgFile ~;done
