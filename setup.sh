#!/bin/bash

#__/\\\______________/\\\_____________________________        
# _\/\\\_____________\/\\\_____________________________       
#  _\/\\\_____________\/\\\_____________________________      
#   _\//\\\____/\\\____/\\\___/\\\____/\\\__/\\\\\\\\\\\_     
#    __\//\\\__/\\\\\__/\\\___\/\\\___\/\\\_\///////\\\/__    
#     ___\//\\\/\\\/\\\/\\\____\/\\\___\/\\\______/\\\/____   
#      ____\//\\\\\\//\\\\\_____\/\\\___\/\\\____/\\\/______  
#       _____\//\\\__\//\\\______\//\\\\\\\\\___/\\\\\\\\\\\_ 
#        ______\///____\///________\/////////___\///////////__
#

# This is my[1] setup script - it's heavily adapted to my usecases
# The code is CC0[2] so feel free to rework and reuse as you see fit.
# Extensively inspired and reworked from: https://github.com/nnja/new-computer

####################
# Helper functions #
####################

# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`

# Color-echo. Improved. [Thanks @joaocunha]
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}

cask_install() {
  while read -r PROGRAM
  do
    brew cask install "$PROGRAM"
  done
}

brew_install() {
  while read -r PROGRAM
  do
    brew install "$PROGRAM"
  done
}

dot() {
  src=$1
  dest=$2
  regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [[ $src =~ $regex ]]
  then
    curl -s "$src" > "$dest"
  else
    base=${3:-"git@github.com"}
    git clone "$base:$src" "$dest"
  fi
}

echo ""
cecho "###############################################" $red
cecho "#        THIS IS CURRENTLY ONLY FOR MAC       #" $red
cecho "#                                             #" $red
cecho "#---------------------------------------------#" $red
cecho "#                                             #" $red
cecho "#        DON'T RUN CODE YOU FIND ON THE       #" $red
cecho "#      INTERNET WITHOUT READING IT FIRST      #" $red
cecho "#        YOU'LL EVENTUALLY REGRET IT...       #" $red
cecho "#                                             #" $red
cecho "#---------------------------------------------#" $red
cecho "#                                             #" $red
cecho "#          READ THIS CODE THOROUGHLY          #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

# Set continue to false by default.
CONTINUE=false

echo ""
cecho "Have you read through the script you're about to run and " $blue
cecho "understood that it will make changes to your computer? (y/n)" $blue
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" $red
  exit
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##############################
# Prerequisite: Install Brew #
##############################

echo "Installing brew..."

# if test ! "$(command -v brew)"
# then
#   ## Don't prompt for confirmation when installing homebrew
#   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
# fi

# Update brew, install cask
# brew upgrade
# brew update
# brew tap caskroom/cask

#########################
# Install brew packages #
#########################

echo "Installing brew packages..."

# brew_install << EOF
#   ack
#   git
#   exa
#   hub
#   go
#   tree
#   coreutils
#   moreutils
#   findutils
#   gnu-sed
#   gnu-time
#   gnupg
#   grep
#   hyperfine
#   jq
#   rename
#   shellcheck
#   the_silver_searcher
#   thefuck
#   ssh-copy-id
#   tmux
#   tmuxinator
#   todo-txt
#   neovim
# EOF

#########################
# Install cask packages #
#########################

# echo "Installing cask packages..."

# cask_install << EOF
#   notion
#   docker
#   keybase
#   spotify
#   todotxt
#   visual-studio-code
#   bartender
#   firefox
#   tunnelblick
# EOF

####################
# Install dotfiles #
####################

# dot "https://setup.wuz.sh/hackerrank.txt" "$HOME/.hackerrank"
# dot "wuz/slack-workflows" "$HOME/workflows"
dot "~wuz/longhand" "$HOME/longhand" "git@git.sr.ht"

##############################
# Setup Keybase and GPG Keys #
##############################

echo "boom"
exit 0

# [1] - https://wuz.sh
# [2] - https://creativecommons.org/share-your-work/public-domain/cc0/
