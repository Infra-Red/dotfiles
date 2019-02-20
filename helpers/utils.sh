#!/usr/bin/env bash

# Checks if the current operating system is macOS
is_macos() {
  local platform
  platform="$(uname)"
  [ "$platform" == "Darwin" ]
}

# Checks if a command exists (in PATH and executable)
command_exists() {
  if command -v "$1" > /dev/null 2>&1; then
    exit 0
  else
    exit 1
  fi
}
