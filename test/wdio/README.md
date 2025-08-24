# Install

- Start docker service
- Start servers
- Start Selenium grid

# WDIO

```
cd mediawiki-extension-LinkedWiki-CI/test/selenium4

./specs/PushAll/clean_mediawiki1.sh
./specs/PushAll/clean_mediawiki2.sh
# DEBUG=true npx wdio wdio.check_selenium.js
_BROWSER=firefox npx wdio wdio.check_selenium.js
./specs/PushAll/clean_mediawiki1.sh
./specs/PushAll/clean_mediawiki2.sh
_BROWSER=chrome npx wdio wdio.check_selenium.js

# DEBUG=true npx wdio wdio.create_users.js
_BROWSER=chrome npx wdio run wdio.create_users.js

# DEBUG=true npx wdio wdio.namespacedata.js
_BROWSER=firefox npx wdio wdio.namespacedata.js
_BROWSER=chrome npx wdio wdio.namespacedata.js


./specs/PushAll/clean_mediawiki1.sh
./specs/PushAll/clean_mediawiki2.sh
# DEBUG=true npx wdio wdio.pushall.js
_BROWSER=firefox npx wdio wdio.pushall.js
./specs/PushAll/clean_mediawiki1.sh
./specs/PushAll/clean_mediawiki2.sh
_BROWSER=chrome npx wdio wdio.pushall.js


./specs/LinkedWiki/clean_mediawiki1.sh
# DEBUG=true npx wdio wdio.linkedwiki.js
# DEBUG=true npx wdio wdio.linkedwiki.js   --mochaOpts.grep "test32"
_BROWSER=firefox npx wdio wdio.linkedwiki.js  --spec suite_tests_page.js
./specs/LinkedWiki/clean_mediawiki1.sh
_BROWSER=chrome npx wdio wdio.linkedwiki.js  --spec suite_tests_job.js

```