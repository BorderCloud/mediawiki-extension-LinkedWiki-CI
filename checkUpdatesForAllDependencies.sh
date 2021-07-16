#!/bin/bash

if [ $# -eq 0 ]; then
    printf "Utilization:\n"
    printf "$0 <REPO> <BRANCH>"
    printf "example : ./checkUpdatesForAllDependencies.sh REL1_36"
    exit 1
fi

if 
    (./isUpdated.sh wikimedia/mediawiki $1 ;) ||
    (./isUpdated.sh BorderCloud/PushAll master ;) ||
    (./isUpdated.sh BorderCloud/NamespaceData master ;) ||
    (./isUpdated.sh wikimedia/mediawiki-extensions-LinkedWiki master ;)
then
    echo START TEST
    exit 0
else
    echo SKIP TEST
    exit 1
fi
