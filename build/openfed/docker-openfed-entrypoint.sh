#!/usr/bin/env bash

if ! [ -d docroot/ ]; then
    echo >&2 "OpenFed not found in $PWD - copying now..."
    if [ "$(ls -A)" ]; then
        echo >&2 "WARNING: $PWD is not empty"
        ( set -x; ls -A; sleep 10 )
    else
        tar cf - --one-file-system -C /usr/src/openfed . | tar xf -
        echo >&2 "Complete! OpenFed has been successfully copied to $PWD"
    fi
    
    cd docroot/
    
    if ! drush status bootstrap | grep -q Successful; then
        if [ -f sites/default/settings.php ]; then
            echo "Deleting old settings.."
            rm sites/default/settings.php  
        fi
        echo "Installing OpenFed.."
        
        until nc -z -v -w30 $DB_HOST 3306
        do
            echo "Waiting for database connection..."
            # wait for 5 seconds before check again
            sleep 5
        done

        drush site-install openfed -y --account-name=admin --account-pass=admin --uri="http://drupal.docker.localhost" --db-url="${DB_DRIVER}://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:3306/${DB_NAME}"
        echo "OpenFed installed successfully"
        echo "Uninstalling securelogin .."
        drush pm-uninstall securelogin -y
        drush cache-rebuild
    fi
fi
