#!/bin/bash

# deployMediawiki BRANCH PATH-HTDOCS

echo "Deploy Mediawiki in the path:"
mkdir -p $2
cd $2
pwd

git clone --depth 1 --branch $1 https://gerrit.wikimedia.org/r/mediawiki/core.git w
cd w
composer config -g allow-plugins true
composer update --no-dev
yarn install --production=true --silent


cd skins/
echo "Deploy Mediawiki skin in the path:"
pwd

git clone --depth 1 -b $1  https://phabricator.wikimedia.org/diffusion/SVEC/Vector 
yarn install --production=true --silent


cd ../extensions/
echo "Deploy Mediawiki extensions in the path:"
pwd

git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/CiteThisPage.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Interwiki.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Nuke.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Renameuser.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/ImageMap.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/InputBox.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/ParserFunctions.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Poem.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/SyntaxHighlight_GeSHi.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/PdfHandler.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/ConfirmEdit.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/SpamBlacklist.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/TitleBlacklist.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/CodeEditor.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Gadgets.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/LocalisationUpdate.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/WikiEditor.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Cite.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/CategoryTree.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Scribunto.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Capiunto.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Variables.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Babel.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Translate.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/cldr.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/Math.git
git clone --depth 1 https://gerrit.wikimedia.org/r/mediawiki/extensions/ApiSandbox.git
git clone --depth 1 -b $1  https://gerrit.wikimedia.org/r/mediawiki/extensions/NetworkAuth.git # for private Wiki
git clone --depth 1 https://gerrit.wikimedia.org/r/mediawiki/extensions/LinkedWiki.git
git clone --depth 1 https://github.com/BorderCloud/NamespaceData.git
git clone --depth 1 https://github.com/BorderCloud/PushAll.git

for D in `find . -maxdepth 1 -type d `
do
        if  ! [ "." = "${D}" ] && ! [ ".." = "${D}" ]; then
                cd ${D}
                echo ${D}

                if [ -f "composer.json" ]; then
                    if [ "./LinkedWiki" = "${D}" ] || [ "./PushAll" = "${D}" ] || [ "./NamespaceData" = "${D}" ]; then
                        composer update
                    else
                        composer update --no-dev
                    fi
                fi

                if [ -f "package.json" ]; then
                    if [ "./LinkedWiki" = "${D}" ] || [ "./PushAll" = "${D}" ] || [ "./NamespaceData" = "${D}" ]; then
                         yarn install  --silent
                    else
                        yarn install  --production=true --silent
                    fi
                fi

                cd ..
        fi
done


