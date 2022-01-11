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
        result = "KO1"
    else
        if val1 ==  val2 then
            result = "OK"
        else
            result = "KO2"
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
    local rdfs = 'http://www.w3.org/2000/01/rdf-schema#'
    local wdt = 'http://www.wikidata.org/prop/direct/'

    local pr = 'http://database-test/TestFunction:'

    local html = '== TESTS =='.. newline

    --linkedwiki.setDebug(true)

    local subject = f.args.iri or linkedwiki.getCurrentIRI();
    html = html .."TEST : f.args.iri or linkedwiki.getCurrentIRI()" .. newline
    html = html .."RESULT : " .. subject .. newline

    local subject = linkedwiki.getCurrentIRI()


    local objTest = linkedwiki.new(subject,config)
    local pTObjTemp1 = mw.title.new("Title1"):fullUrl()
    local pTObjTemp2 = mw.title.new("Title2"):fullUrl()

    local ObjTemp1 = linkedwiki.new(pTObjTemp1);
    local ObjTemp2 = linkedwiki.new(pTObjTemp2);



    mw.log(objTest:removeSubject())

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkValue" ..newline
    --    function linkedwiki.checkValue(property, valueInWiki)
    local valueInWiki = 0
    local result = ""
    local pT =""

    pT = pr..'1'

    valueInWiki = "1"
    result = objTest:checkValue(pT,valueInWiki)
    html = html .."1 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value">1</div>') ..newline

    mw.log(objTest:addPropertyWithLiteral(pT,1))

    valueInWiki = "1"
    result = objTest:checkValue(pT,valueInWiki)
    html = html .."2 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">1</div>') ..newline

    valueInWiki = "2"
    result =objTest:checkValue(pT,valueInWiki)
    html = html .."3 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: 1">2</div>') ..newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkString" ..newline
    --    function objTest:checkString(property, valueInWiki, tagLang)

    pT = pr..'2'
    valueInWiki = "test"
    result = objTest:checkString(pT,valueInWiki)
    html = html .."4 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value">test</div>') ..newline

    --mw.log(objTest:addPropertyWithLiteral(pT,"test"))
    mw.log(objTest:addPropertyString(pT,"test"))

    valueInWiki = "test"
    result = objTest:checkString(pT,valueInWiki)
    html = html .."5 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">test</div>') ..newline

    valueInWiki = "testDifferent"
    result = objTest:checkString(pT,valueInWiki)
    html = html .."6 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: test">testDifferent</div>') ..newline


    --mw.log(objTest:addPropertyWithLiteral(pT,"testfr",nil,"fr"))
    mw.log(objTest:addPropertyString(pT,"testfr","fr"))

    valueInWiki = "testfr"
    result = objTest:checkString(pT,valueInWiki,"fr")
    html = html .."7 RESULT BEGIN : "..newline ..result ..newline.."END" .. newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">testfr</div>') ..newline

    valueInWiki = "testfrDifferent"
    result = objTest:checkString(pT,valueInWiki,"fr")
    html = html .."8 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: testfr">testfrDifferent</div>') ..newline


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkLabelOfInternLink" ..newline
    --  function objTest:checkLabelOfInternLink(link, propertyOfLabel, labelInWiki, tagLang)

    pT = pr..'3'
    valueInWiki = "test"
    local link = "http://example.com/link"
    result = objTest:checkLabelOfInternLink(link,pT,valueInWiki)
    html = html .."9 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value"><span class="plainlinks">[http://example.com/link test]</span></div>') ..newline

    mw.log(objTest:addPropertyWithLiteral(pT,"test"))

    valueInWiki = "test"
    result = objTest:checkLabelOfInternLink(link,pT,valueInWiki)
    html = html .."10 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://example.com/link test]</span></div>') ..newline

    valueInWiki = "test2"
    result = objTest:checkLabelOfInternLink(link,pT,valueInWiki)
    html = html .."11 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: test"><span class="plainlinks">[http://example.com/link test2]</span></div>') ..newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkIriOfExternLink" ..newline
    -- function objTest:checkIriOfExternLink(labelOfExternLink, propertyOfExternLink, externLinkInWiki)

    pT = pr..'4'
    valueInWiki = "http://example.com/test"
    result = objTest:checkIriOfExternLink("test",pT,valueInWiki)
    html = html .."12 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value">[http://example.com/test test]</div>') ..newline

    mw.log(objTest:addPropertyWithIri(pT,"http://example.com/test"))

    valueInWiki = "http://example.com/test"
    result = objTest:checkIriOfExternLink("test",pT,valueInWiki)
    html = html .."13 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">[http://example.com/test test]</div>') ..newline

    valueInWiki = "http://example.com/test2"
    result = objTest:checkIriOfExternLink("test",pT,valueInWiki)
    html = html .."14 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: http://example.com/test">[http://example.com/test2 test]</div>') ..newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkImage" ..newline
    --    function objTest:checkImage(property, valueInWiki, width, height)

    pT = pr..'5'
    valueInWiki = "http://commons.wikimedia.org/wiki/Special:FilePath/Pope%20Hadrian%20IV.jpg"
    result = objTest:checkImage(pT,valueInWiki)
    html = html .."15 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value" ><span class="plainlinks">[https://commons.wikimedia.org/wiki/File:Pope_Hadrian_IV.jpg#/media/File:Pope_Hadrian_IV.jpg http://commons.wikimedia.org/wiki/Special:FilePath/Pope%20Hadrian%20IV.jpg]</span></div>') ..newline

    mw.log(objTest:addPropertyWithIri(pT,"http://example.com/test.png"))

    valueInWiki = "http://example.com/test.png"
    result = objTest:checkImage(pT,valueInWiki)
    html = html .."16 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal" ><span class="plainlinks">[http://example.com/test.png http://example.com/test.png]</span></div>') ..newline

    valueInWiki = "http://example.com/test2.png"
    result = objTest:checkImage(pT,valueInWiki)
    html = html .."17 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" title="Currently in DB: http://example.com/test.png" data-toggle="tooltip" data-placement="bottom"><span class="plainlinks">[http://example.com/test2.png http://example.com/test2.png]</span></div>') ..newline
    
    


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkTitle" ..newline
    -- objTest:checkTitle(property, labelInWiki, tagLang)

    --objTest:setDebug(true)
    pT = pr..'6'
    local pTObjTemp1 = mw.title.new("Title1"):fullUrl()
    local pTObjTemp2 = mw.title.new("Title2"):fullUrl()

    local ObjTemp1 = linkedwiki.new(pTObjTemp1,config);
    local ObjTemp2 = linkedwiki.new(pTObjTemp2,config);

    --    mw.log(objTest:getConfig())
    --    mw.log(ObjTemp1:getConfig())
    --    mw.log(ObjTemp2:getConfig())
    mw.log(objTest:removeSubject())
    mw.log(ObjTemp1:removeSubject())
    mw.log(ObjTemp2:removeSubject())

    valueInWiki = ""
    --0 in DB
    result = objTest:checkTitle(pT,valueInWiki)
    html = html .."18 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'') ..newline

    valueInWiki = "Title1;Title2"
    --0 in DB
    result = objTest:checkTitle(pT,valueInWiki)
    html = html .."19 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value">[[Title1]], [[Title2]]</div>') ..newline

    valueInWiki = " Title1;Title2 "
    --"Title1" in DB
    -- current - pT -> pTObj
    -- pTObj - rdfs:label -> "Title1"
    mw.log(objTest:addPropertyWithIri(pT, pTObjTemp1))
    --mw.log(ObjTemp1:addPropertyWithLiteral(rdfs.."label","Title1"))
    mw.log(ObjTemp1:addPropertyString(rdfs.."label","Title1"))
  -- mw.log(linkedwiki.getLastQuery())
    result = objTest:checkTitle(pT,valueInWiki)
    html = html .."20 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: Title1">[[Title2]], <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/Title1 Title1]</span></div>') ..newline

    valueInWiki = "Title1 ; Title2"
    --"Title1;Title2" in DB
    --"Title1" in DB
    -- current - pT -> pTObj2
    -- pTObj2 - rdfs:label -> "Title2"
    mw.log(objTest:addPropertyWithIri(pT,pTObjTemp2))
    --mw.log(objTest:addPropertyWithLiteral(rdfs.."label","Title2",nil,nil,pTObj2))
    mw.log(ObjTemp2:addPropertyString(rdfs.."label","Title2"))
    result = objTest:checkTitle(pT,valueInWiki)
    html = html .."21 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/Title1 Title1]</span>, <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/Title2 Title2]</span></div>') ..newline

    valueInWiki = ""
    --"Title1;Title2" in DB
    result = objTest:checkTitle(pT,valueInWiki)
    html = html .."22 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/Title1 Title1]</span>, <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/Title2 Title2]</span></div>') ..newline


    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkUser" ..newline
--    function objTest:checkUser(property, valueInWiki)


    mw.log(objTest:removeSubject())

    pT = pr..'7'

    local pTObjTemp1 = mw.title.new("User:Firstname Surename1"):fullUrl()
    local pTObjTemp2 = mw.title.new("User:Firstname Surename2"):fullUrl()

    local ObjTemp1 = linkedwiki.new(pTObjTemp1,config)
    local ObjTemp2 = linkedwiki.new(pTObjTemp2,config)

    mw.log(objTest:removeSubject())
    mw.log(ObjTemp1:removeSubject())
    mw.log(ObjTemp2:removeSubject())

    valueInWiki = ""
    --0 in DB
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."23 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'') ..newline

    valueInWiki = "User1"
    --0 in DB
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."24 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value">[[User:User1|User1]]</div>') ..newline

    valueInWiki = "User1;User2"
    --0 in DB
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."25 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value">[[User:User1|User1]], [[User:User2|User2]]</div>') ..newline

    valueInWiki = ""
    --"User:Firstname Surename1" in DB
    -- current - pT -> pTObj
    -- pTObj - rdfs:label -> "User:Firstname Surename1"
    mw.log(objTest:addPropertyWithIri(pT, pTObjTemp1))
    mw.log(ObjTemp1:addPropertyWithLiteral(rdfs.."label","Firstname Surename1"))
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."26 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename1 Firstname Surename1]</span></div>') ..newline

    valueInWiki  = "Firstname Surename1; Firstname Surename2"
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."27 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: Firstname Surename1">[[User:Firstname Surename2|Firstname Surename2]], <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename1 Firstname Surename1]</span></div>') ..newline

    valueInWiki  = "Firstname Surename1; Firstname Surename2"
    --"User:Firstname Surename1;User:Firstname Surename2" in DB
    --"User:Firstname Surename2" in DB
    -- current - pT -> pTObj2
    -- pTObj2 - rdfs:label -> "User:Firstname Surename2"
    mw.log(objTest:addPropertyWithIri(pT,pTObjTemp2))
    mw.log(ObjTemp2:addPropertyWithLiteral(rdfs.."label","Firstname Surename2"))
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."28 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename1 Firstname Surename1]</span>, <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename2 Firstname Surename2]</span></div>') ..newline

    valueInWiki  = "Firstname Surename1; Firstname Surename2"
    --"User:Firstname Surename1;User:Firstname Surename2" in DB
    --"mailto:Firstname_Surename2@example.com" ADD in DB
    -- current - pT -> pTObj2
    -- pTObj2 - http://www.w3.org/2006/vcard/ns#email -> "mailto:Firstname_Surename2@example.com"
    mw.log(ObjTemp2:addPropertyWithIri("http://www.w3.org/2006/vcard/ns#email","mailto:Firstname_Surename2@example.com"))
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."29 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename1 Firstname Surename1]</span>, <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename2 Firstname Surename2]</span><sub><span class="plainlinks" style="font-size: large;">[mailto:Firstname_Surename2@example.com &#9993;]</span></sub></div>') ..newline

  --html = html .."RESULT BEGIN : "..newline ..ObjTemp2:getValue("http://www.w3.org/2006/vcard/ns#email") ..newline.."END" ..newline

    valueInWiki  = "Firstname Surename1; Firstname Surename2"
    --"User:Firstname Surename1;User:Firstname Surename2" in DB
    --"mailto:Firstname_Surename2@example.com" ADD in DB
    -- current - pT -> pTObj2
    -- pTObj2 - http://www.w3.org/2006/vcard/ns#email -> "mailto:Firstname_Surename2@example.com"
    mw.log(ObjTemp2:addPropertyWithIri("http://www.w3.org/2006/vcard/ns#email","mailto:Firstname_Surename2Bis@example.com"))
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."30 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename1 Firstname Surename1]</span>, <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename2 Firstname Surename2]</span><sub><span class="plainlinks" style="font-size: large;">[mailto:Firstname_Surename2@example.com &#9993;]</span></sub><sub><span class="plainlinks" style="font-size: large;">[mailto:Firstname_Surename2Bis@example.com &#9993;]</span></sub></div>') ..newline

    valueInWiki = ""
    --"Title1;Title2" in DB
    result = objTest:checkUser(pT,valueInWiki)
    html = html .."31 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename1 Firstname Surename1]</span>, <span class="plainlinks">[http://serverdev-mediawiki1.localdomain/wiki/User:Firstname_Surename2 Firstname Surename2]</span><sub><span class="plainlinks" style="font-size: large;">[mailto:Firstname_Surename2@example.com &#9993;]</span></sub><sub><span class="plainlinks" style="font-size: large;">[mailto:Firstname_Surename2Bis@example.com &#9993;]</span></sub></div>') ..newline


    html = html .."----------------------------------------------------------------------------" ..newline

    html = html .."TEST : checkItem" ..newline
    --    function objTest:checkItem(property, valueInWiki, tagLang)

    mw.log(objTest:removeSubject())
  --objTest:setDebug(true)

    pT = pr..'8'
    local wd = "http://www.wikidata.org/entity/"
    local pTObjTemp1 = wd.."Q1"
    local pTObjTemp2 = wd.."Q2"
    local ObjTemp1 = linkedwiki.new(pTObjTemp1,config)
    local ObjTemp2 = linkedwiki.new(pTObjTemp2,config)

    mw.log(objTest:removeSubject())
    mw.log(ObjTemp1:removeSubject())
    mw.log(ObjTemp2:removeSubject())

    -- TEST 32
    --mw.log("TEST 32")
    valueInWiki = ""
    --0 in DB
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."32 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'') ..newline

    -- TEST 33

    valueInWiki = "Q1 ; Q2 "
    --0 in DB
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."33 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    -- mw.log("TEST 33")
    -- mw.log(result)

    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: "><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span>, <span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q2 Earth]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q2 Q2])</small></span></div>') ..newline
    -- TEST 34
    valueInWiki =  ""
    --"universe" in DB
    -- current - pT -> pTObj
    -- pTObj - rdfs:label -> "universe"
    mw.log(objTest:addPropertyWithIri(pT, pTObjTemp1))
    mw.log(ObjTemp1:addPropertyWithLiteral(rdfs.."label","universe"))
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."34 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline

    --mw.log("TEST 34")
    --mw.log(result)

    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span></div>') ..newline

    -- TEST 35
    valueInWiki =  "Q1;Q2"
    --"universe" in DB
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."35 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    --mw.log(objTest:addPropertyWithIri(pT,pTObjTemp2))

    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: universe"><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span>, <span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q2 Earth]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q2 Q2])</small></span></div>') ..newline

    -- TEST 36
    valueInWiki = " Q1 ; Q2 "
    --"Title1;Title2" in DB
    --"Title1" in DB
    -- current - pT -> pTObj2
    -- pTObj2 - rdfs:label -> "Title2"
    mw.log(objTest:addPropertyWithIri(pT,pTObjTemp2))
    mw.log(ObjTemp2:addPropertyWithLiteral(rdfs.."label","Earth"))
    result = objTest:checkItem(pT,valueInWiki)

html = html .."36 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span>, <span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q2 Earth]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q2 Q2])</small></span></div>') ..newline

    -- TEST 37
    valueInWiki = ""
    --"Title1;Title2" in DB
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."37 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal"><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span>, <span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q2 Earth]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q2 Q2])</small></span></div>') ..newline

    --mw.log("TEST 37")
    --mw.log(result)

    -- TEST 38
    valueInWiki = "Title3"
    --"Title1;Title2" in DB
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."38 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: universe, Earth"><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span>, <span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q2 Earth]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q2 Q2])</small></span>, Title3</div>') ..newline

    --mw.log("TEST 38")
    --mw.log(result)

    -- TEST 39
    valueInWiki = "Title3;Title4"
    --"Title1;Title2" in DB
    result = objTest:checkItem(pT,valueInWiki)
    html = html .."39 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: universe, Earth"><span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q1 universe]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q1 Q1])</small></span>, <span class="plainlinks">[https://www.wikidata.org/wiki/Special:GoToLinkedPage/enwiki/Q2 Earth]</span><span class="plainlinks"><small>([http://www.wikidata.org/entity/Q2 Q2])</small></span>, Title3, Title4</div>') ..newline

        --mw.log("TEST 39")
        --mw.log(result)

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : printDateInWiki" ..newline
    --Linkedwiki:printDateInWiki(format, valueInWiki, valueInDB)

    local dateFormat = "d M Y"
    --  {{#time:d M Y|2004-12-06}}
    --"2004-12-06"^^xsd..'date'
    result = objTest:printDateInWiki( "2004-12-06", "2004-12-06", dateFormat)
    html = html .."40 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">06 Dec 2004</div>') ..newline

    result = objTest:printDateInWiki("2004-12-07", "2004-12-06",dateFormat)
    html = html .."41 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: 06 Dec 2004">07 Dec 2004</div>') ..newline

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : checkDate" ..newline

    dateFormat = "d M Y"
    local pTDate = 'http://example.com/date'
    local pTDateTime = 'http://example.com/dateTime'

    valueInWiki = ""
    --0 in DB
    result = objTest:checkDate(pTDate,valueInWiki, dateFormat)
    html = html .."42 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'') ..newline

    valueInWiki = "2004-12-06"
    --0 in DB
    result = objTest:checkDate(pTDate,valueInWiki, dateFormat)
    html = html .."BEGIN : "..newline ..valueInWiki ..newline.."END" ..newline
    html = html .."43 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div>06 Dec 2004</div>') ..newline

    valueInWiki =  ""
    --"2004-12-06" in DB
    -- current - pT ->  "2004-12-06"
    mw.log(objTest:addProperty(pTDate,"2004-12-06",xsd..'date'))
    result = objTest:checkDate(pTDate,valueInWiki, dateFormat)
    html = html .."44 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div>06 Dec 2004</div>') ..newline

    valueInWiki =  "2004-12-06"
    --"2004-12-06" in DB
    result = objTest:checkDate(pTDate,valueInWiki, dateFormat)
    html = html .."45 RESULT BEGIN11 : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">06 Dec 2004</div>') ..newline

    --"2004-12-06" in DB
    -- current - pT ->  "2004-12-06"
    mw.log(objTest:addProperty(pTDateTime,"2004-12-06T00:00:00Z",xsd..'dateTime'))
    result = objTest:checkDate(pTDateTime,valueInWiki, dateFormat)
    html = html .."46 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-value-equal">06 Dec 2004</div>') ..newline

    valueInWiki =  ""
    --"2004-12-06T00:00:00Z" in DB
    result = objTest:checkDate(pTDateTime,valueInWiki, dateFormat)
    html = html .."47 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div>06 Dec 2004</div>') ..newline

    valueInWiki =  "2004-12-07"
    --"2004-12-06" in DB
    result = objTest:checkDate(pTDate,valueInWiki, dateFormat)
    html = html .."48 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline

    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: 06 Dec 2004">07 Dec 2004</div>') ..newline

    local idConfigWikidata ='http://www.wikidata.org'
    local taglang ='fr'
    iriWikidata = wd .. "Q132845"
    objWikidata = linkedwiki.new(iriWikidata,idConfigWikidata,taglang)
    result = objWikidata:checkDate(wdt.."P569","1100-1-1",dateFormat)
    
    mw.log(result)
    html = html .."49 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div class="mw-ext-linkedwiki-new-value mw-ext-linkedwiki-tooltip" data-toggle="tooltip" data-placement="bottom" title="Currently in DB: not a date">01 Jan 1100</div>') ..newline

    objWikidata = linkedwiki.new(iriWikidata,idConfigWikidata,taglang)
    result = objWikidata:checkDate(wdt.."P569","",dateFormat)
    html = html .."50 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div>Error, it is not a date/datetime (example \'2021-11-20\' or \'2021-10-20T14:14:52+00:00\'): http://www.wikidata.org/.well-known/genid/e09b6493040f5c09945d1463d1433601</div>') ..newline

    objWikidata = linkedwiki.new(iriWikidata,idConfigWikidata,taglang)
    result = objWikidata:checkDate(wdt.."P569","Truc",dateFormat)
     html = html .."51 RESULT BEGIN : "..newline ..result ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(result,'<div>Error, it is not a date (example \'2021-11-20\'): Truc</div>') ..newline

    local result, err = pcall(function () objTest:addProperty(pTDate,"2004-TRUC-06",xsd..'date') end )
    html = html .."52 RESULT BEGIN : "..newline ..err ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(err,'Error, it is not a date with the type xsd:date (example \'2021-11-20\'): 2004-TRUC-06') ..newline

    local result, err = pcall(function () objTest:addProperty(pTDateTime,"2004-12-06TTRUC:00:00Z",xsd..'dateTime') end )
    html = html .."53 RESULT BEGIN : "..newline ..err ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(err,'Error, it is not a date with the type xsd:datetime (example \'2021-10-20T14:14:52+00:00\'): 2004-12-06TTRUC:00:00Z') ..newline

    mw.log(linkedwiki.getLastQuery())
    mw.log(objTest:removeSubject())

   --return html
   return "<pre>"..mw.text.nowiki( mw.text.encode( html) ).."</pre>"

end

return p
