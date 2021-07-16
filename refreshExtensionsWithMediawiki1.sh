#!/bin/bash

if [ -d "servers/mediawiki1/htdocs/w/extensions/" ] && [ -d "servers/mediawiki2/htdocs/w/extensions/" ]; then
  echo Start to copy
  rm -rf ./servers/mediawiki2/htdocs/w/extensions/LinkedWiki
  rm -rf ./servers/mediawiki2/htdocs/w/extensions/PushAll
  rm -rf ./servers/mediawiki2/htdocs/w/extensions/NamespaceData
  cp -R ./servers/mediawiki1/htdocs/w/extensions/LinkedWiki ./servers/mediawiki2/htdocs/w/extensions/.
  cp -R ./servers/mediawiki1/htdocs/w/extensions/PushAll ./servers/mediawiki2/htdocs/w/extensions/.
  cp -R ./servers/mediawiki1/htdocs/w/extensions/NamespaceData ./servers/mediawiki2/htdocs/w/extensions/.
else
  echo The current directory is incorrect
  exit 1
fi

