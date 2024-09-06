#nix flake update --impure

#env http_proxy=http://127.0.0.1:9910 https_proxy=http://127.0.0.1:9910 nixos-rebuild --flake /etc/dotfiles#eniac --option pure-eval no switch --show-trace


export HEYENV="{\"user\":\"alienzj\",\"host\":\"eniac\",\"flake\":\"/etc/dotfiles\",\"theme\":\"autumnal\"}"

export http_proxy=http://127.0.0.1:9910
export https_proxy=http://127.0.0.1:9910

sudo --preserve-env=HEYENV \
	nixos-rebuild \
	  --show-trace \
	  --impure \
	  --flake .#eniac \
	  switch 
