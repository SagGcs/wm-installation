#
# Step 6 of the webMethods installation: Create an installer image
#

assertVariablesGiven "sag_installer inst_image_script image_archive"

if test -f "${image_archive}"; then
    echo "Using existing image file ${image_archive}"
else
    echo "Running the SAG installer to create image file ${image_archive}"
    ${sag_installer} -readScript "${inst_image_script}" -writeImage "${image_archive}" -console
fi

