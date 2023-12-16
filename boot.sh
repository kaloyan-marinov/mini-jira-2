#!/bin/bash
# This script is used to boot the container with the web application.
source venv/bin/activate

while true; do
    python src/manage.py migrate
    if [[ "$?" == "0" ]]; then
        break
    fi
    echo Deploy command failed, retrying in 5 secs...
    sleep 5
done

exec gunicorn \
    -b :5000 \
    --access-logfile - \
    --error-logfile - \
    src.mini_jira_2.wsgi:application
