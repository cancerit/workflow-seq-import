  #!/bin/bash

echo -e "\n##############################"
echo      "# Running mdl (markdownlint) #"
echo      "##############################"
# disable the line-length check
mdl -r ~MD013,~MD024,~MD046,~MD007 -g .

exit 0 # don't die based on markdownlint
