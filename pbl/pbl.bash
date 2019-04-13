#!/bin/bash


# ----------------------------------------------------------------------------
# :author:     Mikael FLORA
# :maintainer: <https://github.com/mikaelflora/pblibraries/issues>
# :date:       2019-04-13
# :brief:      import all libraries
# ----------------------------------------------------------------------------


. checking.bash
. iniparsing.bash
. processing.bash
. logging.bash
. ui.bash


## exemples -->
#  if valid.IP? 192.168.1.10; then
#    echo "valid IPv4 address: 192.168.1.10"
#  fi
#  
#  syslog.error 'my test'
#  echo '/var/log/syslog:'
#  tail /var/log/syslog
## exemples <--
