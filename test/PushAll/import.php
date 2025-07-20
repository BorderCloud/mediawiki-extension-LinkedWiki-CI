#!/usr/bin/env php
<?php
// template to generate a selenium test in order to import all pages and files before other tests

function guidv4()
{
    if (function_exists('com_create_guid') === true)
        return trim(com_create_guid(), '{}');

    $data = openssl_random_pseudo_bytes(16);
    $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // set version to 0100
    $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // set bits 6-7 to 10
    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

function importPage($title,$filename){
    $guid1 = guidv4();
    $guid2 = guidv4();
    $guid3 = guidv4();
    $guid4 = guidv4();
    $guid5 = guidv4();
    return <<<EOD
{
      "id": "$guid1",
      "comment": "",
      "command": "type",
      "target": "id=searchInput",
      "targets": [],
      "value": "$title"
    }, {
      "id": "$guid2",
      "comment": "",
      "command": "click",
      "target": "id=searchButton",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid3",
      "comment": "",
      "command": "click",
      "target": "linkText=$title",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid4",
      "comment": "",
      "command": "type",
      "target": "id=wpTextbox1",
      "targets": [],
      "value": "{{<$filename>}}"
    }, {
      "id": "$guid5",
      "comment": "",
      "command": "click",
      "target": "name=wpSave",
      "targets": [],
      "value": ""
    }
EOD;
}


function importModule($title,$filename){
    $guid1 = guidv4();
    $guid2 = guidv4();
    $guid3 = guidv4();
    $guid4 = guidv4();
    $guid5 = guidv4();
    $guid6 = guidv4();
    $guid7 = guidv4();
    $guid8 = guidv4();
    $guid9 = guidv4();
    $guid10 = guidv4();
    return <<<EOD
 {
      "id": "$guid1",
      "comment": "",
      "command": "type",
      "target": "id=searchInput",
      "targets": [],
      "value": "$title"
    }, {
      "id": "$guid2",
      "comment": "",
      "command": "click",
      "target": "id=searchButton",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid3",
      "comment": "",
      "command": "click",
      "target": "linkText=$title",
      "targets": [],
      "value": ""
    }, 
    {
      "id": "$guid4",
      "comment": "",
      "command": "pause",
      "target": "5000",
      "targets": [],
      "value": ""
    }, 
    {
      "id": "$guid5",
      "comment": "",
      "command": "storeElementCount",
      "target": "xpath=//textarea[@id='wpTextbox1'][contains(@style,'display: none')]",
      "targets": [],
      "value": "textbox1"
    },  {
      "id": "$guid6",
      "comment": "",
      "command": "if",
      "target": "\${textbox1} === 1",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid7",
      "comment": "",
      "command": "click",
      "target": "css=.oo-ui-icon-markup",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid8",
      "comment": "",
      "command": "end",
      "target": "",
      "targets": [],
      "value": ""
    },
    {
      "id": "$guid9",
      "comment": "",
      "command": "type",
      "target": "id=wpTextbox1",
      "targets": [],
      "value": "{{<$filename>}}"
    }, {
      "id": "$guid10",
      "comment": "",
      "command": "click",
      "target": "name=wpSave",
      "targets": [],
      "value": ""
    }
EOD;
}

function importFile($filename){
    global $argv;
    $guid1 = guidv4();
    $guid2 = guidv4();
    $guid3 = guidv4();
    $guid4 = guidv4();
    $guid5 = guidv4();
    $guid7 = guidv4();
    $guid8 = guidv4();
    $guid9 = guidv4();
    $pwd = ( $argv[1] ?? getcwd() );
    return <<<EOD
{
      "id": "$guid1",
      "comment": "",
      "command": "open",
      "target": "http://serverdev-mediawiki1.localdomain/wiki/Main_Page",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid2",
      "comment": "",
      "command": "click",
      "target": "css=#t-upload > a",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid3",
      "comment": "",
      "command": "type",
      "target": "id=wpUploadFile",
      "targets": [],
      "value": "$pwd/$filename"
    }, {
      "id": "$guid4",
      "comment": "",
      "command": "click",
      "target": "name=wpUpload",
      "targets": [],
      "value": ""
    },
    {
      "id": "$guid5",
      "comment": "",
      "command": "storeElementCount",
      "target": "//button[@name='wpUploadIgnoreWarning']",
      "targets": [],
      "value": "forceuploadButton"
    }, {
      "id": "$guid7",
      "comment": "",
      "command": "if",
      "target": "\${forceuploadButton} == 1",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid8",
      "comment": "",
      "command": "click",
      "target": "name=wpUploadIgnoreWarning",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid9",
      "comment": "",
      "command": "end",
      "target": "",
      "targets": [],
      "value": ""
    }
EOD;
}

?>
{
  "id": "a49eaa47-02fa-4b1d-a4a6-abf31d11efcb",
  "version": "2.0",
  "name": "suite_tests",
  "url": "http://serverdev-mediawiki1.localdomain/",
  "tests": [{
    "id": "1ccf65af-d49d-4a6f-8ce7-12ed8942e70f",
    "name": "import",
    "commands": [{
      "id": "c6e22b35-ec39-48ef-a240-c2065887d142",
      "comment": "",
      "command": "open",
      "target": "http://serverdev-mediawiki1.localdomain/",
      "targets": [],
      "value": ""
    }, {
      "id": "c63c568f-4bb0-4b74-8851-d5a58128960f",
      "comment": "",
      "command": "click",
      "target": "xpath=//li[@id='pt-login-private']/a",
      "targets": [],
      "value": ""
    }, {
      "id": "903f4c78-cb9e-4bd3-98c7-e2a2911d816a",
      "comment": "",
      "command": "type",
      "target": "id=wpName1",
      "targets": [],
      "value": "userData"
    }, {
      "id": "88e24ac4-a22d-45cd-b53f-6b6f5fc5761f",
      "comment": "",
      "command": "type",
      "target": "id=wpPassword1",
      "targets": [],
      "value": "dockerpass"
    }, {
      "id": "230b4908-9e57-4a54-9bea-e7c62b27595d",
      "comment": "",
      "command": "click",
      "target": "id=wpLoginAttempt",
      "targets": [],
      "value": ""
    }, 
    <?php
    $array = [
            
        importPage("Module:Test06 module1/doc","test06_module1doc.txt"),
        importModule("Module:Test06 module1","test06_module1.txt"),
        importPage("Module:Test07 module1/doc","test07_module1doc.txt"),
        importPage("Module:Test07 module2/doc","test07_module2doc.txt"),
        importModule("Module:Test07 module1","test07_module1.txt"),
        importModule("Module:Test07 module2","test07_module2.txt"),
        importPage("Module:Test09 module1/doc","test09_module1doc.txt"),
        importPage("Module:Test09 module2/doc","test09_module2doc.txt"),
        importModule("Module:Test09 module1","test09_module1.txt"),
        importModule("Module:Test09 module2","test09_module2.txt"),
        importPage("Template:Test02 template1","test02_template1.txt"),
        importPage("Template:Test03 template1","test03_template1.txt"),
        importPage("Template:Test03 template2","test03_template2.txt"),
        importFile("test04_image1.png"),
        importFile("test05_image1.png"),
        importFile("test05_image2.png"),
        importPage("Data:Test08 page","test08_data.txt"),
        importPage("Data:Test09 page","test09_data.txt"),
        importFile("test09_image1.png"),
        importFile("test09_image2.png"),
        importPage("Template:Test09 template1","test09_template1.txt"),
        importPage("Template:Test09 template2","test09_template2.txt"),
        importPage("Test01 page","test01_page.txt"),
        importPage("Test01 page/subpage","test01_subpage.txt"),
        importPage("Test01 page/subpage/subpage","test01_subsubpage.txt"),
        importPage("Test02 page","test02_page.txt"),
        importPage("Test03 page","test03_page.txt"),
        importPage("Test04 page","test04_page.txt"),
        importPage("Test05 page","test05_page.txt"),
        importPage("Test06 page","test06_page.txt"),
        importPage("Test07 page","test07_page.txt"),
        importPage("Test08 page","test08_page.txt"),
        importPage("Test09 page","test09_page.txt"),
        importPage("Test09 page/subpage","test09_subpage.txt"),
        importPage("Test09 page/subpage/subpage","test09_subsubpage.txt")
    ];
    echo implode(",\n",$array)
    ?>
    , {
        "id": "c4048c4c-afa1-4061-8416-f09a98488160",
        "comment": "",
        "command": "click",
        "target": "css=#pt-logout > a",
        "targets": [],
        "value": ""
    }, {
      "id": "ab3d72dd-7e2d-454c-9b7f-ee837362c376",
      "comment": "",
      "command": "close",
      "target": "",
      "targets": [],
      "value": ""
      }
    ]
  }],
  "suites": [{
    "id": "0cb0ea53-ed47-4a63-814e-200221144015",
    "name": "Default Suite",
    "persistSession": false,
    "parallel": false,
    "timeout": 30000,
    "tests": ["1ccf65af-d49d-4a6f-8ce7-12ed8942e70f"]
  }],
  "urls": ["http://serverdev-mediawiki1.localdomain/"],
  "plugins": []
}
