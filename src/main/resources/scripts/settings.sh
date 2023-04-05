# In what follows, use /mnt/c as a prefix for the Windows drive C:
# In other words, if a path refers to /mnt/c/opt/wm/installation/is-license.xml, then that would actually be the
# file C:\opt\wm\installation\is-license.xml.
#
# On a related note, keep in mind that the syntax rules of a Bash script apply here. In other words, the
# backslash is the escape character, and you need to use replace backslash characters with \\.
#
# When editing this file, it is typically sufficient, to consider the following variables:
#   WEBMETHODS_VERSION
#   LICENSE_FILE_IS
#   LICENSE_FILE_UM
#   LICENSE_FILE_TS
#   EMPOWER_USERID
#   EMPOWER_PASSWORD
#   ADMIN_PASSWORD
# All other variables should be fine.

# webMethods version, which is being installed. As of this writing, supported versions are 10.5, 10.7,
# 10.11, and 10.15
WEBMETHODS_VERSION=10.5
# Target installation directory. We recommend not to change this.
WEBMETHODS_HOME_DIR="/opt/wm/${WEBMETHODS_VERSION}"
# Temporary directory for installation files
WEBMETHODS_INSTALLATION_FILES_DIR="/opt/wm/installation"

# License file locations; required icense files are IS (Integration Server), UM (Universal Messaging),
# and TS (webMethods test suite)
LICENSE_FILE_IS="/tmp/wm-inst/is-license.xml"
LICENSE_FILE_UM="/tmp/wm-inst/um-license.xml"
LICENSE_FILE_TS="/tmp/wm-inst/ts-license.xml"

# Empower user name, and password, for software download
EMPOWER_USERID="jwi@softwareag.com"
EMPOWER_PASSWORD="ReplaceMeWithTheRealPassword"

# User name of the "sag" user. IS, and UM will be running under this user id.
ADMIN_USERID="sag"
# Primary group of the "sag" user. IS, and UM will be using this as the primary group id.
ADMIN_GROUPID="sag"
# Password of the "sag" user, for use with "sudo".
ADMIN_PASSWORD="manage"

# SAG Installer URL. Leave this, as it is, unless you need a different webMethods version
SAG_INSTALLER_VERSION="20221103"
SAG_INSTALLER_URL="https://empowersdc.softwareag.com/ccinstallers/SoftwareAGInstaller${SAG_INSTALLER_VERSION}-Linux_x86_64.bin"
