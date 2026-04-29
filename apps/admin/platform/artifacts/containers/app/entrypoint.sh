#!/bin/sh
set -e

echo "Waiting for DB..."

for i in 1 2 3 4 5 6 7 8 9 10; do
  if bundle exec ruby -e "require 'sequel'; Sequel.connect(ENV.fetch('DATABASE_URL')).test_connection" >/dev/null 2>&1; then
    break
  fi
  sleep 1
  if [ "$i" = "10" ]; then
    echo "DB not ready"
    exit 1
  fi
done

bundle exec rails db:prepare

exec "$@"
