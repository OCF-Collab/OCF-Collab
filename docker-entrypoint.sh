#!/bin/bash
set -e

bundle check || bundle install

rm -f /app/tmp/pids/server.pid

exec "$@"
