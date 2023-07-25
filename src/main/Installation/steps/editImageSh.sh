#
# Step 5 of the webMethods installation: Edit the image.sh file.
#

assertVariablesGiven "image_archive_new inst_image_script EMPOWER_USERID EMPOWER_PASSWORD"

echo "Editing image script ${inst_image_script} to match the local settings."
java -classpath . InstallerScriptEditor "${inst_image_script}" "${inst_image_script}".new \
 Username "${EMPOWER_USERID}" \
 Password "${EMPOWER_PASSWORD}" \
 imageFile "${image_archive_new}"
mv "${inst_image_script}".new "${inst_image_script}"
