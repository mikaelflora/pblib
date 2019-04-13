#!/bin/bash


# ----------------------------------------------------------------------------
# :author: Mikael FLORA
# :date:   2019-04-13
# :brief:  user interface functions
# ----------------------------------------------------------------------------


# ui functions -->
ui.pause () {
# desc: waiting for user input
  read -n1 -s -p 'Press any key to continue ...'
  echo ''
}

ui.continue () {
# desc: continue or exit program (default 'continue')
  while read -n1 -s -p 'Continue? [Y/n] '; do
    case ${REPLY:-y} in
      y|Y) echo 'y' && break  ;;
      n|N) echo 'n' && exit 0 ;;
      *)   echo -e '\nWhat?'  ;;
    esac
  done
}

ui.quit () {
# desc: exit or continue program (default 'exit')
  while read -n1 -s -p 'Quit? [Y/n] '; do
    case ${REPLY:-y} in
      y|Y) echo 'y' && exit 0 ;;
      n|N) echo 'n' && break  ;;
      *)   echo -e "\nWhat?"  ;;
    esac
  done
}

ui.yes () {
# desc: ask a question (default answer 'yes')
# $*: question (string)
# $?: 0 (yes) or 1 (no)
  while read -n1 -s -p "${*} [Y/n] "; do
    case ${REPLY:-y} in
      y|Y) echo 'y' && return 0 ;;
      n|N) echo 'n' && return 1 ;;
      *)   echo -e '\nWhat?'  ;;
    esac
  done
}

ui.no () {
# desc: ask a question (default answer 'no')
# $*: question (string)
# $?: 0 (yes) or 1 (no)
  while read -n1 -s -p "${*} [N/y] "; do
    case ${REPLY:-n} in
      y|Y) echo 'y' && return 0 ;;
      n|N) echo 'n' && return 1 ;;
      *)   echo -e '\nWhat?'  ;;
    esac
  done
}

ui.debug () {
# $*: debug message (optional string)
# $?: 0 (debug) or 1
  if [ $debug ]; then
    [ "${*}" ] && echo "D: ${*}"
    return 0
  fi
  return 1
}
# ui functions <--


## examples ->
#  
#  ui.continue
#  
#  debug=true
#  
#  if ui.debug; then
#    echo "debug tasks"
#  fi
#  
#  if ui.yes 'Do you want install components?'; then
#    echo "apt-get install -y components"
#  fi
#  
## examples <--
