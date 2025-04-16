#!/bin/bash

set -e
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "🔐 Please enter your password to continue:"
sudo -v

echo "🍺 Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
softwareupdate --install-rosetta --agree-to-license

echo "📦 Cloning dotfiles repository..."
git clone https://github.com/DMoran28/dotfiles.git ~/.dotfiles

echo "🔗 Setting up symbolic links..."
[[ -e "$CONFIG_DIR" ]] && mv "$CONFIG_DIR" "$CONFIG_DIR.backup"
ln -s ~/.dotfiles "$CONFIG_DIR"

[[ -e ~/.zshenv ]] && mv ~/.zshenv ~/.zshenv.backup
ln -s "$CONFIG_DIR/zsh/zshenv" ~/.zshenv

[[ -e ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.backup
ln -s "$CONFIG_DIR/zsh/zshrc" ~/.zshrc

echo "🧰 Installing dependencies..."
eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off
brew bundle --file="$CONFIG_DIR/homebrew/brewfile"

echo "🛠️ Finalizing configuration..."
chmod g-w /opt/homebrew/share
touch ~/.hushlogin

echo "💻 Setup complete!"
