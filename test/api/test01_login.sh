#!/usr/bin/env bash
source config.sh

echo "Logging into $WIKIAPI as $USERNAME..."

###############
#Login part 1
echo "Get login token..."
CR=$(curl -S \
	--location \
	--retry 2 \
	--retry-delay 5 \
	--cookie-jar $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&meta=tokens&type=login&format=json")

echo "$CR" | jq .

echo "$CR" > $TOKEN_JSON
TOKEN=$(jq --raw-output '.query.tokens.logintoken'  $TOKEN_JSON)

echo "###### COOKIE ######"
cat $COOKIE
echo "############"

if [ "$TOKEN" == "null" ]; then
	echo "Getting a login token failed."
	exit 1
else
	echo "Login token is $TOKEN"
	echo "-----"
fi

###############
#Login part 2
echo "Logging"
CR=$(curl -S \
	--location \
	--cookie $COOKIE \
	--cookie-jar $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--form "action=login" \
	--form "lgname=${USERNAME}" \
	--form "lgpassword=${USERPASS}" \
	--form "lgtoken=${TOKEN}" \
	--form "format=json" \
	--request "POST" "${WIKIAPI}")

echo "$CR" | jq .

echo "###### COOKIE ######"
cat $COOKIE
echo "############"

STATUS=$(echo $CR | jq '.login.result')
if [[ $STATUS == *"Success"* ]]; then
	echo "Successfully logged in as $USERNAME, STATUS is $STATUS."
	echo "-----"
else
	echo "Unable to login, is logintoken ${TOKEN} correct?"
	exit 1
fi

#########
echo "Get rights of bot..."
CR=$(curl -S \
	--location \
	--retry 2 \
	--retry-delay 5 \
	--cookie $COOKIE \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&meta=userinfo&uiprop=rights&format=json")

echo "$CR" | jq .
