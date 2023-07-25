#!/bin/sh

# Make the script directory the current directory, so that relative paths are working.
cd $(dirname $BASH_SOURCE[0])

if test -f "./settings-local.sh"; then
    cp ./settings-local.sh ./docker/settings-local.sh
    . ./settings-local.sh
    cp "${LICENSE_FILE_IS}" ./docker/is-license.xml
    cp "${LICENSE_FILE_UM}" ./docker/um-license.xml
    cp "${LICENSE_FILE_TS}" ./docker/ts-license.xml
else
    echo 2>&1 "No local settings file found: ./settings-local.sh"
    exit 1
fi

docker build --progress=plain ./docker
