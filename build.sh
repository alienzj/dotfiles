export HEYENV="{\"user\":\"alienzj\",\"host\":\"eniac\",\"theme\":\"autumnal\",\"path\":\"/etc/dotfiles\", \"http_proxy\":\"socks5h://192.168.50.125:2080\", \"https_proxy\":\"socks5h://192.168.50.125:2080\"}"

export http_proxy=socks5h://192.168.50.125:2080
export https_proxy=socks5h://192.168.50.125:2080

sudo --preserve-env=HEYENV http_proxy=socks5h://192.168.50.125:2080 https_proxy=socks5h://192.168.50.125:2080 \
	nixos-rebuild \
	--impure \
	--flake .#eniac \
	switch
