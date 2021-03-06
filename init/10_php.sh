#!/usr/bin/env bash

declare default_php=7.2.1
declare php_versions=(
  "$default_php"
  5.5.16
)

function get_php_versions() {
  local installed=()
  local v
  for path in "$HOME/.phpbrew/php/"*; do
    if [ `expr "${path##*/}" : "php-[0-9]*\.[0-9]*\.[0-9]*$"` != 0 ]; then
      if [ -d "$path" ]; then
        v="${path##*/}"
        installed=("${installed[@]}" "${v:4}")
      fi
    fi
  done
  echo "${installed[*]}"
}

function phpbrew_deps_install() {
    # Ubuntu only
  if [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
    e_header "Ubuntu Phpbrew deps"
    sudo apt-get build-dep php7
    sudo apt-get install -y php7 php7-dev php-pear \
      autoconf automake bison libbz2-dev \
      libxslt1-dev re2c libxml2 libxml2-dev php7-cli
    # +gd +openssl +gettext +mhash +mcrypt +icu
    sudo apt-get install -y libfreetype6 libfreetype6-dev \
      libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev \
      libjpeg8 libgd-dev libgd3 libxpm4
    sudo apt-get install -y libssl-dev openssl
    sudo apt-get install -y gettext libgettextpo-dev libgettextpo0
    sudo apt-get install -y libicu48 libicu-dev
    sudo apt-get install -y libmhash-dev libmhash2
    sudo apt-get install -y libmcrypt-dev libmcrypt4
    # mysql
    sudo apt-get install mysql-server mysql-client \
      libmysqlclient-dev libmysqld-dev
    # postgresql
#    sudo apt-get install postgresql postgresql-client \
#      postgresql-contrib
  fi
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    e_header "OSX Phpbrew deps"
    brew install automake autoconf curl pcre re2c mhash libtool icu4c gettext jpeg libxml2 mcrypt gmp libevent
    brew link icu4c
  fi
}

e_header "Installing Phpbrew"
if [[ ! "$(type -P phpbrew)" ]]; then
  phpbrew_deps_install
  curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
  if [[ -s phpbrew ]]; then
    chmod +x phpbrew
    sudo mv phpbrew /usr/local/bin/phpbrew
    [[ "$(type -P phpbrew)" ]] && phpbrew init
    [[ -s ~/.phpbrew/bashrc ]] && . ~/.phpbrew/bashrc
  fi
  if [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
    phpbrew lookup-prefix ubuntu
  else
    phpbrew lookup-prefix homebrew
  fi
  e_success "Installed Phpbrew"
else
  e_header "Phpbew already installed :)"
fi

e_header "Installing Php"
if [[ "$(type -P phpbrew)" ]]; then
  for v in $(to_install "${php_versions[*]}" "$(get_php_versions)"); do
    phpbrew install "${v}" +default
  done
  phpbrew switch "${default_php}"
  if [[ ! "$(type -P composer)" ]]; then
    e_header "Installing Composer"
    phpbrew install-composer
  fi
else
  e_error "Phpbrew was not installed correctly :/"
  return 1
fi

e_success "Phpbrew, PHP and Composer setup :)"
# if [[ -s ~/.bin/composer.phar ]] && [[ "$(type -P php)" ]]; then
#   curl -sS https://getcomposer.org/installer | php -- --install-dir=~/.bin
# fi
