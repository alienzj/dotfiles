alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'

alias q exit
alias clr clear
alias sudo 'sudo '
alias rm 'rm -i'
alias cp 'cp -i'
alias mv 'mv -i'
alias mkdir 'mkdir -pv'
alias wget 'wget -c'
#alias path 'echo -e ${PATH//:/\\n}'
alias ports 'netstat -tulanp'

alias mk make
alias gurl 'curl --compressed'

alias shutdown 'sudo shutdown'
alias reboot 'sudo reboot'

alias rcpd 'rcp --delete --delete-after'
alias rcpu 'rcp --chmod=go='
alias rcpdu 'rcpd --chmod=go='

alias y 'xclip -selection clipboard -in'
alias p 'xclip -selection clipboard -out'

alias jc 'journalctl -xe'
alias sc systemctl
alias ssc 'sudo systemctl'

alias eza 'eza --group-directories-first --git'
alias l 'eza -blF'
alias ll 'eza -abghilmu'
alias llm 'll --sort=modified'
alias la 'env LC_COLLATE=C eza -ablF'
alias tree 'eza --tree'
