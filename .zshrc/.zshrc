# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
  
## ENV
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export PATH=$HOME/.local/share/containers/podman-desktop/extensions-storage/podman-desktop.compose/bin:$HOME/bin:/usr/local/bin:$HOME/go/bin:$HOME/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
export MAKEFLAGS="-j$(nproc)"
export ZSH="/usr/share/oh-my-zsh"
export GIT_EDITOR=vim
export QT_QPA_PLATFORMTHEME=gtk2
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8a008e'
export MAKEFLAGS=-j12
export EDITOR=vim

## p10k theme
source ~/.p10k.zsh

## Plugins
plugins=(
	git
  fzf
)

## Load plugins installed through AUR
source /usr/share/zsh/plugins/fzf-tab-bin-git/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

## Source rest of ZSH
source $ZSH/oh-my-zsh.sh

## Custom Widgets
_custom-autosuggest(){
  echo "trigger func" >> ~/.widgets-debug.log
  echo "c: $CURSOR b: $#BUFFER"  >> ~/.widgets-debug.log
  echo "b: $BUFFER p: $POSTDISPLAY"   >> ~/.widgets-debug.log
  echo "$IS_SUGGESTION_AVAILABLE" >> ~/.widgets-debug.log
  if $IS_SUGGESTION_AVAILABLE; then
    echo "word" >> ~/.widgets-debug.log
    zle forward-word
  else
    echo "char" >> ~/.widgets-debug.log
    zle forward-char
  fi
}

## autocompletions
autoload -U +X bashcompinit && bashcompinit
source <(kubectl completion zsh)
complete -F __start_kubectl k
complete <(kind completion zsh)
complete -o nospace -C /usr/bin/mcli mcli
command -v flux >/dev/null && . <(flux completion zsh)
source $HOME/.config/kind_completion
eval "$(direnv hook zsh)"

## Aliases
alias hwm="watch -n 1 sensors"
alias killff="ps -ax | grep firefox | awk '{print \$5}' | head -1 | xargs killall"
alias k=kubectl
alias vim=nvim

## custom functions
kwatchpod() {
  if [[ -n $2 ]];
    time=$1
  then
	  time=1
  fi
  if [[ -n $1 ]];
	  watch -n $time "kubectl -n $1 get pods -o wide"
  then
	  echo "need a namespace"
  fi
}

unzip-folder() {
  ZIPFILE=`readlink -f $1`
  FNAME=`ls $1 | awk -v FS="/" '{print $NF}' | awk -v FS="." '{$NF=""; print $0}' | xargs`
  echo "Location: $ZIPFILE"
  echo "Folder Name: $FNAME"
  mkdir "$FNAME"
  cd "$(pwd)/$FNAME"
  unzip $ZIPFILE
  cd ..
}

decode64() {
  echo `wl-paste` | base64 -d
}

kgetnodes (){
  echo -e "Control Planes"
  kubectl get nodes --selector node-role.kubernetes.io/control-plane= -o wide
  echo -e "\n\nWorker Nodes"
  kubectl get nodes --selector node-role.kubernetes.io/worker=worker -o wide
}

BAU_QT_NEU_DU_HUND() {
  rm -rf "$HOME/.cache/paru/clone/qt6gtk2"
  rm -rf "$HOME/.cache/paru/clone/qt5-styleplugins"
  paru -S --noconfirm qt6gtk2 qt5-styleplugins
}

killlike () {
  ps -ax | grep "$@" | grep -iv grep | tac | awk '{print $1}' | xargs -L1 kill -9
}

fuck() {
  sudo "${!:0}"
}

schau() {
  watch -n1 "${!:0}"
}

scanmulti() {
#    set -x

    #SCANNER='pixma:03A91913_565811'
    SCANNER='escl:https://192.168.178.221:443'
    printf "Name of the File (default is a randome name): "
    read FNAME
    tmpdir=$(mktemp -d)
    trap "rm -rf $tmpdir" EXIT

    count=1
    while true; do
      scanimage --device-name="$SCANNER" --mode gray --format=jpeg --resolution=600 -x 210 -y 297 --output="$tmpdir/$count.jpeg"
      printf "Scan more pages? (Y/n): "
      read answer
      if [ "$answer" = "n" ]; then
          break
      fi
      count="$((count + 1))"
    done

    echo "Converting scans to pdf..."
    convert "$tmpdir/*.jpeg" "$tmpdir/out.pdf"
    echo "Compressing pdf..."
    RNAME="scan_out_$(date +%Y-%m-%d--%H-%M).pdf"
    GNAME="${FNAME:-$RNAME}"
    NAME="$HOME/$GNAME"
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$NAME" "$tmpdir/out.pdf"
    echo "Saved in $NAME"
    xdg-open "$NAME"
}


