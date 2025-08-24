-- @copyright (c) 2021 Bordercloud.com
-- @author Karima Rafes <karima.rafes@bordercloud.com>
-- @link https://www.mediawiki.org/wiki/Extension:LinkedWiki
-- @license CC-BY-SA-4.0
--[[
-- Debug console

frame = mw.getCurrentFrame() -- Get a frame object
newFrame = frame:newChild{ -- Get one with args
    title = 'test' ,
 args = {
 iri = 'http://serverdev-mediawiki1.localdomain/wiki/LinkedWikiTestTestPage0.9577795569981264'
    }
}

mw.log(p.tests(newFrame) )

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


function p.tests(f)

    local linkedwiki = require 'linkedwiki'
    linkedwiki.setCurrentFrame(mw.getCurrentFrame())

    local endpoint = 'http://database-test1.localdomain:8890/sparql'
    local config = 'http://database-test1.localdomain/data'


    local xsd = 'http://www.w3.org/2001/XMLSchema#'

    local pr = 'http://database-test/Property:'

    local html = '== TESTS =='.. newline

    --linkedwiki.setDebug(true)
    local subject = f.args.iri or linkedwiki.getCurrentIRI();
    html = html .."TEST : linkedwiki.getCurrentIRI()" .. newline
    html = html .."RESULT : " .. subject .. newline

    linkedwiki.setConfig(config)

    local subject = linkedwiki.getCurrentIRI();

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : linkedwiki.explode" ..newline

    local str1 = ""
    local str2 = "el1"
    local str3 = "el1;el2"
    local arrTestExplode1 = linkedwiki.explode(";",str1)
    local arrTestExplode2 = linkedwiki.explode(";",str2)
    local arrTestExplode3 = linkedwiki.explode(";",str3)
    html = html .."RESULT : 0==" ..table.getn(arrTestExplode1).. newline
    html = html .."RESULT : 1==" ..table.getn(arrTestExplode2).. newline
    html = html .."RESULT : 2==" ..table.getn(arrTestExplode3).. newline


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : linkedwiki.timeStamp" ..newline

    local dateStringArg1 = "1971-01-01"
    local dateStringArg2 = "31536000"
    html = html .."CHECK : timestamp(" ..dateStringArg1.. ')= '..dateStringArg2..newline
    html = html ..linkedwiki.timeStamp(dateStringArg1).. newline
    html = html .."RESULT : " ..p.checkNumber(linkedwiki.timeStamp(dateStringArg1), dateStringArg2).. newline

    local dateStringArg1 = "1972-01-01"
    local dateStringArg2 = "63072000"
    html = html .."CHECK : timestamp(" ..dateStringArg1.. ')= '..dateStringArg2..newline
    html = html ..linkedwiki.timeStamp(dateStringArg1).. newline
    html = html .."RESULT : " ..p.checkNumber(linkedwiki.timeStamp(dateStringArg1), dateStringArg2).. newline


    local dateStringArg1 = "1970-01-11T01:10:00+02:00"
    local dateStringArg2 = "861000"
    html = html .."CHECK : timestamp(" ..dateStringArg1.. ')= '..dateStringArg2..newline
    html = html ..linkedwiki.timeStamp(dateStringArg1).. newline
    html = html .."RESULT : " ..p.checkNumber(linkedwiki.timeStamp(dateStringArg1), dateStringArg2).. newline


    local dateStringArg1 = "1970-01-01"
    local dateStringArg2 = "1970-01-01T00:00:00Z"
    html = html .."CHECK : " ..dateStringArg1.. '=='..dateStringArg2..newline
    html = html .."RESULT : " ..p.checkNumber(linkedwiki.timeStamp(dateStringArg1), linkedwiki.timeStamp(dateStringArg2)).. newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : getValue & addPropertyWithIri without default subject" ..newline

    mw.log(linkedwiki.removeSubject(subject))

    html = html .."Insert " .. pr..'Test'..newline
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test',subject))
    local tabStr = linkedwiki.getValue(pr..'type',subject)
--    mw.log(linkedwiki.getLastQuery())
    local arr = linkedwiki.explode(";",tabStr)
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

--    html = html .."RESULT : " ..tabStr.. newline
--
--    for i, iri in ipairs(arr) do
--        html = html .. i .. " : " .. iri .. newline
--    end

    html = html .."Insert " .. pr..'Test2'..newline
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test2',subject))
    local tabStr2 = linkedwiki.getValue(pr..'type',subject)
--    mw.log(linkedwiki.getLastQuery())
    local arr2 = linkedwiki.explode(";",tabStr2)
    html = html .."RESULT : Found " ..table.getn(arr2).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr2), 2).. newline
--    html = html .."RESULT : " ..tabStr2.. newline
--
--    for i, iri in ipairs(arr2) do
--        html = html .. i .. " : " .. iri .. newline
--    end

    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject(subject))
    local tabStr3 = linkedwiki.getValue(pr..'type',subject)
--    mw.log(linkedwiki.getLastQuery())
    local arr3 = linkedwiki.explode(";",tabStr3)
    html = html .."RESULT : Found " ..table.getn(arr3).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr3), 0).. newline
