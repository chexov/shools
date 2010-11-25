#!/bin/bash

set -xue
otool -L "$1" | awk '/chexov/{print $1}' | while read line ;do install_name_tool -change $line "@loader_path/`basename $line`" "$1"  ;done
