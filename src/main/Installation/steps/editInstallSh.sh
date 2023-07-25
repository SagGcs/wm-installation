#
# Step 7 of the webMethods installation: Edit the install.sh file.
#

assertVariablesGiven "image_archive inst_install_script wm_inst_dir wm_home_dir"

echo "Adjusting variables in install script ${inst_install_script} to the local settings."
java -classpath . InstallerScriptEditor "${inst_install_script}" "${inst_install_script}".new \
 imageFile "${image_archive}" \
 HostName "localhost" \
 InstallDir "${wm_home_dir}"
mv "${inst_install_script}.new" "${inst_install_script}"
