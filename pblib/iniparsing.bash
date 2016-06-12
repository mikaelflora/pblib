#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA <mikaelflora@hotmail.com>
# :version: 0.1.1
# :date:    2016-06-11
# :brief:   config parser (ini file) with associative array
# :TODO:    code review ini.common.to.Array and ini.to.Array
# ----------------------------------------------------------------------------



ini.common.to.Array () {
# desc: load from (no section) config file to associative array
# $1: file to parse
# $2: associative array name to use
  while read line; do
    if [[ $line == ?*"="?* ]]; then
      key=$(echo "${line%%=*}" | sed 's/[ \t]*//g')
        value=$(echo "${line##*=}" | sed 's/^[ \t]*//;s/[ \t]*$//')
        tmp=${2}[${key}]
        if [ ${!tmp+a} ]; then
          eval ${2}[\${key}]=\${value}
        fi  
        unset key value tmp
    fi
  done < <(sed -e '/\[.*\]/,$d' ${1} | sed "s#;.*##g")
}


ini.to.Array () {
# desc: load from section config file to associative array
# $1: file to parse
# $2: associative array name to use
# [$3: section to load]
  ini.common.to.Array $1 $2

  [ -z $3 ] && section=$2 || section=$3

  if [ -f ${1} ]; then
    while read line; do
      if [[ $line == ?*"="?* ]]; then
        key=$(echo "${line%%=*}" | sed 's/[ \t]*//g')
        value=$(echo "${line##*=}" | sed 's/^[ \t]*//;s/[ \t]*$//')
        tmp=${2}[${key}]
        if [ ${!tmp+a} ]; then
          eval ${2}[\${key}]=\${value}
        fi
        unset key value tmp
      fi
    done < <(sed -n "/\[[ \t]*${section}[ \t]*\]/{:a;n;/^$/b;p;ba}" ${1} | sed "s#;.*##g")
  fi
}


ini.to.Arrays () {
# desc: load config from sections in file to associative arrays
# $1: file to parse 
# ${*:2}: sections / associative arrays to load / use
  for section in ${*:2}; do
    ini.to.Array $1 ${section}
  done
}


print.Array () {
# desc: print associative array as inifile section
# $1: associative array name to print
# [$2: as section name]
  [ -z $2 ] && section=$1 || section=$2
  echo "[${section}]"

  eval keys=\${!${1}[@]}
  for key in ${keys}; do
    value=${1}[${key}]
    echo "${key}=${!value}"
  done

  echo ""
}


print.Arrays () {
# desc: print associative arrays as inifile sections
# $*: sections / associative arrays to load / use
  for section in ${*}; do
    print.Array ${section}
  done
}


Array.to.ini () {
# desc: write inifile (from associative array to inifile)
# $1: file
# $2: associative array name to parse
# [$3: as section name]
  [ -z $3 ] && section=$2 || section=$3

  print.Array $2 $section >> $1
}


Arrays.to.ini () {
# desc: write inifile (from associative arrays to inifile)
# $1: file
# ${*:2}: associative array names to parse
  for array in ${*:2}; do
    print.Array $array $array >> $1
  done
}


shopt -s expand_aliases

alias iniparse.load='ini.to.Arrays'
alias iniparse.print='print.Arrays'
alias iniparse.write='Arrays.to.ini'
alias iniparse.load.as='ini.to.Array'
alias iniparse.print.as='print.Array'
alias iniparse.write.as='Array.to.ini'


if [ "${BASH_SOURCE##*/}" = "${0##*/}" ]; then
  declare -A CONFIG=(
    [f]="foo"
    [b]="bar"
  )

  declare -A CONF=(
    [a]="bar"
    [b]="foo"
  )

  echo "print associative arrays:"
  iniparse.print CONF CONFIG
  echo "write test.conf,"
  iniparse.write test.conf CONF CONFIG
  echo "and cat test.conf:"
  cat test.conf
  echo "unset CONF[b],"
#  unset CONF[b]
  echo "modify CONFIG[b]=Hello World,"
  CONFIG[b]="Hello World"
  echo "and print associative arrays:"
  iniparse.print CONF CONFIG
  echo "load test.conf in associative arrays,"
  iniparse.load test.conf CONF CONFIG
  echo "and print associative arrays:"
  iniparse.print CONF CONFIG
  echo "rm test.conf"
  rm test.conf
fi
