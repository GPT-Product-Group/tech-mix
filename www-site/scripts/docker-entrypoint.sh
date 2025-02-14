#!/bin/sh

# Wait for database to be ready
echo "Waiting for database to be ready..."
/app/wait-for-it.sh db:5432 -t 60

# Run database migrations
echo "Running database migrations..."
pnpm db:migrate

# Seed the database if SEED_DATABASE is set to true
if [ "$SEED_DATABASE" = "true" ]; then
  echo "Seeding database..."
  pnpm db:seed
fi

# Start the application
echo "Starting the application..."
exec node node_modules/.bin/next start 