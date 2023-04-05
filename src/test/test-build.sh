#!/bin/sh

. ./test-settings.sh

if [ -f "${is_license_xml}" ]; then
    echo "IS License file found, good."
else
    echo 1>&2 "IS License file not found: ${is_license_xml}"
    exit 101
fi
if [ -f "${ts_license_xml}" ]; then
    echo "Test suite License file found, good."
else
    echo 1>&2 "Test suit License file not found: ${ts_license_xml}"
    exit 102
fi
if [ -f "${um_license_xml}" ]; then
    echo "UM License file found, good."
else
    echo 1>&2 "UM License file not found: ${um_license_xml}"
    exit 103
fi
if [ "${empower_user_id}" = "" ]; then
    echo 1>&2 "Variable empower_user_id is missing, or empty."
    exit 104
fi
if [ "${empower_password}" = "" ]; then
    echo 1>&2 "Variable empower_password is missing, or empty."
    exit 105
fi

rm -rf docker/scripts docker/licenses
mkdir docker/licenses
cp "${is_license_xml}" docker/licenses/is-license.xml
cp "${ts_license_xml}" docker/licenses/ts-license.xml
cp "${um_license_xml}" docker/licenses/um-license.xml
cp -r ../main/resources/scripts docker/scripts

# Edit the settings.sh file to match the current build.
cat docker/scripts/settings.sh \
    | sed -e s,LICENSE_FILE_IS=\.\*,LICENSE_FILE_IS=/usr/local/install/licenses/is-license.xml, \
    | sed -e s,LICENSE_FILE_TS=\.\*,LICENSE_FILE_TS=/usr/local/install/licenses/ts-license.xml, \
    | sed -e s,LICENSE_FILE_UM=\.\*,LICENSE_FILE_UM=/usr/local/install/licenses/um-license.xml, \
    | sed -e s,EMPOWER_USERID=\.\*,EMPOWER_USERID=\'"${empower_user_id}"\', \
    | sed -e s,EMPOWER_PASSWORD=\.\*,EMPOWER_PASSWORD=\'"${empower_password}"\', >docker/scripts/settings.sh.new
diff -ub docker/scripts/settings.sh docker/scripts/settings.sh.new
mv docker/scripts/settings.sh.new docker/scripts/settings.sh

docker build --progress=plain ./docker
