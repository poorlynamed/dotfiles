#!/bin/bash

backupDir=~/.dotfiles_backup-$(date +'%s')
mkdir $backupDir || exit 1

for cfgFile in $(ls -ap | grep -Ev '/|^\.|install.sh|bootstrap.sh'); do
  [[ -e ~/.$cfgFile ]] && mv ~/.$cfgFile $backupDir/$cfgFile
  cp $cfgFile ~/.$cfgfile
done

printf -- "done -- original configs backed up to %s\n" "$backupDir"
