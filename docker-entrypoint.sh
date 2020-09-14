#!/bin/bash
set -e

bundle check || bundle install
yarn install --check-files

rm -f /app/tmp/pids/server.pid

exec "$@"
