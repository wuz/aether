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
reset=$(tput sgr0)

show_spinner()
{
  local -r pid="${1}"
  local -r delay='0.5'
  SYMBOLS='⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷'
  SPINNER_PPID=$(ps -p "${pid}" -o ppid=)
  while ps a | awk '{print $1}' | grep -q "${pid}"; do
    tput civis
    for c in ${SYMBOLS}; do
      local COLOR
      COLOR=$(tput setaf 5)
      tput sc
      env printf "${COLOR}${c}${SPINNER_NORMAL}"
      tput rc
      env sleep .2
      if [ ! -z "$SPINNER_PPID" ]; then
        SPINNER_PARENTUP=$(ps $SPINNER_PPID)
        if [ -z "$SPINNER_PARENTUP" ]; then
          break 2
        fi
      fi
    done
  done
  tput cnorm
}

spinner() {
  ("$@") &
  show_spinner "$!"
}

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
    if [ -n "$PROGRAM" ]; then
      [[ "$PROGRAM" =~ ^#.*$ ]] && continue
      spinner brew cask install "$PROGRAM"
    fi
  done
}

brew_install() {
  while read -r PROGRAM
  do
    if [ -n "$PROGRAM" ]; then
      [[ "$PROGRAM" =~ ^#.*$ ]] && continue
      spinner brew install "$PROGRAM"
    fi
  done
}

dot() {
  src=$1
  dest=$2
  args=$3
  regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [[ $src =~ $regex ]]
  then
    curl -s "$src" > "$dest"
  else
    base=${3:-"git@github.com"}
    git clone "$base:$src" "$dest" "$args"
  fi
}

#echo ""
#cecho "###############################################" "$red"
#cecho "#        THIS IS CURRENTLY ONLY FOR MAC       #" "$red"
#cecho "#                                             #" "$red"
#cecho "#---------------------------------------------#" "$red"
#cecho "#                                             #" "$red"
#cecho "#        DON'T RUN CODE YOU FIND ON THE       #" "$red"
#cecho "#      INTERNET WITHOUT READING IT FIRST      #" "$red"
#cecho "#        YOU'LL EVENTUALLY REGRET IT...       #" "$red"
#cecho "#                                             #" "$red"
#cecho "#---------------------------------------------#" "$red"
#cecho "#                                             #" "$red"
#cecho "#          READ THIS CODE THOROUGHLY          #" "$red"
#cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" "$red"
#cecho "###############################################" "$red"
#echo ""

## Set continue to false by default.
#CONTINUE=false

#echo ""
#cecho "Have you read through the script you're about to run and " "$blue"
#cecho "understood that it will make changes to your computer? (y/n)" "$blue"
#read -r response
#if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
#  CONTINUE=true
#fi

#if ! $CONTINUE; then
#  # Check if we're continuing and output a message if not
#  cecho "Please go read the script, it only takes a few minutes" "$red"
#  exit
#fi

## Here we go.. ask for the administrator password upfront and run a
## keep-alive to update existing `sudo` time stamp until script has finished
#sudo -v
#while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##############################
# Prerequisite: Install Brew #
##############################

echo "Installing brew..."

if test ! "$(command -v brew)"
then
  ## Don't prompt for confirmation when installing homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
fi

# Update brew, install cask
echo "Updating/Upgrading Brew"
spinner brew upgrade 
spinner brew update 
spinne brew tap homebrew/cask-cask

#########################
# Install brew packages #
#########################

echo "Installing brew packages..."

brew_install << EOF

  # Base tools
  git
  git-lfs
  git-delta
  tmux
  tmuxinator
  ssh-copy-id
  neovim
  wget
  gnupg
  shellcheck
  todo-txt
  thefuck
  fzf

  # Linux-style tools
  coreutils
  moreutils
  findutils
  gnu-sed
  gnu-time
  tree
  rename

  # Upgraded system tools
  ripgrep
  hub
  hyperfine
  exa
  jq

  # Languages
  go
  python
  pyenv

EOF

#########################
# Install cask packages #
#########################

echo "Installing cask packages..."

spinner cask_install << EOF

  # Productivity
  notion
  spotify
  todotxt
  firefox
  muzzle
  alfred

  # Development
  docker
  visual-studio-code

  # System Tools
  keybase
  bartender
  tunnelblick
  rectangle
  owncloud
  karabiner-elements

  # Quicklook plugins
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
  epubquicklook
  quicklook-csv

  # Work Tools
  slack
  zoomus

EOF

####################
# Install dotfiles # 
####################

spinner mkdir -p "$HOME/.config/nvim"
spinner dot "~wuz/.files" "$HOME/.files"

######################
# Install asdf + langs
######################

dot asdf-vm/asdf.git "$HOME/.asdf" "--branch v0.7.7"

######################
# Install Python Tools
######################

echo "Installing global Python packages..."

pip3 install --upgrade pip
pip3 install --user pylint
pip3 install --user flake8

################
# MacOS settings
################

# Allow cmd+Q to quit Finder
defaults write com.apple.finder QuitMenuItem -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Only Show Open Applications In The Dock  
defaults write com.apple.dock static-only -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Menu bar: hide the Time Machine, User icons, but show the volume Icon.
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Use function F1, F, etc keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true


# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to a Screenshots folder
mkdir "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Hide Spotlight tray-icon (and subsequent helper)
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Load new settings before rebuilding the index
killall mds

# Stop iTunes from responding to the keyboard media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

##############################
# Setup Keybase and GPG Keys #
##############################

###########
# Setup Vim
###########

# Install dien
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein

vim +"call :dein#install()" +qall

echo ""
cecho "Boom! All done!" "$cyan"
echo ""
echo ""
cecho "################################################################################" "$white"
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." "$red"
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read -r response
if [ "$response" != "${response#[Yy]}" ] ;then
    softwareupdate -i -a --restart
fi
exit 0

# [1] - https://wuz.sh
# [2] - https://creativecommons.org/share-your-work/public-domain/cc0/
