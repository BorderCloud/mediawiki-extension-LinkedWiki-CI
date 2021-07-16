#!/usr/bin/env bash

# Needs curl and jq

# You can create a new bot with this command:
# php maintenance/createBotPassword.php --grants basic,createeditmovepage,editdata,delete,editpage,uploadeditmovefile,uploadfile,highvolume --appid mediawiki1 UserData ff38s9u4feh07vjs2s6t88dh2pv5cfgv
# You can login in using username:'UserData@mediawiki1' and password:'ff38s9u4feh07vjs2s6t88dh2pv5cfgv'.

USERNAME="UserData@mediawiki1"
USERPASS="ff38s9u4feh07vjs2s6t88dh2pv5cfgv"
WIKI="http://serverdev-mediawiki2.localdomain/"
WIKIAPI1="http://serverdev-mediawiki1.localdomain/w/api.php"
WIKIAPI="http://serverdev-mediawiki2.localdomain/w/api.php"
folder="/tmp"
COOKIE="${folder}/wikicj"
TOKEN_JSON="${folder}/login.json"
EDITTOKEN_JSON="${folder}/edittoken.json"

PAGE="Title of an article"
PAGETEXT="[[File:mediawikiwiki.png]]{{#invoke:Test|print}}{{Test}}[[category:Test]] test"
TEMPLATE="Template:Test"
TEMPLATETEXT="test"
MODULE="Module:Test"
MODULETEXT=$(cat <<-END
local p = {} --p stands for package

function p.print( frame )
    return "test06 module1"
end

return p 
END
)

# wget https://www.mediawiki.org/static/images/project-logos/mediawikiwiki.png
FILENAME="Mediawikiwiki.png"
FILEPATH="./mediawikiwiki.png"
