#!/bin/sh

EXPECTED_SIGNATURE="$(curl https://composer.github.io/installer.sig)" 
php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" 
ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', '/tmp/composer-setup.php');")" 
  
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] 
then 
    >&2 echo 'ERROR: Invalid installer signature' 
    rm /tmp/composer-setup.php 
    exit 1 
fi 

# put composer into a directory in $PATH, so can call composer anywhere
# --install-dir => install in specific directory
# --filename => filename in target directory (default: composer.phar)
php /tmp/composer-setup.php --no-ansi --install-dir=/usr/bin --filename=composer \
 && rm /tmp/composer-setup.php \
 && composer --ansi --version --no-interaction