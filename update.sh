export http_proxy=http://127.0.0.1:9910
export https_proxy=http://127.0.0.1:9910

nix flake update --impure
