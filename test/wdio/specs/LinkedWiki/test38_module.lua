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
function p.count(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
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


    local subject = f.args.iri or linkedwiki.getCurrentIRI();
    local subject = linkedwiki.getCurrentIRI()


    local objTest = linkedwiki.new(subject,config)
    local pTObjTemp1 = mw.title.new("Title1"):fullUrl()
    local pTObjTemp2 = mw.title.new("Title2"):fullUrl()

    local ObjTemp1 = linkedwiki.new(pTObjTemp1);
    local ObjTemp2 = linkedwiki.new(pTObjTemp2);



    mw.log(objTest:removeSubject())

    html = html .."----------------------------------------------------------------------------" ..newline
    html = html .."TEST : function print_r" ..newline
    
    
    response = {
            ["result"] = {
                ["variables"] = {
                  "s",
                  "o1",
                  "o2"
                },
                ["rows"] = {
                        {
                            ["s type"] = "uri",
                            ["s"] = "http://example.org/a",
                            ["o1 type"] = "uri",
                            ["o1"] = "http://example.org/b",
                            ["o2 type"] = "uri",
                            ["o2"] = "http://example.org/b"
                        },
                        {
                            ["s type"] = "uri",
                            ["s"] = "http://example.org/a",
                            ["o1 type"] = "uri",
                            ["o1"] = "http://example.org/b",
                            ["o2 type"] = "uri",
                            ["o2"] = "http://example.org/b"
                        }
                    }
                }
            }
    linkedwiki.print_r(response)
  
  
    html = html .."TEST : function query for reading" ..newline
   
   local result1 = linkedwiki.query("select * where {?s ?p ?v.} limit 5")
    linkedwiki.print_r(result1)
    html = html .."RESULT : " .. p.checkNumber( p.count(result1['result']['rows']),5) ..newline
   
    html = html .."TEST : function query for writing (not allow)" ..newline
   
  local query =  [[
  PREFIX ex: <http://example.com/>
      INSERT DATA {
          GRAPH <http://mygraph> {
              ex:a ex:p 12 .
          }
      }
]]

    linkedwiki.setDebug(true)
    local result, err = pcall(function () linkedwiki.query(query) end )
    html = html .."RESULT BEGIN : "..newline ..err ..newline.."END" ..newline
    html = html .."RESULT : " .. p.checkString(err,'You cannot update the database via a query via Lua.') ..newline

  mw.log(linkedwiki.removeSubject())
    html = html .."RESULT : " .. p.checkString(linkedwiki.removeSubject(),'Delete from <http://database-test1.localdomain/data>, 0 triples -- nothing to do') ..newline

   --return html
   return "<pre>"..mw.text.nowiki( mw.text.encode( html) ).."</pre>"
end

return p
