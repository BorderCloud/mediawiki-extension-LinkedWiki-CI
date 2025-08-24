-- @copyright (c) 2021 Bordercloud.com
-- @author Karima Rafes <karima.rafes@bordercloud.com>
-- @link https://www.mediawiki.org/wiki/Extension:LinkedWiki
-- @license CC-BY-SA-4.0
--[[
-- Debug console

mw.log(p.tests() )
]]

local p = {}
local newline = [[

]]

function p.checkLiteral(query, litteral)
    local result = ''
    if string.match(query, litteral) then
        result = "OK"
    else
        result = "KO"
    end
    return result
end


function p.checkString(val1, val2)
    local result = ''
    if (val1 ==  nil or val2 ==  nil) then
        result = "KO"
    else
        if val1 ==  val2 then
            result = "OK"
        else
            result = "KO"
        end
    end
    return result
end
function p.checkNumber(val1, val2)
    local result = ''
    if (val1 ==  nil or val2 ==  nil) then
        result = "KO"
    else
        if tonumber(val1) ==  tonumber(val2) then
            result = "OK"
        else
            result = "KO"
        end
    end
    return result
end
function p.checkBool(val1, val2)
    local result = ''
    if (val1 ==  nil or val2 ==  nil) then
        result = "KO"
    else
        if val1 ==  val2 then
            result = "OK"
        else
            result = "KO"
        end
    end
    return result
end


function p.tests(f)
    local html = ""
    local result = ""
    local linkedwiki = require 'linkedwiki'

    local wd = "http://www.wikidata.org/entity/"
    local subject1 = wd.."Q1"

    local wd = "http://www.wikidata.org/entity/"
    local subject2 = wd.."Q2"

    local configTest = 'http://database-test1.localdomain/data'
    local configWikidata = "http://www.wikidata.org"

--    for i,v in pairs(linkedwiki) do
--       mw.log(i)
--    end

    --Config by default + Lang by default : en
    local objTest = linkedwiki.new(subject2)

    -- Config by default : taglang
    local objTestFr = linkedwiki.new(subject2,nil,"fr")
    
    
    --  config with another  : Wikidata and taglang : en
    local ObjWikidata =  linkedwiki.new(subject1,configWikidata)

    --  config with another  : Wikidata but taglang : fr
    local ObjWikidataFr =  linkedwiki.new(subject1,configWikidata,"fr")

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : Subject " ..newline

    result = objTest:getSubject()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,subject2) ..newline

    result = ObjWikidata:getSubject()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,subject1) ..newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : Config " ..newline

    result = objTest:getConfig()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,configTest) ..newline

    result = ObjWikidata:getConfig()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,configWikidata) ..newline

    result = objTestFr:getConfig()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,configTest) ..newline

    result = ObjWikidataFr:getConfig()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,configWikidata) ..newline


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : lang " ..newline

    result = objTest:getLang()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,"en") ..newline

    result = ObjWikidata:getLang()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,"en") ..newline


    result = objTestFr:getLang()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,"fr") ..newline

    result = ObjWikidataFr:getLang()
    html = html .."RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,"fr") ..newline


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : debug " ..newline

    result = objTest:isDebug()
    html = html .."RESULT BEGIN : "..newline ..tostring(result) ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkBool(result,false) ..newline

    result = ObjWikidata:isDebug()
    html = html .."RESULT BEGIN : "..newline ..tostring(result) ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkBool(result,false) ..newline


    result = objTestFr:setDebug(true)
    result = objTest:isDebug()
    html = html .."RESULT BEGIN : "..newline ..tostring(result) ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkBool(result,false) ..newline

    result = ObjWikidata:isDebug()
    html = html .."RESULT BEGIN : "..newline ..tostring(result) ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkBool(result,false) ..newline

   return "<pre>"..mw.text.nowiki( mw.text.encode( html) ).."</pre>"
end

return p
