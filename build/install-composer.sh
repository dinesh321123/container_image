#!/bin/sh

# COMPOSER_VERSION is set in the Dockerfile

EXPECTED_SIGNATURE="$(curl https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

# Install both composer 1 and 2 under their own paths to support future
# conditional scripting
php composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer1-bin --1
php composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer2-bin --2

# Install a default composer in the standard location, set version in Dockerfile or with --build-arg
php composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --${COMPOSER_VERSION}

RESULT=$?
rm composer-setup.php
exit $RESULT
