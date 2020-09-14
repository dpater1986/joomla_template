#!/bin/bash

git add .
git commit -m 'Forgot to commit'
# get version number
version=($(grep -oP '(?<=version>)[^<]+' "templateDetails.xml"))
echo What is the version number now: ${version[0]}
echo What is the version number you want it to get:
read version2
echo add a tag?
echo yes rest is false
read at

echo $version2
lt=($(cat releases/.lt))
echo $version ' becomes ' $version2 ' does this become a new tag ' $at ' old tag is ' $lt
# start to change version number
sed -i 's/'$version'/'$version2'/' "templateDetails.xml"
sed -i '$d' "releases/update.xml"
sed -i 's/'$version'/'$version2'/' "releases/.newUpdate.xml"
sed -i 's/raw\/'$version2'/raw\/main/' "releases/newUpdate.xml"
cat "releases/.newUpdate.xml" >> "releases/update.xml"
echo "</updates>" >> "releases/update.xml"

zip "releases/msjt_v"$version2".zip" css/* images/* index.php templateDetails.xml
cp "releases/msjt_v"$version2".zip" "releases/msjt_latest.zip"

if [ $at == "yes" ]
then
	git tag -a 'v'$version2 -m 'Add version '$version2''
	rm releases/.lt
	echo $version2 >> releases/.lt
	sed -i 's/raw\/main/raw\/'$version2'/' "releases/update.xml"
fi


echo Time to update git!
git add .
git commit -m 'New version '$version2
git push origin --all
git push origin --tags

