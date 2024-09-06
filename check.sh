export http_proxy=http://127.0.0.1:9910
export https_proxy=http://127.0.0.1:9910

export HEYENV="{\"user\":\"alienzj\",\"host\":\"eniac\",\"flake\":\"/etc/dotfiles\",\"theme\":\"autumnal\"}"

nix flake check \
	--impure \
	--no-warn-dirty \
	--no-use-registries \
	--no-write-lock-file \
	--no-update-lock-file \
	--show-trace \
	/etc/dotfiles
