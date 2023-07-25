#
# Step 4 of the webMethods installation: Create ther file Replacer.class by
# compiling it from Replacer.java, if necessary
#
assertVariablesGiven "replacer_src_file replacer_class_file"

if test -f "${replacer_class_file}"; then
   echo "Using existing Replacer class file: ${replacer_class_file}"
else
   echo "Creating Replacer class file by compiling Java source ${replacer_src_file}"
   javac -s . -d . -source 8 -target 8 -g Replacer.java
fi
