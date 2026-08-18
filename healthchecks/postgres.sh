#!/bin/bash
set -eo pipefail

# Fallback defaults if variables are missing
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$POSTGRES_USER}"

# Check readiness locally using pg_isready (fast and doesn't require network binding)
if pg_isready --username="$user" --dbname="$db"; then
        exit 0
fi

exit 1

