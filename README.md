# pblib

## Synopsis

Personal Bash libraries:
  - **checking.bash**: check syntax
  - **iniparsing.bash**: handling file configuration (INI file)
  - **logging.bash**: basic logger
  - **syslogging.bash**: syslogger (logger wrapper)
  - **processing.bash**: manage jobs

## Installation

Get source code and install:
```bash
git clone https://github.com/mikaelflora/pblib.git
./pblib/install.bash
```

## Getting started

In your source code:
```bash
#!/bin/bash

# import library path:
PATH=${PATH}:/usr/local/lib/bash/pblib

# Use a specific library:
. logging.bash

# Or all libraries:
. pblib.bash
```

## License

GNU General Public License v3 (GPL-3). See `LICENSE` for further details.

