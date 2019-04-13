#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA
# :date:    2019-04-13
# :brief:   basic logger system
# ----------------------------------------------------------------------------


# logging configuration -->
declare -A _LOGGING=(
  [level]=5
  [tag]=${0##*/}
  [pid]=${$}
  [file]="${0##*/}.log"
  [dateformat]="%Y-%m-%d %H:%M:%S"
  [dateoption]=""
)
# logging configuration <--


# debug function -->
debug? () {
# desc: IF debug mode AND $@ => execute command
#       IF debug mode => return 0
#       ELSE => return 1
# $@: command to execute in debug mode (optionnal)
# $?: 0 (debug mode) or 1
  if [ "${_LOGGING[level]}" -ge "7" ]; then
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


# logging functions -->
log.init () {
# desc: initialize _LOGGING array
# $*: level=7 facility=daemon tag=$0 pid=$$
  until [ -z "$1" ]; do
    [ ${_LOGGING[${1%%=*}]+a} ] && _LOGGING[${1%%=*}]=${1##*=}
    shift
  done
}

_log () {
# desc: logger wrapper
# $1: log level (integer)
# $2: log level (string)
# ${*:3}: log message
  if [ "$1" -le "${_LOGGING[level]}" ]; then
    echo `date ${_LOGGING[dateoption]} +"${_LOGGING[dateformat]}"`" $HOSTNAME ${_LOGGING[tag]}[${_LOGGING[pid]}]: <${2}> ${*:3}" >> ${_LOGGING[file]}
  fi
}

shopt -s expand_aliases

alias log.debug='_log 7 debug'
alias log.information='_log 6 info'
alias log.info='log.information'
alias log.notice='_log 5 notice'
alias log.warning='_log 4 warning'
alias log.warn='log.warning'
alias log.error='_log 3 err'
alias log.err='log.error'
alias log.critical='_log 2 crit'
alias log.crit='log.critical'
# logging functions <--


## examples -->
#  log.debug "foo (level=notice)"
#  log.warn "bar (level=notice)"
#  debug? echo "Hello World! (level=notice)"
#  
#  log.init level=7 dateoption="--utc" dateformat="%H:%M" tag=foo
#  
#  log.debug "foo (level=debug)"
#  log.warn "bar (level=debug)"
#  debug? echo "Hello World! (level=debug)"
## examples <--
