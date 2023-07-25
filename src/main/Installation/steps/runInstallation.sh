#
# Step 9 of the webMethods installation: Running the SAG Installer, and post-installation scripts.
#

assertVariablesGiven "sag_installer inst_install_script image_archive wm_home_dir product_dir"

run=""
if test -d "${wm_home_dir}/common"; then
    if test "${forceInstallation}" = "true"; then
        run="true"
    else
        echo "Skipping installation, because the directory ${wm_home_dir}/common"
        echo "is already existing. You may set forceInstallation=true to fix this."
        run=""
    fi
else
    run="true"
fi
if "$run" = "true"; then
    echo "Running the SAG installer, using image file ${image_archive}"
    ${sag_installer} -readScript "${inst_install_script}" -readImage "${image_archive}" -console

    after_install_sh="${wm_home_dir}/bin/afterInstallAsRoot.sh"
    if test -x "${after_install_sh}"; then
	    echo "Completing installation by running afterInstallAsRoot.sh script"
	    sudo "${after_install_sh}"
    else
	    echo "afterInstallAsRoot.sh does not exist, or is not executable."
	    echo "Not running it."
    fi

    after_install_product_sh="${product_dir}/afterInstall.sh"
    if test -x "${after_install_product_sh}"; then
        echo "Executing product specific post-installation script: ${after_install_product_sh}."
        . "${after_install_product_sh}"
    else
        echo "No product specific post-installation script found: ${after_install_product_sh}"
        echo "Not running it."
    fi
fi
