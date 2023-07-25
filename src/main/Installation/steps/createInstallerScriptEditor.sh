#
# Step 4 of the webMethods installation: Create the InstallerScriptEditor by compiling the Java source.
#

assertVariablesGiven "installerScriptEditor_src_file installerScriptEditor_class_file"

if test -f "${installerScriptEditor_class_file}"; then
    echo "Using existing installer script editor: ${installerScriptEditor_class_file}."
else
    echo "Creating installer script editor: ${installerScriptEditor_class_file}."
    echo javac -s . -d . "${installerScriptEditor_src_file}" -source 1.8 -target 1.8
    javac -s . -d . "${installerScriptEditor_src_file}" -source 1.8 -target 1.8
fi
