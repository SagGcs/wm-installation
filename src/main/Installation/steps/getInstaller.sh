#
# Step 2 of the webMethods installation: Download of the SAG Installer
#

assertVariablesGiven "wm_home_dir wm_inst_dir sag_installer SUDO_USERID SUDO_GROUPID"
assertVariablesGiven "EMPOWER_USERID EMPOWER_PASSWORD SAG_INSTALLER_URL"

if test -f "${sag_installer}"; then
    echo "Skipping download of the SAG Installer, because it is already present."
else
    # Download the SAG Installer as a .bin.new file, which is finally being renamed
    # to the actual .bin file. This enables us to restart, if a previous download
    # has failed, and the downloaded file is incomplete.
    wget -O "${sag_installer}.new" "${SAG_INSTALLER_URL}"
    mv "${sag_installer}.new" "${sag_installer}"
    chmod 755 "${sag_installer}"
fi
