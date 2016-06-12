#!/bin/bash


[ "$EUID" -ne 0 ] && echo "Please run as root" && exit 1

echo "install file hierarchy"
mkdir -p /usr/local/lib/bash/
cp -r ${0%/*}/pblib/ /usr/local/lib/bash/
chmod 755 /usr/local/lib/bash/pblib/
chmod 444 /usr/local/lib/bash/pblib/*
echo "end of installation script"
