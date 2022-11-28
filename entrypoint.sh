#!/bin/bash
set -e

php artisan migrate --force && php artisan db:seed --force

exec docker-php-entrypoint apache2-foreground
