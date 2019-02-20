#!/usr/bin/env bash

set -euf -o pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"

# shellcheck source=../helpers/utils.sh
source "$root_dir/helpers/utils.sh"
# install homebrew
if ! is_macos -o ! command_exists ruby -o ! command_exists curl -o ! command_exists git; then
  echo "Skipped: missing ruby, curl and/or git"
  exit 1
fi

if ! (command -v brew >/dev/null); then
  echo "Downloading homebrew..."
  $(command -v ruby) -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed"
fi

echo "Updating homebrew..."
brew update

echo "Running brew bundle..."
brew bundle --no-upgrade --file=homebrew/Brewfile || true

echo "Upgrading packages.."
brew upgrade

echo "Cleaning up Homebrew installation..."
brew cleanup

exit 0
