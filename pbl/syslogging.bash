#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA
# :date:    2019-04-13
# :brief:   logging functions for syslog (a kind of logger wrapper)
# ----------------------------------------------------------------------------


# syslogging configuration -->
declare -A _SYSLOGGING=(
  [level]=5
  [facility]="daemon"
  [tag]=${0##*/}
  [pid]=${$}
)
# syslogging configuration <--


# debug function -->
debug? () {
# desc: IF debug mode AND $@ => execute command
#       IF debug mode => return 0
#       ELSE => return 1
# $@: command to execute in debug mode (optionnal)
# $?: 0 (debug mode) or 1
  if [ "${_SYSLOGGING[level]}" -ge "7" ]; then
    if [ -n "${#}" ]; then
      "${@}"
    else
      return 0
    fi
  else
    return 1
  fi
}
# debug function <--


# syslogging functions -->
syslog.init () {
# desc: initialize _SYSLOGGING array
# $*: level=7 facility=daemon tag=$0 pid=$$
  until [ -z "$1" ]; do
    [ ${_SYSLOGGING[${1%%=*}]+a} ] && _SYSLOGGING[${1%%=*}]=${1##*=}
    shift
  done
}

_syslog () {
# desc: logger wrapper
# $1: log level (integer)
# $2: log level (string)
# ${*:3}: log message
  if [ "$1" -le "${_SYSLOGGING[level]}" ]; then
    logger -p ${_SYSLOGGING[facility]}.${2} -t "${_SYSLOGGING[tag]}[${_SYSLOGGING[pid]}]" "<${2}> ${*:3}"
  fi
}

shopt -s expand_aliases

alias syslog.debug='_syslog 7 debug'
alias syslog.information='_syslog 6 info'
alias syslog.info='syslog.information'
alias syslog.notice='_syslog 5 notice'
alias syslog.warning='_syslog 4 warning'
alias syslog.warn='syslog.warning'
alias syslog.error='_syslog 3 err'
alias syslog.err='syslog.error'
alias syslog.critical='_syslog 2 crit'
alias syslog.crit='syslog.critical'
# syslogging functions <--


## examples -->
#  
#  syslog.debug "foo (level=notice)"
#  syslog.warn "bar (level=notice)"
#  debug? echo "Hello World! (level=notice)"
#  
#  syslog.init level=7  # change level to debug
#  
#  syslog.debug "foo (level=debug)"
#  syslog.warn "bar (level=debug)"
#  debug? echo "Hello World! (level=debug)"
#  
#  echo "check with following command: 'tail /var/log/syslog'"
#  
## examples <--
