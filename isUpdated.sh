#!/bin/bash

if [ $# -eq 0 ]; then
    printf "Utilization:\n"
    printf "$0 <REPO> <BRANCH>"
    printf "example : ./isUpdated.sh wikimedia/mediawiki REL1_36"
    exit 1
fi

exit $(curl -s https://api.github.com/repos/$1/commits/$2 | jq -r "((now - (.commit.author.date | fromdateiso8601) )  / (60*60*24)  | trunc)")
