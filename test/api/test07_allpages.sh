#!/usr/bin/env bash
source config.sh

echo "Images..."

CR=$(curl -S --get  \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--data-urlencode "titles=${PAGE}" \
	--request "GET" "${WIKIAPI}?action=query&format=json&list=allpages&apnamespace=0")

echo "$CR" | jq .

STATUS=$(echo $CR | jq '.. | .title? | select(.)')

if [[ $STATUS == *${PAGE}* ]]; then
	echo "Success"
	echo "-----"
else
	echo "Unable to query"
	exit 1
fi
