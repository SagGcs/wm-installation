# Example of a local-settings.sh file:

# webMethods product, which is being installed. Identifies a subdirectory of
# "products". As of this writing, valid products are "isDevEdition" (default),
# and Tamino
WEBMETHODS_PRODUCT=isDevEdition
# webMethods version, which is being installed. As of this writing, supported versions are 10.5, 10.7,
# 10.11, and 10.15
WEBMETHODS_VERSION=10.5

# License file locations; required license files depend on the product.
# Product isDevEdition requires IS (Integration Server), UM (Universal Messaging), and TS (webMethods test suite)
# Product webMethods suite requires IS (Integration Server),
# UM (Universal Messaging), and TS (Test suite)
LICENSE_FILE_IS="/mnt/c/opt/wm/installation/installation/is-license.xml"
LICENSE_FILE_UM="/mnt/c/opt/wm/installation/installation/is-license.xml"
LICENSE_FILE_TS="/mnt/c/opt/wm/installation/installation/is-license.xml"
# Product Tamino requires TAM (Tamino Server)
LICENSE_FILE_TAM="/mnt/c/opt/wm/installation/installation/tam-license.xml"

# Empower user name, and password, for software download
EMPOWER_USERID="your.email@your.org"
EMPOWER_PASSWORD="InsertYourPasswordHere"

# User name of the "sag" user. Servers will be running under this user id.
ADMIN_USERID="sag"
# Primary group of the admin user. Servers will be using this as the primary group id.
ADMIN_GROUPID="sag"
# Password of the "sag" user, for use with "sudo".
ADMIN_PASSWORD="InsertYourPasswordHere"

# Sudo password of the user, who is running the install.sh script.
SUDO_PASSWORD="InsertYourPasswordHere"
SUDO_USERID="sag"
SUDO_GROUPID="sag"
