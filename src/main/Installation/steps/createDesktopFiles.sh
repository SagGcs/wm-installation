#
# Step 10 of the webMethods installation: Creating the .desktop files.
#

assertVariablesGiven "wm_inst_dir product_dir WEBMETHODS_PRODUCT WEBMETHODS_VERSION"

desktopFileSeen=""
for desktopFile in "${product_dir}"/*-desktop.sh "${product_dir}/${WEBMETHODS_VERSION}"/*-desktop.sh; do
    df="$(basename ${desktopFile})"
    if test "${df}" = "*-desktop.sh"; then
        # No license files found in some directory, so bash returned this.
 		# Do nothing, continue with the next file.
        true
    else
        desktopFileSeen="true"
        # Prefer the desktop file from the version specific directory, if available.
        if test -f "${product_dir}/${WEBMETHODS_VERSION}/${df}"; then
            file="${product_dir}/${WEBMETHODS_VERSION}/${df}"
        elif test -f "${product_dir}/${df}"; then
            file="${product_dir}/${df}"
        else
            file=""
        fi
        if test -z "$file"; then
            echo 2>&1 "Desktop file description not found: ${df}."
            exit 10
        else
            # The desktop file description must declare the variables desktopFileName,
            # desktopFileExecutable, and desktopFileIcon. In order to verify the definition,
            # we start by clearing these variables.
            desktopFileName=""
            desktopFileFileName=""
            desktopFileExecutable=""
            desktopFileIcon=""
            echo "Reading desktop file description ${df} from ${file}."
            . "${file}"
            # Now, we can check, if the desktop file description did set these variables.
            if test -z "${desktopFileName}"; then
                echo 2>&1 "Variable desktopFileName is missing, or empty, in desktop file description ${file}."
                exit 14
            fi
            if test -z "${desktopFileFileName}"; then
                echo 2>&1 "Variable desktopFileFileName is missing, or empty, in desktop file description ${file}."
                exit 14
            fi
            if test -z "${desktopFileExecutable}"; then
                echo 2>&1 "Variable desktopFileExecutable is missing, or empty, in desktop file description ${file}."
                exit 15
            fi
            if test -z "${desktopFileIcon}"; then
                echo 2>&1 "Variable desktopFileIcon is missing, or empty, in license desktop file description ${file}."
                exit 16
            fi
            
            # Actual creation of the .desktop file.
            actual_desktop_file="/usr/local/share/applications/${}.desktop"
            temp_desktop_file="${wm_inst_dir}/${desktopFileName}-${WEBMETHODS_PRODUCT}-${WEBMETHODS_VERSION}"
            if test -f "${actual_desktop_file}"; then
                echo "Skipping creation of desktop file ${df}, because it already exists at ${actual_desktop_file}."
            else
                echo "Creating desktop file ${df} at ${actual_desktop_file}."
            cat >"${temp_desktop_file}" <<END_OF_DESKTOP
[Desktop Entry]
Name=${desktopFileName}
Comment=${desktopFileComment}
Terminal=false
Icon=${desktopFileIcon}
Type=Applicaton
Exec=${desktopFileExecutable}
MimeType=
END_OF_DESKTOP
            sudo mkdir -p /usr/local/share/applications
            sudo cp "${temp_desktop_file}" "${actual_desktop_file}"
            sudo chmod 666 "${actual_desktop_file}"
    sudo chown root:root "${sag_desktop_file}"
fi
            
            
        fi
    fi
done
    
    