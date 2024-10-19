#!/usr/bin/env zsh
# Deploy and install this nixos system.

export http_proxy=http://127.0.0.1:9910
export https_proxy=http://127.0.0.1:9910

export HEYENV="{\"user\":\"alienzj\",\"host\":\"eniac\",\"path\":\"/etc/dotfiles\",\"theme\":\"autumnal\"}"

nixos-install \
    --impure \
    --show-trace \
    --root "/mnt" \
    --flake "/etc/dotfiles#eniac"
