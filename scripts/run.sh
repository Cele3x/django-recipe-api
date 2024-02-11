#!/bin/sh

# Exit the script immediately if any command exits with a non-zero status.
set -e

# Wait for the database to be available before proceeding.
python manage.py wait_for_db

# Collect static files while preventing the command from prompting for confirmation.
python manage.py collectstatic --noinput

# Apply database migrations.
python manage.py migrate

# Start the uWSGI server for the Django recipe API.
# It binds the server to port 9000, uses 4 worker processes, enables threading,
# and loads the app.wsgi module as entrypoint.
uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi
