# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if [ -e /usr/share/terminfo/x/xterm+256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi
