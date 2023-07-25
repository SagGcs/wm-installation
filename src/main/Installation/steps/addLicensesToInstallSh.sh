#
# Step 7 of the webMethods installation: Edit the install.sh file.
#

assertVariablesGiven "inst_install_script wm_inst_dir WEBMETHODS_PRODUCT WEBMETHODS_VERSION"

licenseFileSeen=""
for licenseFile in "${product_dir}"/*-license.sh "${product_dir}/${WEBMETHODS_VERSION}"/*-license.sh; do
    lf="$(basename ${licenseFile})"
    if test "${lf}" = "*-license.sh"; then
        # No license files found in some directory, so bash returned this.
        true
    else
        licenseFileSeen="true"
        # Prefer the license file from the version specific directory, if available.
        if test -f "${product_dir}/${WEBMETHODS_VERSION}/${lf}"; then
            file="${product_dir}/${WEBMETHODS_VERSION}/${lf}"
        elif test -f "${product_dir}/${lf}"; then
            file="${product_dir}/${lf}"
        else
            file=""
        fi
        if test -z "$file"; then
            echo 2>&1 "License description file not found: ${lf}."
            exit 10
        else
            # The license description file must declare the variables licenseFileName,
            # licenseSourceVar, and licenseScriptVar. In order to verify the definition,
            # we start by clearing these variables.
            licenseFileName=""
            licenseSourceVar=""
            licenseScriptVar=""
            echo "Reading license description ${lf} from ${file}."
            . "${file}"
            # Now, we can check, if the license description file did set these variables.
            if test -z "${licenseFileName}"; then
                echo 2>&1 "Variable licenseFileName is missing, or empty, in license description file ${file}."
                exit 11
            fi
            if test -z "${licenseSourceVar}"; then
                echo 2>&1 "Variable licenseSourceVar is missing, or empty, in license description file ${file}."
                exit 12
            fi
            if test -z "${licenseScriptVar}"; then
                echo 2>&1 "Variable licenseScriptVar is missing, or empty, in license description file ${file}."
                exit 13
            fi

            # Get the current location of the license file.
	        eval "sourceFile=\$$licenseSourceVar"
            if test -z "${sourceFile}"; then
                echo 2>&1 "The variable ${licenseSourceVar} is missing, or empty."
                exit 14
            fi
            if test -f "${sourceFile}"; then
                # Create a copy of the license file, that the installer can use.
                targetFileName="$(echo $licenseFileName | sed -e s/-license/-license-${WEBMETHODS_PRODUCT}-${WEBMETHODS_VERSION}/)"
                licenseFile="${wm_inst_dir}/${targetFileName}"
                echo "Creating a copy of license file ${sourceFile} in ${licenseFile}."
                cp "${sourceFile}" "${licenseFile}"

			    # Insert the path of the copy into a copy of the installation script
			    echo "Adding license file ${licenseFile} to the installation script."
			    java -classpath . InstallerScriptEditor "${inst_install_script}" "${inst_install_script}".wl \
                    "${licenseScriptVar}" "urlVersion1(${licenseFile})"
                # Replace the installation script with its copy
                mv "${inst_install_script}".wl "${inst_install_script}"
            else
                echo 2>&1 "The license file ${sourceFile} (declared by variable ${licenseSourceVar})"
                echo 2>&1 "is missing, or not a file."
                exit 15
            fi
        fi
    fi
done

if test -z "${licenseFileSeen}"; then
    echo "Warning: No license files found in the product description for ${WEBMETHODS_PRODUCT}."
fi
