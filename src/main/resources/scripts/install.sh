#!/bin/sh -e

# Load the settings.sh file
. ./settings.sh


# 1. Create the directory for the installation files.
inst_files_dir="${WEBMETHODS_INSTALLATION_FILES_DIR}"
if test -d "${inst_files_dir}"; then
    echo "Using existing directory ${inst_files_dir} for installation files."
else
    echo "Creating directory ${inst_files_dir} for installation files."
    sudo mkdir -p "${inst_files_dir}"
    sudo chown -R "${ADMIN_USERID}:${ADMIN_GROUPID}" "${inst_files_dir}"
fi

# 2. Create the installation directory, if necessary.
inst_dir="${WEBMETHODS_HOME_DIR}"
if test -d "${inst_dir}"; then
    echo "Using existing installation diurectory ${inst_dir}."
else
    echo "Creating installation directory ${inst_dir}."
    sudo mkdir -p "${inst_dir}"
    sudo chown -R "${ADMIN_USERID}:${ADMIN_GROUPID}" "${inst_dir}"
fi


 # 3. Get the Software AG Installer
sag_inst_binary="${inst_files_dir}/SAGInstaller.bin"
if test -f "${sag_inst_binary}"; then
    echo "Using existing file ${sag_inst_binary} as Software AG Installer."
else
    echo "Downloading Software AG Installer to ${sag_inst_binary}"
    wget -O "${sag_inst_binary}.new" "${SAG_INSTALLER_URL}"
    mv "${sag_inst_binary}.new" "${sag_inst_binary}"
    chmod 755 "${sag_inst_binary}"
fi

# 4. Copy the installer scripts
image_script="${inst_files_dir}/image-${WEBMETHODS_VERSION}.sh"
image_archive="${inst_files_dir}/image-${WEBMETHODS_VERSION}.zip"
image_archive_new="${inst_files_dir}/image-${WEBMETHODS_VERSION}-new.zip"
install_script="${inst_files_dir}/install-${WEBMETHODS_VERSION}.sh"
image_src_script="versions/${WEBMETHODS_VERSION}/image.sh"
install_src_script="versions/${WEBMETHODS_VERSION}/install.sh"
if test -f "${image_src_script}"; then
    cp "${image_src_script}" "${image_script}"
else
    echo 1>&2 "Error: Image script not found: ${image_src_script}"
    exit 2
fi 
if test -f "${install_src_script}"; then
    cp "${install_src_script}" "${install_script}"
else
    echo 1>&2 "Error: Install script not found: ${install_src_script}"
    exit 2
fi 

# 5. Copy the license files
is_lic_file="${inst_files_dir}/is-license-${WEBMETHODS_VERSION}.xml"
is_lic_src_file="${LICENSE_FILE_IS}"
um_lic_file="${inst_files_dir}/um-license-${WEBMETHODS_VERSION}.xml"
um_lic_src_file="${LICENSE_FILE_UM}"
ts_lic_file="${inst_files_dir}/ts-license-${WEBMETHODS_VERSION}.xml"
ts_lic_src_file="${LICENSE_FILE_TS}"
if test -f "${is_lic_src_file}"; then
	echo "Copying ${is_lic_src_file} as the IS license file to ${is_lic_file}."
    cp "${is_lic_src_file}" "${is_lic_file}"
else
    echo 1>&2 "Error: IS license file not found: ${is_lic_src_file}"
    exit 2
fi 
if test -f "${um_lic_src_file}"; then
	echo "Copying ${um_lic_src_file} as the UM license file to ${um_lic_file}."
    cp "${um_lic_src_file}" "${um_lic_file}"
else
    echo 1>&2 "Error: UM license file not found: ${um_lic_src_file}"
    exit 2
fi 
if test -f "${ts_lic_src_file}"; then
	echo "Copying ${ts_lic_src_file} as the test suite license file to ${ts_lic_file}."
    cp "${ts_lic_src_file}" "${ts_lic_file}"
