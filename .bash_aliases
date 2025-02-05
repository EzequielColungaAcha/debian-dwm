# File system
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ls='eza -lh --group-directories-first --icons'
alias lt='eza --tree --level=2 --long --icons --git'
alias lsa='ls -a'
alias lta='lt -a'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'

# Directories
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'

# Tools
alias n='nvim'
alias g='git'
alias d='docker'
alias r='rails'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='lazydocker'

# Git
alias gst='git status'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# alias for batcat
alias cat="batcat"

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# Convert webm files generated by the Gnome screenshot video recorder to mp4s that are more compatible
webm2mp4() {
  input_file="$1"
  output_file="${input_file%.webm}.mp4"
  ffmpeg -i "$input_file" -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k "$output_file"
}

# Copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls && pwd
	else
		builtin cd ~ && ls && pwd
	fi
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip ()
{
	# Internal IP Lookup.
	IP_ADDRESS=$(hostname -I | cut -d' ' -f1)
	IP_ADDRESS_CONFIRM=$(ip route get 1 | awk '{print $(NF-2);exit}')
	if [ "$IP_ADDRESS" == "$IP_ADDRESS_CONFIRM" ]; then
		echo -n "Internal IP: "
		$IP_ADDRESS
	else
		echo -n "Can't get Internal IP "
	fi

	# External IP Lookup
	echo -n "External IP: "
	curl -s ifconfig.me
}

# GitHub Titus Additions
gcom() {
	git add .
	git commit -m "$1"
}
lazyg() {
	git add .
	git commit -m "$1"
	git push
}

# Ctrl+f to zi
bind '"\C-f":"zi\n"'


alias hma='hasura migrate apply'
alias hsa='hasura seed apply'
alias hmta='hasura metadata apply'
alias hmtr='hasura metadata reload'
