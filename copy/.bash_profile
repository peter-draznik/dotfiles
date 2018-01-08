# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

[[ -s ~/.bin/z/z.sh ]] && . ~/.bin/z/z.sh

PATH="$HOME/.rbenv/bin:$PATH"
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

export PATH

[[ -s ~/.phpbrew/bashrc ]] && source $HOME/.phpbrew/bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if which rbenv > /dev/null; then
    eval "$(rbenv init -)";
fi

if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
fi