else
    echo 1>&2 "Error: Test suite license file not found: ${ts_lic_src_file}"
    exit 2
fi 

# 6. Create the Replacer binary as an editor for the installation script.
javac="/usr/lib/jvm/java-1.8.0/bin/javac"
if test -f "Replacer.class"; then
    echo "Using existing Replacer binary as an editor for installer scripts."
else
    if test -f "${javac}"; then
         echo "Using existing Java compiler ${javac}";
    else
         echo "Installing Java compiler java-1.8.0-openjdk"
         sudo dnf -y install java-1.8.0-openjdk-{devel,src,javadoc}
    fi
    echo "Creating Replacer binary using Java compiler ${javac}"
    /usr/lib/jvm/java-1.8.0/bin/javac -d . Replacer.java
fi

# 7. Adjust the installer script image.sh to the local settings.
echo "Adjusting variables in image script ${image_script} to the local settings."
java="/usr/lib/jvm/java-1.8.0/bin/java"
${java} -classpath . Replacer "${image_script}" "${image_script}".new \
 Username "${EMPOWER_USERID}" \
 Password "${EMPOWER_PASSWORD}" \
 imageFile "${image_archive_new}"
mv "${image_script}.new" "${image_script}"

# 8. Run the Installer to build the installation image.
if test -f "${image_archive}"; then
   echo "Using existing Installer image file ${image_archive}"
else
   echo "Running the Software AG Installer to build the image file ${image_archive}".
   "${sag_inst_binary}" -readScript "${image_script}" -writeImage "${image_archive_new}" -console
   mv "${image_archive_new}" "${image_archive}"
fi

# 9. Adjust the installer script install.sh to the local settings.
echo "Adjusting variables in install script ${install_script} to the local settings."
java="/usr/lib/jvm/java-1.8.0/bin/java"
${java} -classpath . Replacer "${install_script}" "${install_script}".new \
 imageFile "${image_archive}" \
 integrationServer.LicenseFile.text "url(__VERSION1__,${is_lic_file})" \
 HostName "localhost" \
 InstallDir "${inst_dir}" \
 DesignerLicense "url(__VERSION1__,${ts_lic_file})" \
 NUMRealmServer.LicenseFile.text "url(__VERSION1__,${um_lic_file})"
mv "${install_script}.new" "${install_script}"


# 10. Run the Installer to build the installation image.
echo "Running the Software AG Installer to perform the actual installation."
"${sag_inst_binary}" -readScript "${install_script}" -readImage "${image_archive}" -console
if test -x "${inst_dir}/bin/afterInstallAsRoot.sh"; then
    echo "Running ${inst_dir}/bin/afterInstallAsRoot.sh" 
    sudo "${inst_dir}"/bin/afterInstallAsRoot.sh
else
    echo "Not running ${inst_dir}/bin/afterInstallAsRoot.sh, because the file is not present."
fi


# 11. Create a .desktop file, so that Designer becomes visible in the Windows search
sag_desktop_file="/usr/share/applications/designer${WEBMETHODS_VERSION}.desktop"
temp_desktop_file="${inst_dir}/designer${WEBMETHODS_VERSION}.desktop"
if test -f "${sag_desktop_file}"; then
    echo "Skipping creation of .desktop file"
    echo "${sag_desktop_file}, because it already exists:"
else
    echo "Creating .desktop file ${sag_desktop_file}."
    cat >"${temp_desktop_file}" <<END_OF_DESKTOP
[Desktop Entry]
Name=SAG Designer ${WEBMETHODS_VERSION}
Comment=Softare AG Designer ${WEBMETHODS_VERSION}
Terminal=false
Icon=/opt/wm/${WEBMETHODS_VERSION}/Designer/eclipse/icon.xpm
Type=Applicaton
MimeType=
END_OF_DESKTOP
    sudo mv "${temp_desktop_file}" "${sag_desktop_file}"
    sudo chmod 666 "${sag_desktop_file}"
    sudo chown root:root "${sag_desktop_file}"
fi
