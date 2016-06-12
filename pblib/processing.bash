#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA <mikaelflora@hotmail.com>
# :version: 0.1.1
# :date:    2016-06-11
# :brief:   process manager
# ----------------------------------------------------------------------------


declare -A _PROCESSING=(
  [interval]="0.05"
)


process.init () {
# desc: initialize _PROCESSING array
# $*: level=7 facility=daemon tag=$0 pid=$$
  until [ -z "$1" ]; do
    [ ${_PROCESSING[${1%%=*}]+a} ] && _LOGGING[${1%%=*}]=${1##*=}
    shift
  done
}


process.timeout () {
# $1: timeout
# $@: command or function
# $?: 0, {1..126}, {129..}  (success command, command error code, kill command by timeout => 128 + signal code)
  timeout=$1

  shift

# execute command in background
  "${@}" & 2>/dev/null
  pid=$!

# execute killer in background
  ( sleep $timeout 2>/dev/null

    kill -0 $pid 2>/dev/null || return 0
    kill -s SIGTERM $pid 2>/dev/null || return 0
    sleep ${_PROCESSING[interval]} 2>/dev/null
    kill -0 $pid 2>/dev/null && kill -s SIGKILL $pid 2>/dev/null || return 0
  ) & 2>/dev/null
  pid_killer=$!

# get command return code
  wait $pid 2>/dev/null
  rc=$?

# kill killer
  kill $pid_killer 2>/dev/null

  return $rc
}


if [ "${BASH_SOURCE##*/}" = "${0##*/}" ]; then
  HW () {
    sleep 3
    echo "Hello World"
  }

  process.timeout 1 HW &
  HWPID1=$!
  process.timeout 5 HW &
  HWPID2=$!

  process.timeout 5 HW
  echo "HW return code (OK): $?"
  process.timeout 0.5 HW
  echo "HW return code (NOK): $?"

  wait $HWPID2 2>/dev/null
  echo "HW[$HWPID2] return code (OK): $?"
  wait $HWPID1 2>/dev/null
  echo "HW[$HWPID1] return code (NOK): $?"
fi
