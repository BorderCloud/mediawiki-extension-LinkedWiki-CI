#!/usr/bin/env bash
source config.sh

echo "Search categories..."

CR=$(curl -S --get  \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--data-urlencode "gacprefix=t" \
	--request "GET" "${WIKIAPI}?action=query&format=json&generator=allcategories")

echo "$CR" | jq .

STATUS=$(echo $CR | jq '.. | .title? | select(.)')

if [[ $STATUS == *Category:Test* ]]; then
	echo "Success"
	echo "-----"
else
	echo "Unable to query"
	exit 1
fi
