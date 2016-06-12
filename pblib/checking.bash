#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA <mikaelflora@hotmail.com>
# :version: 0.1
# :date:    2016-06-12
# :brief:   check syntax
# ----------------------------------------------------------------------------


valid.MAC? () {
# desc:
# $1: MAC address
# $?: 0 (valid) or 1 (invalid)
  [[ "$1" =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]] && return 0 || return 1
}


invalid.MAC? () {
# desc:
# $1: MAC address
# $?: 0 (invalid) or 1 (valid)
  [[ "$1" =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]] && return 1 || return 0
}


valid.IP? () {
# desc:
# $1: IP address
# $?: 0 (valid) or 1 (invalid)
  rx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
  [[ "$1" =~ ^$rx\.$rx\.$rx\.$rx$ ]] && return 0 || return 1
}


invalid.IP? () {
# desc:
# $1: IP address
# $?: 0 (invalid) or 1 (valid)
  rx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
  [[ "$1" =~ ^$rx\.$rx\.$rx\.$rx$ ]] && return 1 || return 0
}


if [ "${BASH_SOURCE##*/}" = "${0##*/}" ]; then
  mac="13:9E:EF:9C:00:AB"
  ip="192.168.100.254"


  if valid.MAC? ${mac}; then
    echo "valid MAC address: $mac"
  else
    echo "invalid MAC address: $mac"
  fi

  if invalid.IP? ${ip}; then
    echo "invalid IP address: $ip"
  else
    echo "valid IP address: $ip"
  fi
fi
