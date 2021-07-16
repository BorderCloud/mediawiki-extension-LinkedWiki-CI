#!/usr/bin/env bash
source config.sh

FILECOMMENT="comment"
FILETEXT="text"

echo "Fetching edit token..."

CR=$(curl -S \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&meta=tokens&format=json")

echo "$CR" | jq .
echo "$CR" > $EDITTOKEN_JSON
EDITTOKEN=$(jq --raw-output '.query.tokens.csrftoken' $EDITTOKEN_JSON)

# Remove carriage return!
if [[ $EDITTOKEN == *"+\\"* ]]; then
	echo "Edit token is: $EDITTOKEN"
else
	echo "Edit token not set."
	exit
fi

############
echo "Make a test upload"

CR=$(curl -S \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--header "Expect:" \
	--form "action=upload" \
	--form "format=json" \
	--form "token=${EDITTOKEN}" \
	--form "filename=${FILENAME}" \
	--form "text=${FILETEXT}" \
	--form "comment=${FILECOMMENT}" \
	--form "file=@${FILEPATH}" \
	--form "ignorewarnings=yes" \
	--request "POST" "${WIKIAPI}")

echo "$CR" | jq .

STATUS=$(echo $CR | jq '.upload.result')
if [[ $STATUS == *"Success"* ]]; then
	echo "Successfully uploaded, STATUS is $STATUS."
	echo "-----"
else
	echo "Unable to edit, is token ${EDITTOKEN} correct?"
	exit 1
fi
