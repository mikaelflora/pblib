#!/bin/bash


# ----------------------------------------------------------------------------
# :author:  Mikael FLORA <mikaelflora@hotmail.com>
# :version: 0.1
# :date:    2016-06-12
# :brief:   import all libraries
# ----------------------------------------------------------------------------


. checking.bash
. iniparsing.bash
. logging.bash
. processing.bash
. syslogging.bash


if [ "${BASH_SOURCE##*/}" = "${0##*/}" ]; then
  if valid.IP? 192.168.1.10; then
    echo "valid IP 192.168.1.10"
  fi

  syslog.error "test"
  echo "/var/log/syslog:"
  tail /var/log/syslog
fi
