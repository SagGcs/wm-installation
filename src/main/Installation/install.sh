#!/bin/sh -e
#
# webMethods automated installation.
#
#

# Make the script directory the current directory, so that relative paths are working.
cd $(dirname $BASH_SOURCE[0])

# Read the settings files.
. ./settings.sh
if test -f ./settings-local.sh; then
    . ./settings-local.sh
else
    echo 2>&1 "The file ./settings-local.sh is not present. Please copy settings-local-sample.sh"
    echo 2>&1 "to settings-local.sh, make the necessary adjustments, and rerun this script,"
    echo 2>&1 $BASH_SOURCE[0] "."
    exit 1
fi

# Validate the settings.
function assertVariablesGiven() {
    if test -z "$1"; then
       echo 2>&1 "Usage: assertVariablesGiven VARIABLE_NAME"
       exit 2
    else
	   for var in $1; do
	       v=""
	       eval "v=\$$var"
	       if test -z "$v"; then
               echo 2>&1 "The environment variable variable $var is not set,"
	           echo 2>&1 "or empty."
               echo 2>&1 "Please supply a valid value, and rerun this script."
               exit 3
	       fi
	       if test "$v" = "InsertYourPasswordHere"; then
	           echo 2>&1 "The environment variable $var is not set."
               echo 2>&1 "Please supply a valid value, and rerun this script."
               exit 3
           fi
        done
    fi
}

assertVariablesGiven "WEBMETHODS_PRODUCT WEBMETHODS_VERSION WEBMETHODS_HOME_DIR SUDO_USERID SUDO_GROUPID SUDO_PASSWORD"

product_dir="./products/$WEBMETHODS_PRODUCT"
product_settings_file="${product_dir}/settings.sh"
if test -d "${product_dir}" -a -f "${product_settings_file}"; then
   echo "Reading product specific settings from ${product_settings_file}".
   . "${product_settings_file}"
else
   echo 2>&1 "The webMethods product ($WEBMETHODS_PRODUCT) is invalid. Possible reasons:"
   echo 2>&1 "  1. The product directory does not exist, or is not a directory: ${product_dir}"
   echo 2>&1 "  2. The product settings file does not exist, or is not a file: ${product_settings_file}"
   exit 4 
fi

inst_image_src_script="${product_dir}/${WEBMETHODS_VERSION}/image.sh"
inst_install_src_script="${product_dir}/${WEBMETHODS_VERSION}/install.sh"
if ! test -f "${inst_image_src_script}"; then
   echo 2>&1 "The webMethods version \(${WEBMETHODS_VERSION}\) is invalid. Possible reasons:"
   echo 2>&1 " 1. The SAG installers image script does not exist, or is not a file: ${inst_image_src_script}"
   echo 2>&1 " 1. The SAG installers installation script does not exist, or is not a file: ${inst_install_src_script}"
   exit 5
fi
if test -f "${product_dir}/${WEBMETHODS_VERSION}/settings.sh"; then
    echo "Reading version specific settings from ${product_dir}/${WEBMETHODS_VERSION}/settings.sh."
    . "${product_dir}/${WEBMETHODS_VERSION}/settings.sh"
else
    echo "No version specific settings \(file ${product_dir}/${WEBMETHODS_VERSION}/settings.sh\) found."
fi

wm_home_dir="${WEBMETHODS_HOME_DIR}"
if test -z "${WEBMETHODS_INSTALLATION_FILES_DIR}"; then
    wm_inst_dir="${WEBMETHODS_HOME_DIR}/installation"
else
    wm_inst_dir="${WEBMETHODS_INSTALLATION_FILES_DIR}"
fi

# Step 1: Prepare installation directories, if necessary.
. ./steps/preparation.sh

# Step 2: Download the SAG installer.
sag_installer="${wm_inst_dir}/SAGInstaller.bin"
. ./steps/getInstaller.sh

# Step 3: Copy the installer scripts (image.sh, and install.sh)
inst_image_script="${wm_inst_dir}/image-${WEBMETHODS_PRODUCT}-${WEBMETHODS_VERSION}.sh"
inst_install_script="${wm_inst_dir}/install-${WEBMETHODS_PRODUCT}-${WEBMETHODS_VERSION}.sh"
. ./steps/installerScripts.sh

# Step 4: Compiling the Replacer.class, if necessary
installerScriptEditor_src_file="./InstallerScriptEditor.java"
installerScriptEditor_class_file="./InstallerScriptEditor.class"
. ./steps/createInstallerScriptEditor.sh

# Step 5: Editing the installers image script to match the local settings
image_archive="${wm_inst_dir}/image-${WEBMETHODS_PRODUCT}-${WEBMETHODS_VERSION}.zip"
image_archive_new="${image_archive}.new"
. ./steps/editImageSh.sh

# Step 6: Create the installation image file.
. ./steps/createImage.sh

# Step 7: Editing the installers installation script to match the local settings.
#         Exception: License file locations (These are covered in the next step.)
. ./steps/editInstallSh.sh
 
# Step 8: Completing the installers installation script by adding the license file
#         references
. ./steps/addLicensesToInstallSh.sh

# Step 9: Run the SAG Installer to perform the actual installation.
. ./steps/runInstallation.sh
          
# Step 10: Create the .desktop files
. ./steps/createDesktopFiles.sh
