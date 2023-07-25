#
# Step 4 of the webMethods installation: Creation of the files image.sh, and install.sh
# by copying from the product directory.
#

assertVariablesGiven "inst_image_src_script inst_install_src_script inst_image_script inst_install_script"

echo "Creating SAG installer scripts: ${inst_image_script}"
cp "${inst_image_src_script}" "${inst_image_script}"
echo "Creating SAG installer scripts: ${inst_install_script}"
cp "${inst_install_src_script}" "${inst_install_script}"





