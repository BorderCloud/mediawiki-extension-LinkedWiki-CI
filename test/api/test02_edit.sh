#!/usr/bin/env bash
source config.sh

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

#############
echo "Make a test edit"
CR=$(curl -S \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--form "action=edit" \
	--form "format=json" \
	--form "title=${TEMPLATE}" \
	--form "appendtext=${TEMPLATETEXT}" \
	--form "token=${EDITTOKEN}" \
	--request "POST" "${WIKIAPI}")
	

CR=$(curl -S \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--form "action=edit" \
	--form "format=json" \
	--form "title=${MODULE}" \
	--form "appendtext=${MODULETEXT}" \
	--form "token=${EDITTOKEN}" \
	--request "POST" "${WIKIAPI}")
	

CR=$(curl -S \
	--location \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--form "action=edit" \
	--form "format=json" \
	--form "title=${PAGE}" \
	--form "text=${PAGETEXT}" \
	--form "token=${EDITTOKEN}" \
	--request "POST" "${WIKIAPI}")

echo "$CR" | jq .

STATUS=$(echo $CR | jq '.edit.result')
if [[ $STATUS == *"Success"* ]]; then
	echo "Successfully edited, STATUS is $STATUS."
	echo "-----"
else
	echo "Unable to edit, is token ${EDITTOKEN} correct?"
	exit 1
fi
# 
# REVID=$(echo $CR | jq '.edit.newrevid')
# 
# echo "REVID= $REVID"
# CR=$(curl -S \
# 	--location \
# 	--cookie $COOKIE \
# 	--user-agent "Curl Shell Script" \
# 	--keepalive-time 60 \
# 	--header "Accept-Language: en-us" \
# 	--header "Connection: keep-alive" \
# 	--compressed \
# 	--form "action=tag" \
# 	--form "format=json" \
# 	--form "revid=${REVID}" \
# 	--form "add=pushall-push" \
# 	--form "reason=METADATA" \
# 	--form "token=${EDITTOKEN}" \
# 	--request "POST" "${WIKIAPI}")
# 
# echo "$CR" | jq .
# 
# STATUS=$(echo $CR | jq '.tag.result')
# if [[ $STATUS == *"Success"* ]]; then
# 	echo "Successfully edited, STATUS is $STATUS."
# 	echo "-----"
# else
# 	echo "Unable to tag, is token ${EDITTOKEN} correct?"
# 	exit 1
# fi
