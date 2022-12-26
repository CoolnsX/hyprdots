#user-defined functions
gtp(){
    [ -z "$*" ] && commit=$(curl -s "https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt" | shuf -n1) || commit=$*
    git add -p
    git commit -m "$commit"
    git push
    unset commit
}

gtb () {
    [ -z "$*" ] && br=$(git branch -a | fzf --border=rounded --layout=reverse --height=10 | tr -d ' ') || br=$*
    [ -z "$br" ] || git checkout $br
    unset br
}

b64 () { printf "%s" "$1" | base64 $2; }
url() { curl -s https://0x0.st -F "file=@$*" | wl-copy && notify-send "Link copied to clipboard"; }

gtd () {
    [ -z "$*" ] && file=$(git diff --name-only | fzf --border=rounded --height=10 --layout=reverse | tr -d ' ') || file=$*
    [ -z "$file" ] || git diff --name-only --relative --diff-filter=d $file | xargs bat  --paging=never --diff
    unset file
}

gtc () { [ -z "$*" ] && [ -p "/dev/stdin" ] && read -r query </dev/stdin || query=$*; git clone "$query"; }

gtr () { [ -z "$*" ] && [ -p "/dev/stdin" ] && read -r query </dev/stdin || query=$*; curl -s "https://api.github.com/users/$query/repos" | sed -nE 's|.*ssh_url": "([^"]*)".*|\1|p' | fzf --border --height=10 --layout=reverse; }

gtu () { [ -z "$*" ] || curl -s "https://api.github.com/search/users?q=$*" | sed -nE 's_.*login": "([^"]*)".*_\1_p' | fzf --layout=reverse --border --height=10; }

clshist() {
    a=$(cat ~/.histfile | wc -l)
    [ "$a" -gt 201 ] && sed -i "1,$((a - 200))d" ~/.histfile
}

v() {
	[ -z "$*" ] && file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' -m) || file=$*
	nvim -O $file
}

help() {
	"$@" --help 2>&1 | bat -pp --language=help
}

addpkg(){
	paru -Ss "$*" | sed -nE 's|^[a-z]*/([^ ]*).*|\1|p' | fzf --preview 'paru -Si {} | bat --language=yaml --color=always -pp' --preview-window right:65%:wrap | paru -S -
}

rmpkg(){
	paru -Qs "$*" | sed -nE 's|^[a-z]*/([^ ]*).*|\1|p' | fzf --preview 'paru -Si {} | bat --language=yaml --color=always -pp' --preview-window right:65%:wrap | paru -Rcns -
}

# Lines configured by zsh-newuser-install
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
export OPENER="xdg-open"
export VIDEO="mpv"
export WM="hyprland"
export IMAGE="nsxiv"
alias cat="bat -pp"
alias anime="$HOME/lol/ani-cli"
alias cp="cp -v"
alias rm="rm -v"
alias mv="mv -v"
alias pgrep="pgrep -a"
alias grep="grep --color=auto"
alias ncdu="ncdu --color dark"
alias ll="ls --color=auto -alh"
alias ls="ls --color=auto"
alias fetch='/bin/*fetch'
alias nchh="nvim ~/.config/hypr/hyprland.conf"

clshist
HISTFILE=~/.histfile
HISTSIZE=200
SAVEHIST=200
setopt autocd
bindkey -e
zstyle :compinstall filename '/home/tanveer/.zshrc'
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
eval "$(starship init zsh)"
[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
