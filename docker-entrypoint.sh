#!/bin/bash

set -e

if [ "$1" = 'postgres' ]; then
    exec gosu postgres /usr/local/pgsql/bin/postgres -D /mnt/data/pgsql
fi

exec "$@"
