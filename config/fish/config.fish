if status is-interactive
    # Commands to run in interactive sessions can go here
end

### Path ###

# ~/.config/fish/config.fish
export PATH="$HOME/.config/rofi/modules/rofi-keepassxc:$PATH"
export PATH="$HOME/.config/rofi/modules/rofi-firefox:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths

### Exports ###
set -g fish_greeting
set TERM "kitty"
set EDITOR "emacsclient -t -a ''"
set VISUAL "emacsclient -c -a emacs"
set BROWSER "firefox"

### Eye candy ###
starship init fish | source
# set theme_color_scheme dracula
# set theme_color_scheme nord
# set theme_color_scheme gruvbox
set theme_color_scheme # catppuccin
pfetch
# rxfetch
# treefetch
# figlet gay rights | gay -l

### Aliases ###

## Terminal
alias :q='exit'

## Root priviledges
alias sudo='doas'

## Monitors
alias mboth='fish ~/.screenlayout/benq-samsung.sh'

## Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

## pacman and yay
alias pac='doas pacman -S'
alias pacr='doas pacman -R'
#alias yay='yay -S'
#alias yayr='yay -R'
alias pacsyu='sudo pacman -Syu'                 # update only standard pkgs
alias yaysyu='yay -Syu'              # update standard pkgs and AUR pkgs (yay)
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages
alias packagelist='sudo pacman -Qq > packages.txt'

## get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

## Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

## Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

## Emacs
alias em='emacsclient -nw'
alias emacs='/usr/bin/emacs --daemon &'
alias doom='~/.emacs.d/bin/doom sync'

## Weather
alias wpl='curl wttr.in/pleszew'
alias wpo='curl wttr.in/poznan'
alias wv='curl wttr.in/irvine'

## Coronavirus stats
alias cpl='corona poland'

## Programs
alias grubreload='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias music='ncmpcpp'
alias mixer='ncpamixer'
alias adblock='doas /usr/local/bin/hblock'
alias bt='bpytop'
alias wall='~/Obrazy/styli.sh/styli.sh'
alias ratesx='curl rate.sx'
alias mcfc='doas soccer --team=MCFC --upcoming'
alias covidpl='corona poland'
