#!/bin/bash

set -o errexit
set -o nounset

watchfiles --filter python3.11 'celery -A main.celery worker --loglevel=info'
