#!/usr/bin/env bash
source config.sh

echo "Returns all files contained on the given pages...."

CR=$(curl -S --get  \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--data-urlencode "page=${PAGE}" \
	--request "GET" "${WIKIAPI}?action=parse&format=json&prop=templates")

echo "$CR" | jq .

STATUS=$(echo $CR | jq '.. | .title? | select(.)')
echo $STATUS
if [[ $STATUS == *${PAGE}* ]]; then
	echo "Success"
	echo "-----"
else
	echo "Unable to query"
	exit 1
fi
