#!/bin/bash

set -e

/bin/mkdir -p /mnt/data/pgsql \
  && /bin/chown -R postgres:postgres /mnt/data/pgsql \
  && /usr/local/bin/gosu postgres bash -c "LANG=en_US.utf8 /usr/local/pgsql/bin/initdb -D /mnt/data/pgsql -E UTF8" \
  && /bin/cp /setup/pg_config/* /mnt/data/pgsql

if [ "$1" = 'postgres' ]; then
    exec gosu postgres /usr/local/pgsql/bin/postgres -D /mnt/data/pgsql
fi

exec "$@"
