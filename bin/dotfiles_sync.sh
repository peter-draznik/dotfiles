#!/usr/bin/env bash

e_header "Syncing dotfiles bin"

if [[ ! -d ~/.bin ]]; then
  new_dotfiles_install=1
fi

read -p "Overwrite existing .bin? [following install may break if not](y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Nn]$ ]]; then
  e_header "Skipped ~/.bin overwrite"
else
  rsync -av \
    --exclude ".git/" --exclude ".DS_Store" \
    --exclude "dotfiles.sh" --exclude "dotfiles_requirements.sh" \
    --exclude "dotfiles_functions.sh" --exclude "dotfiles_sync.sh" \
    --exclude "init" --exclude "copy" --exclude "tmp" \
    --exclude "README.md" "$PWATH/.." ~

  if [[ "$new_dotfiles_install" != 1 ]]; then
    e_header "Removing old bin"
    rm -rf ~/.bin
  fi

  mv ~/bin ~/.bin

  e_success "Updated dotfiles bin"
fi