--    html = html .."RESULT : " ..tabStr3.. newline
--
--    for i, iri in ipairs(arr3) do
--        html = html .. i .. " : " .. iri .. newline
--    end

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : getValue & addPropertyWithIri with default subject" ..newline

    linkedwiki.setSubject(subject)
    linkedwiki.removeSubject() -- delete all triples of this subject

    html = html .."Insert " .. pr..'Test'..newline
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test'))
    local arr = linkedwiki.explode(";",linkedwiki.getValue(pr..'type'))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    html = html .."Insert " .. pr..'Test2'..newline
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test2'))
    local arr2 = linkedwiki.explode(";",linkedwiki.getValue(pr..'type'))
    html = html .."RESULT : Found " ..table.getn(arr2).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr2), 2).. newline

    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())
    local arr3 = linkedwiki.explode(";",linkedwiki.getValue(pr..'type'))
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr3), 0).. newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : getValue & addPropertyWithLiteral" ..newline

    --linkedwiki.addPropertyWithLiteral(iriProperty, value, type, tagLang, iriSubject)
    --default lang is en in extension.json
    local pT =''
    local litteral=''
    local query=''
    local result = ""
    local arr = {}


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : text with lang tag " ..newline

    pT = pr..'1'
    litteral='\"\"\"text\"\"\"@en'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text")'..newline
    html = html .."Insert text === "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text"))
    query= linkedwiki.getLastQuery()
    --mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    pT = pr..'2'
    litteral='\"\"\"text\"\"\"@en'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text",nil)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text",nil))
    query= linkedwiki.getLastQuery()
    --mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    pT = pr..'3'
    litteral='\"\"\"text\"\"\"@fr'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text",nil,"fr")'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text",nil,"fr"))
    query= linkedwiki.getLastQuery()
    --mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    pT = pr..'4'
    litteral='\"\"\"text\"\"\"'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text",nil,"")'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text",nil,""))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    pT = pr..'5'
    litteral='\"\"\"text\"\"\"'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text",nil,nil)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text",nil,nil))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    pT = pr..'6'
    litteral='\"\"\"text\"\"\"'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text",nil,nil)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text",nil,nil))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline

    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : integer" ..newline

    pT = pr..'7'
    litteral='2'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',2)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,2))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    
    pT = pr..'8'
    litteral='2'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',2)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,litteral))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    
    pT = pr..'9'
    litteral='2'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',2)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,litteral,xsd.."int"))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    
    pT = pr..'9Error'
    local result, err = pcall(function () linkedwiki.addPropertyWithLiteral(pT,"Yo",xsd.."int") end )
    html = html .."RESULT BEGIN : "..newline ..err ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(err,'Error, it is not a number with the type xsd:int (example \'14\'): Yo') ..newline

    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : decimal" ..newline

    pT = pr..'8'
    litteral='"2"^^<'..xsd.."decimal"..'>'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',2,xsd.."decimal")'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,2,xsd.."decimal"))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2).. newline
    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())


    pT = pr..'9'
    litteral='2.1'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',2.1)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,2.1))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline

    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2.1).. newline
    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())

    pT = pr..'10'
    litteral='"2.1"^^<'..xsd.."decimal"..'>'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',2.1,xsd.."decimal")'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,2.1,xsd.."decimal"))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline

    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2.1).. newline
    
    pT = pr..'10Error'
    local result, err = pcall(function () linkedwiki.addPropertyWithLiteral(pT,"2,1",xsd.."decimal") end )
    html = html .."RESULT BEGIN : "..newline ..err ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(err,'Error, it is not a number with the type xsd:decimal (example \'20.25\' or \'20\'): 2,1') ..newline

    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : without default subject" ..newline

    local subject2 = linkedwiki.getCurrentIRI().."2";

    pT = pr..'11'
    litteral='2'
    html = html ..'Call  Linkedwiki.addPropertyWithLiteral('..pT..',2,nil,nil,subject2)'..newline
    html = html .."Insert "..litteral..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,2,nil,nil,subject2))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLiteral(query,litteral) ..newline
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT,subject2))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. newline
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2).. newline


    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : text with lang tag + function getString" ..newline
    --linkedwiki.getString(iriProperty, tagLang, iriSubject)

    pT = pr..'12'
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text")'..newline
    html = html ..'Call Linkedwiki.addPropertyWithLiteral('..pT..',"text2",nil,"fr")'..newline
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text"))
    mw.log(linkedwiki.addPropertyWithLiteral(pT,"text2",nil,"fr"))
    --query= linkedwiki.getLastQuery()
    --mw.log(query)
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple'..newline
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr),2).. newline
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT), "text").. newline
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT,"en"), "text").. newline
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT,"fr"), "text2").. newline
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT,"fr",subject), "text2").. newline


    html = html .."TEST : removeSubject" ..newline
    mw.log(linkedwiki.removeSubject())

    --return html
   return "<pre>"..mw.text.nowiki( mw.text.encode( html) ).."</pre>"
end

return p
