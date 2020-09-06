#!/bin/bash

git add .
git commit -m 'Forgot to commit'
# get version number
version=($(grep -oP '(?<=version>)[^<]+' "templateDetails.xml"))
echo What is the version number now: ${version[0]}
echo What is the version number you want it to get:
read version2
echo $version2

# start to change version number
sed -i 's/'$version'/'$version2'/' "templateDetails.xml"
sed -i '$d' "releases/update.xml"
sed -i 's/'$version'/'$version2'/' "releases/.newUpdate.xml"
cat "releases/.newUpdate.xml" >> "releases/update.xml"
echo "</updates>" >> "releases/update.xml"

zip "releases/msjt_v"$version2".zip" css/* images/* index.php templateDetails.xml
cp "releases/msjt_v"$version2".zip" "releases/msjt_latest.zip"

echo Time to update git!
git add .
git commit -m 'New version '$version2
git push origin --all
