wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`

curl -L git.io/antigen > $HOME/antigen.zsh
source $HOME/antigen.zsh

