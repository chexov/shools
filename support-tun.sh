#!/bin/sh
set -ue

[ $# -ge 2 ] || { echo "Usage: <host> <port> [<localport>]"; exit 1; }
host=$1
port=$2
localport=${3:-22}
name=support-$host-$port-$localport

# if file does not exist returns 1
# if pid specified in file is running returns 0
# if pid is not running returns 2
isRunningFromPidFile() {
    local pidfile="$1"
    [ ! -f "$pidfile" ] && return 1
    local pid=`cat "$pidfile" | tr -C -d '[0-9]'`
    [ -z "$pid" ] && return 1
    local psout=`ps -p $pid | wc -l`
    [ $psout -le 1 ] && return 2
    return 0
}

tryLock() {
    local pidfile="$1"
    isRunningFromPidFile $pidfile && return 1
    echo $$ >$pidfile
    return 0
}


tryLock /tmp/${name}.pid || exit 0

while true; do
    ssh -R localhost:${port}:localhost:${localport} \
        -N -T -o ExitOnForwardFailure=yes \
        -o StrictHostKeyChecking=no \
        -v ${host}; sleep 3; date;
done

