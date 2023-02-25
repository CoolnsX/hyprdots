#user-defined functions
gtp(){
    [ -z "$*" ] && commit=$(curl -s "https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt" | shuf -n1) || commit=$*
    git add -p
    git commit -m "$commit"
    git push
    unset commit
}

megamind() {
	printf "———————————%s———————————
⠀⣞⢽⢪⢣⢣⢣⢫⡺⡵⣝⡮⣗⢷⢽⢽⢽⣮⡷⡽⣜⣜⢮⢺⣜⢷⢽⢝⡽⣝
⠸⡸⠜⠕⠕⠁⢁⢇⢏⢽⢺⣪⡳⡝⣎⣏⢯⢞⡿⣟⣷⣳⢯⡷⣽⢽⢯⣳⣫⠇
⠀⠀⢀⢀⢄⢬⢪⡪⡎⣆⡈⠚⠜⠕⠇⠗⠝⢕⢯⢫⣞⣯⣿⣻⡽⣏⢗⣗⠏⠀
⠀⠪⡪⡪⣪⢪⢺⢸⢢⢓⢆⢤⢀⠀⠀⠀⠀⠈⢊⢞⡾⣿⡯⣏⢮⠷⠁⠀⠀
⠀⠀⠀⠈⠊⠆⡃⠕⢕⢇⢇⢇⢇⢇⢏⢎⢎⢆⢄⠀⢑⣽⣿⢝⠲⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⡿⠂⠠⠀⡇⢇⠕⢈⣀⠀⠁⠡⠣⡣⡫⣂⣿⠯⢪⠰⠂⠀⠀⠀⠀
⠀⠀⠀⠀⡦⡙⡂⢀⢤⢣⠣⡈⣾⡃⠠⠄⠀⡄⢱⣌⣶⢏⢊⠂⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢝⡲⣜⡮⡏⢎⢌⢂⠙⠢⠐⢀⢘⢵⣽⣿⡿⠁⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠨⣺⡺⡕⡕⡱⡑⡆⡕⡅⡕⡜⡼⢽⡻⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⣳⣫⣾⣵⣗⡵⡱⡡⢣⢑⢕⢜⢕⡝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣴⣿⣾⣿⣿⣿⡿⡽⡑⢌⠪⡢⡣⣣⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⡟⡾⣿⢿⢿⢵⣽⣾⣼⣘⢸⢸⣞⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠁⠇⠡⠩⡫⢿⣝⡻⡮⣒⢽⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
———————————————————————————————\n" "$*"
}
gtb () {
    [ -z "$*" ] && br=$(git branch -a | fzf --border=rounded --layout=reverse --height=10 | tr -d ' ') || br=$*
    [ -z "$br" ] || git checkout $br
    unset br
}

b64 () { printf "%s" "$1" | base64 $2; }

url() {
	[ -z "$2" ] && duration="1440" || duration=$2
	out=$(curl https://oshi.at -F shorturl=0 -F "f=@$1" -F "expire=$duration") #1440 means 1 day duration
	[ -z "$out" ] && return 1
	printf "%s" "$out" | sed -nE 's|DL: (.*)|\1|p' | wl-copy && notify-send "Link copied to clipboard";
	wl-paste
	#storing only long duration links
	[ -z "$2" ] && printf "%s\n%s" "$out" "$(date '+%s')" | tr '\n' '>' | sed 's/>/ | /g' >> $HOME/.cache/oshi-urls

	#deleting file uploaded than 1 day ago
	for i in $(cut -d'|' -f3 $HOME/.cache/oshi-urls | tr -d ' ');do 
		curr=$(date '+%s')
		[ "$((curr - i))" -gt "86400" ] && sed -i "/$i/d" $HOME/.cache/oshi-urls &
	done
	echo >> $HOME/.cache/oshi-urls
}

gtd () {
    preview="git diff $@ --color=always -- {-1}"
    git diff $@ --name-only --relative | fzf --ansi --preview $preview --preview-window right:65%:wrap -0
    unset preview
}

gtc () { [ -z "$*" ] && [ -p "/dev/stdin" ] && read -r query </dev/stdin || query=$*; git clone "$query"; }

gtr () { [ -z "$*" ] && [ -p "/dev/stdin" ] && read -r query </dev/stdin || query=$*; curl -s "https://api.github.com/users/$query/repos" | sed -nE 's|.*ssh_url": "([^"]*)".*|\1|p' | fzf --border --height=10 --layout=reverse -0; }

gtu () { [ -z "$*" ] || curl -s "https://api.github.com/search/users?q=$*" | sed -nE 's_.*login": "([^"]*)".*_\1_p' | fzf --layout=reverse --border --height=10 -0; }

clshist() {
    a=$(cat ~/.histfile | wc -l)
    [ "$a" -gt 301 ] && sed -i "1,$((a - 300))d" ~/.histfile
}

v() {
	[ -z "$*" ] && nvim -O $(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' -m | tr '\n' ' ') || nvim -O $*
}

translate () {
    curl -s "https://www.google.com/async/translate?vet=12ahUKEwjelf-f06v8AhUKzjgGHVe0CBkQqDh6BAgFECw..i&ei=8kC0Y97UDIqc4-EP1-iiyAE&yv=3&cs=0" -X POST -d "async=translate,sl:auto,tl:$1,st:$(jq -Rr '@uri' <<< $2),id:1672757511748,qc:true,ac:true,_id:tw-async-translate,_pms:s,_fmt:pc" -H "content-type:application/x-www-form-urlencoded;charset=UTF-8" | sed -nE 's|.*target-text">([^<]*)<.*romanization">([^<]*)<.*roman.*|translated : \1\nroman : \2|p'
}

help() {
	"$@" --help 2>&1 | bat --plain --language=help
}

addpkg(){
	[ -z "$*" ] && printf "\033[1;31mPlease write the name of package (just some words)..\033[0m" && return 1
	paru -Ss "$*" | sed -nE 's|^[a-z]*/([^ ]*).*|\1|p' | fzf --preview 'paru -Si {} | bat --language=yaml --color=always -pp' --preview-window right:65%:wrap -m | paru -S -
}

rmpkg(){
	paru -Qq | fzf --preview 'paru -Si {} | bat --language=yaml --color=always -pp' --preview-window right:65%:wrap -m | paru -Rcns -
}

# Lines configured by zsh-newuser-install
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export VISUAL="nvim"
export TERMINAL="foot"
export OPENER="xdg-open"
export VIDEO="mpv"
export WM="hyprland"
export IMAGE="nsxiv"
alias cat="bat -pp"
alias open="xdg-open"
alias anime="$HOME/ani-cli/ani-cli"
alias cp="cp -v"
alias art="php artisan"
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
PROMPT_EOL_MARK=' ⏎ '
setopt autocd
bindkey -e
zstyle :compinstall filename '/home/tanveer/.zshrc'
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
eval "$(starship init zsh)"
[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
