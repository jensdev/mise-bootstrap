# PATH and Environment Variables
fish_add_path $HOME/.local/bin
set -gx ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools

# Bun
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

# Aliases
alias c='clear'
alias pf='fastfetch'
alias ls='eza -lh --group-directories-first --icons=auto'
alias ll='eza -al --group-directories-first --icons=always'
alias lt='eza -a --tree --level=2 --icons=always'
alias ff='sudo fd -HI -a --exclude .snapshots'
alias is='fzf --preview="bat --style=numbers --color=always {}"'
alias nis='nvim (fzf --preview="bat --color=always {}")'

# Zoxide cd wrapper function (replicates zd in old zshrc)
function zd
    if test (count $argv) -eq 0
        builtin cd ~
    else if test -d $argv[1]
        builtin cd $argv[1]
    else
        z $argv
        and printf "\U000F17A9 "
        and pwd
    end
end
alias cd="zd"

# Shell integrations
if command -v starship >/dev/null
    starship init fish | source
end

if command -v zoxide >/dev/null
    zoxide init fish | source
end

if command -v fzf >/dev/null
    fzf --fish | source
end

if command -v mise >/dev/null
    mise activate fish | source
end

# Fastfetch on interactive terminal
if status is-interactive; and tty | string match -q '*pts*'
    fastfetch
end
