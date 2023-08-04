#!/bin/bash
set -e

# Log a message
echo "Starting the initialization script."

# check if the 'course' table exists
TABLE_EXISTS=$(psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE  table_schema = 'public' AND table_name = 'course');")

# Log the result of the check
echo "Does the 'course' table exist? $TABLE_EXISTS"

# if the 'course' table does not exist, run the init.sql script
if [ "$TABLE_EXISTS" = ' f' ]; then
  echo "The 'course' table does not exist. Running the init.sql script."
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -a -f /docker-entrypoint-initdb.d/init.sql
  echo "Finished running the init.sql script."
else
  echo "The 'course' table exists. No need to run the init.sql script."
fi

echo "Finished the initialization script."
