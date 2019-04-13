# pblibraries

## Synopsis

Personal Bash libraries:  

  - **checking.bash**: check syntax (IPv4 and MAC addresses)
  - **iniparsing.bash**: handling file configuration (INI file)
  - **logging.bash**: basic logger
  - **syslogging.bash**: syslogger (logger wrapper)
  - **processing.bash**: manage jobs
  - **ui.bash**: user interface functions

## Getting started

### Installation

```bash
./setup install
```

### Usage

In your source code:  

```bash
#!/bin/bash

# import library path:
PATH=${PATH}:/usr/local/lib/bash/pbl

# Use a specific library:
. logging.bash

# Or all libraries (except logging):
. pbl.bash
```

## License

GNU General Public License v3 (GPL-3). See `LICENSE` for further details.

