#!/bin/bash

set -xue
install_name_tool -id "@loader_path/lib/`basename $1`" "$1"
otool -L "$1" | awk '/local/{print $1}' | while read line ;do install_name_tool -change $line "@loader_path/../lib/`basename $line`" "$1"  ;done
