#!/usr/bin/env bash

function e_header() { echo -e "\n\033[1m$@\033[0m"; }
function e_success() { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error() { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow() { echo -e " \033[1;33m➜\033[0m  $@"; }

function init_run() {
    source "$2"
}

function copy_do() {
    e_header "Copying ~/$1."
    cp "$2" ~/
    e_success "Copied $1"
}

function run_directory() {
    local base dest
    local files=(~/.dotfiles/$1/*)
    
    if (( ${#files[@]} == 0 )); then return; fi
    
    # display any header
    # [[ $(declare -f "$1_header") ]] && "$1_header"

    for file in "${files[@]}"; do
        base="$(basename $file)"
        dest="$HOME/$base"
        echo $file

        [[ $(declare -f "$1_run") ]] && "$1_run" "$base" "$file"
    done
}