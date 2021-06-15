#!/bin/bash

GLOBIGNORE=".:.."

# set up backup directory
backupDir="$HOME/.dotfiles_backup-$(date +'%s')"
mkdir "$backupDir" || exit 1

for cfgFile in *; do
  # skip dotfiles & install/bootstrap scripts
  [[ $cfgFile =~ (install.sh|bootstrap.sh|.git|.gitignore) ]] && continue

  # if dotfile exists in home dir, move it to backup folder
  [[ -f $HOME/.$cfgFile ]] && mv "$HOME/.$cfgFile" "$backupDir/$cfgFile"
  cp "$cfgFile" "$HOME/.$cfgFile" && printf "Copied ~/.%s\n" "$cfgFile"
done

printf -- "done -- original configs backed up to %s\n" "$backupDir"
