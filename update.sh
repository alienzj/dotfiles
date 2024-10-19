#export http_proxy=socks5h://192.168.50.125:2080
#export https_proxy=socks5h://192.168.50.125:2080

env ALL_PROXY=socks5h://192.168.50.125:2080 nix flake update --impure
