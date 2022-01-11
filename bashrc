### EXPORT

export TERM "kitty"
export EDITOR="emacsclient -t -a ''"
export VISUAL="emacsclient -c -a emacs"
export BROWSER "firefox"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/Applications:$PATH"
fi
PATH="$~/.emacs.d/bin:$PATH"

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
alias pac='doas pacman'
alias pacsyu='sudo pacman -Syu'                 # update only standard pkgs
alias yaysyu='yay -Syu'              # update standard pkgs and AUR pkgs (yay)
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages
alias packagelist='sudo pacman -Qe > packages.txt'

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
