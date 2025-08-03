# Environment
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.ghcup/bin
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER less
#set -x MANPAGER nvim +Man!
set -x MOZ_ENABLE_WAYLAND 1


# Greeting
function fish_greeting
    echo Time: (set_color yellow; LC_TIME=en_US.UTF-8 date +"%A %d.%m.%Y %T"; set_color normal)
end

# Custom commands
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias ls="ls -lh --time-style=long-iso --color=always"
