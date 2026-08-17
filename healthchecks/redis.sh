#!/bin/sh
set -eo pipefail

# Ping Redis directly on the local interface
if [ "$(redis-cli -h 127.0.0.1 ping)" = 'PONG' ]; then
        exit 0
fi

exit 1

