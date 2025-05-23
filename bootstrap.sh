#!/usr/bin/env bash
set -e

# Logging functions
function fail {
	printf "\033[1;39m[\033[31mFAIL\033[39m]\033[0m $1\n"
}

function info {
	printf "\033[1;39m[\033[34m !! \033[39m]\033[0m $1\n"
}

function success {
	printf "\033[1;39m[\033[32m OK \033[39m]\033[0m $1\n"
}

function user {
	printf "\033[1;39m[\033[33m ?? \033[39m]\033[0m $1\033[34m"
}

info "Configuring sudo access..."
sudo -v 2>/dev/null || {
	fail "Incorrect password."
	exit 1
}

info "Configuring credentials..."
user "Enter your name: "
read -r NAME
user "Enter your email: "
read -r EMAIL

if [[ -z "$NAME" || -z "$EMAIL" ]]; then
	fail "Name or email cannot be empty."
	exit 1
fi

SSH_KEY="$HOME/.ssh/id_ed25519"
info "Configuring SSH key..."

if [ -f "$SSH_KEY" ]; then
	success "SSH key already exists at \"$SSH_KEY\"."
else
	ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY" -N ""
	ssh-add "$SSH_KEY"
	success "SSH key generated in \"$SSH_KEY\"."
fi

pbcopy < "$SSH_KEY.pub"
info "Public SSH key copied to the clipboard."
info "Set the auth and sign SSH key in GitHub settings (https://github.com/settings/keys)."
user "Press any key when you've added the key...\n"
read -rsn 1

info "Installing dependencies..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
softwareupdate --install-rosetta --agree-to-license
success "Installed Homebrew package manager"

git clone https://github.com/DMoran28/dotfiles.git ~/.dotfiles
success "Cloned dotfiles repository"

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
[[ -e "$CONFIG" ]] && mv "$CONFIG" "$CONFIG.backup"
ln -s ~/.dotfiles "$CONFIG"
[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.backup
ln -s "$CONFIG/zsh/zshrc" ~/.zshrc
success "Created symbolic links"

eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off
brew bundle --file="$CONFIG/homebrew/brewfile"
success "Installed dependencies"

user "Do you want to add your git configuration? [Y/N]\n"
read -rsn 1 REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
	[[ -e "$HOME/.gitconfig" ]] && mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
	cp -a "$CONFIG/.gitconfig" ~/.gitconfig
	sed -i "" -e "s|<NAME>|$NAME|g" "$HOME/.gitconfig"
	sed -i "" -e "s|<EMAIL>|$EMAIL|g" "$HOME/.gitconfig"
	sed -i "" -e "s|<HOME>|$HOME|g" "$HOME/.gitconfig"
	success "Added git configuration"
else
	info "Skipped git configuration"
fi

chmod g-w /opt/homebrew/share
touch ~/.hushlogin
success "Setup completed 💻"
