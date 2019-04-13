#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA
# :date:    2019-04-13
# :brief:   config parser (ini file) with associative array
# :TODO:    code review
# ----------------------------------------------------------------------------


# iniparsing functions -->
ini.common.to.Array.key () {
# desc: load key's value from config gile section to key associative array
# $1: file to parse
# $2: associtive array name to use
# $3: section to load
# $4: key to get
  tmp=${2}[${4}]
  if [ ! ${!tmp+a} ]; then
    return 1
  fi
  unset tmp

  while read line; do
    if [[ $line == ?*"="* ]]; then
      key=$(echo "${line%%=*}" | sed 's/[ \t]*//g')
      if [ "$4" = "$key" ]; then
        value=$(echo "${line##*=}" | sed 's/^[ \t]*//;s/[ \t]*$//')
        tmp=${2}[${key}]
        if [ ${!tmp+a} ]; then
          eval ${2}[\${key}]=\${value}
        fi  
        unset value tmp
      fi
      unset key
    fi  
  done < <(sed -e '/\[.*\]/,$d' ${1} | sed "s#;.*##g")
  unset tmp key value
}

ini.to.Array.key () {
# desc: load key's value from config gile section to key associative array
# $1: file to parse
# $2: associtive array name to use
# $3: section to load
# $4: key to get value
  tmp=${2}[${4}]
  if [ ! ${!tmp+a} ]; then
    return 1
  fi
  unset tmp

  ini.common.to.Array.key $1 $2 $3 $4

  while read line; do
    if [[ $line == ?*"="* ]]; then
      key=$(echo "${line%%=*}" | sed 's/[ \t]*//g')
      if [ "$4" = "$key" ]; then
        value=$(echo "${line##*=}" | sed 's/^[ \t]*//;s/[ \t]*$//')
        tmp=${2}[${key}]
        if [ ${!tmp+a} ]; then
          eval ${2}[\${key}]=\${value}
        fi  
        unset value tmp
      fi
      unset key
    fi  
  done < <(sed -n "/\[[ \t]*${section}[ \t]*\]/{:a;n;/^$/b;p;ba}" ${1} | sed "s#;.*##g")
  unset tmp key value
}

ini.to.Array.keys () {
# desc: load config from sections in file to associative arrays
# $1: file to parse 
# $2: sections / associative arrays to load / use
# ${*:3}: keys to get values
  for key in ${*:3}; do
    ini.to.Array $1 $2 $2 ${key}
  done
}

ini.common.to.Array () {
# desc: load from (no section) config file to associative array
# $1: file to parse
# $2: associative array name to use
  while read line; do
    if [[ $line == ?*"="* ]]; then
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
      if [[ $line == ?*"="* ]]; then
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
alias iniparse.get.key='ini.to.Array.key'
alias iniparse.get.keys='ini.to.Array.keys'
# iniparsing functions <--


## examples -->
#  declare -A CONF=(
#    [b]="bar"
#    [f]=""
#  )
#  
#  echo "print associative array:"
#  iniparse.print CONF
#  echo "write test.conf and cat test.conf:"
#  iniparse.write test.conf CONF
#  cat test.conf
#  echo "unset CONF[b] and print associative array:"
#  unset CONF[b]
#  iniparse.print CONF
#  echo "load test.conf in associative array,"
#  iniparse.load test.conf CONF
#  echo "and print associative array:"
#  iniparse.print CONF
#  echo "rm test.conf"
#  rm test.conf
## examples <--
