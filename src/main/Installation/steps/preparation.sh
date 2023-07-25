#
# Step 1 of the webMethods installation: Prepare the installation directories.
#

assertVariablesGiven "wm_home_dir wm_inst_dir SUDO_USERID SUDO_GROUPID"

if test -d "${wm_home_dir}"; then
    echo "webMethods home directory already exists, no need to create it: ${wm_home_dir}"
else
    echo "Creating the webMethods home directory: ${wm_home_dir}"
    sudo mkdir -p "${wm_home_dir}"
    sudo chown "$SUDO_USERID:$SUDO_GROUPID" "${wm_home_dir}"
fi
if test -d "${wm_inst_dir}"; then
    echo "webMethods installation temp directory already exists, no need to create it: ${wm_inst_dir}"
else
    echo "Creating the webMethods installation temp directory: ${wm_inst_dir}"
    sudo mkdir -p "${wm_inst_dir}"
    sudo chown "$SUDO_USERID:$SUDO_GROUPID" "${wm_inst_dir}"
fi

 
