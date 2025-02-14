#!/bin/sh
# wait-for-it.sh

set -e

host="$1"
shift
cmd="$@"

until nc -z "$host" "${port:-5432}"; do
  echo "Waiting for ${host}:${port:-5432}..."
  sleep 1
done

echo "${host}:${port:-5432} is available" 