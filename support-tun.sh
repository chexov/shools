#!/bin/sh
set -ue

[ $# -eq 4 ] || { echo "Usage: <lockfile.pid> <user@remote.host> <local port (service to tunnel)> <remote port>"; exit 1; }
pid=$1
server=$2
localport=$3
serverport=$4

# check if lockfile has running process in it. exit if already running
test -s $pid && kill -0 `<$pid` 2>/dev/null && exit 0

# lock with new PID
echo $$ > "$pid"

# open SSH port tunneling
ssh -R ${serverport}:localhost:${localport} \
    -2 -N -T -o ExitOnForwardFailure=yes \
    -o StrictHostKeyChecking=no \
    -o BatchMode=yes \
    ${server}

