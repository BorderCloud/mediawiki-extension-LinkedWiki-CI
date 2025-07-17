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

function startsWith( $haystack, $needle ) {
    $length = strlen( $needle );
    return substr( $haystack, 0, $length ) === $needle;
}
function endsWith( $haystack, $needle ) {
    $length = strlen( $needle );
    if( !$length ) {
        return true;
    }
    return substr( $haystack, -$length ) === $needle;
}
function assertPushCompleted()
{
    $guid1 = guidv4();
    $guid2 = guidv4();
    $guid3 = guidv4();
    return <<<EOD
      {
      "id": "$guid1",
      "comment": "",
      "command": "click",
      "target": "css=tr:nth-child(2) .pushallButton",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid2",
      "comment": "",
      "command": "waitForText",
      "target": "css=tr:nth-child(2) .pushallButton",
      "targets": [],
      "value": "Push completed"
    }
EOD;
}

function assertLinkPage($title)
{
    $guid1 = guidv4();
    return <<<EOD
     {
      "id": "$guid1",
      "comment": "",
      "command": "verifyText",
      "target": "linkText=$title",
      "targets": [],
      "value": "$title"
    }
EOD;
}

function assertContent($title,$filename,$first)
{
    $guid1 = guidv4();
    $guid2 = guidv4();
    $guid3 = guidv4();
    $guid4 = guidv4();
    $guid5 = guidv4();
    $guid6 = guidv4();
    $guid7 = guidv4();
    $guid8 = guidv4();
    $guid9 = guidv4();
    if($first){
        $firstWindow = <<<EOD
      ,"opensWindow": true,
      "windowHandleName": "win7867",
      "windowTimeout": 2000
EOD;
    }else{
        $firstWindow = "";
    }
    
    $result = <<<EOD
{
      "id": "$guid1",
      "comment": "",
      "command": "click",
      "target": "linkText=$title",
      "targets": [],
      "value": ""
      $firstWindow
    }, {
      "id": "$guid2",
      "comment": "",
      "command": "storeWindowHandle",
      "target": "root",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid3",
      "comment": "",
      "command": "selectWindow",
      "target": "handle=\${win7867}",
      "targets": [],
      "value": ""
    }, 
EOD;
    if(startsWith($title,"Module:") && ! endsWith($title,"/doc")){
        $result .= <<<EOD

{
      "id": "$guid9",
      "comment": "",
      "command": "pause",
      "target": "5000",
      "targets": [],
      "value": ""
    }, 
        {
      "id": "$guid5",
      "comment": "",
      "command": "click",
      "target": "css=#ca-viewsource",
      "targets": [],
      "value": ""
    },         {
      "id": "$guid6",
      "comment": "",
      "command": "click",
      "target": "css=.oo-ui-icon-markup",
      "targets": [],
      "value": ""
    },{
      "id": "$guid8",
      "comment": "",
      "command": "verifyText",
      "target": "id=wpTextbox1",
      "targets": [],
      "value": "{{<$filename>}}"
    }
EOD;
    }else if(startsWith($title,"File:")){
        $result .= <<<EOD
    {
        "id": "$guid4",
      "comment": "",
      "command": "verifyText",
      "target": "id=firstHeading",
      "targets": [],
      "value": "$title"
    }
EOD;
    }else{
        $result .= <<<EOD
        {
      "id": "$guid5",
      "comment": "",
      "command": "click",
      "target": "css=#ca-viewsource",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid6",
      "comment": "",
      "command": "verifyText",
      "target": "id=wpTextbox1",
      "targets": [],
      "value": "{{<$filename>}}"
    }
EOD;
    }
    $result .= <<<EOD
    , {
      "id": "$guid7",
      "comment": "",
      "command": "selectWindow",
      "target": "handle=\${root}",
      "targets": [],
      "value": ""
    }
EOD;
    return $result;
}

function testPage($title,$array,$first = false){
    $guid1 = guidv4();
    $guid2 = guidv4();
    $guid3 = guidv4();
    $guid4 = guidv4();
    $guid5 = guidv4();
    $guid6 = guidv4();

    $arrayAssert = [];
    $arrayAssert[] = <<<EOD
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
      "target": "css=#p-cactions",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid4",
      "comment": "",
      "command": "click",
      "target": "linkText=Push",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid5",
      "comment": "",
      "command": "pause",
      "target": "10000",
      "targets": [],
      "value": ""
    }, {
      "id": "$guid6",
      "comment": "",
      "command": "click",
      "target": "id=buttonCheckAll",
      "targets": [],
      "value": ""
    }
EOD;
    foreach ($array as $title=>$file) {
        $arrayAssert[] = assertLinkPage($title);
    }
    $arrayAssert[] = assertPushCompleted();
    $firstWindow = $first;
    foreach ($array as $title=>$file) {
        $arrayAssert[] = assertContent($title,$file,$firstWindow);
        $firstWindow = false;
    }
    return implode(",\n",$arrayAssert);

}
?>
{
  "id": "a49eaa47-02fa-4b1d-a4a6-abf31d11efcb",
  "version": "2.0",
  "name": "suite_tests",
  "url": "http://serverdev-mediawiki1.localdomain/",
  "tests": [{
    "id": "1ccf65af-d49d-4a6f-8ce7-12ed8942e70f",
    "name": "Tests all",
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

        testPage("Test01 page",[
            "Test01 page" => "test01_page.txt",
            "Test01 page/subpage" => "test01_subpage.txt",
            "Test01 page/subpage/subpage" => "test01_subsubpage.txt",
        ],true)
        ,
        testPage("Test02 page",[
            "Test02 page" => "test02_page.txt",
            "Template:Test02 template1" => "test02_template1.txt",
        ]),
        testPage("Test03 page",[
            "Test03 page" => "test03_page.txt",
            "Template:Test03 template1" => "test03_template1.txt",
            "Template:Test03 template2" => "test03_template2.txt",
        ]),
        testPage("Test04 page",[
            "Test04 page" => "test04_page.txt",
            "File:Test04 image1.png" => "test04_image1.png"
        ]),
        testPage("Test05 page",[
            "Test05 page" => "test05_page.txt",
            "File:Test05 image1.png" => "test05_image1.png",
            "File:Test05 image2.png" => "test05_image2.png",
        ]),
        testPage("Test06 page",[
            "Test06 page" => "test06_page.txt",
            "Module:Test06 module1/doc" => "test06_module1doc.txt",
            "Module:Test06 module1" => "test06_module1.txt",
        ]),
        testPage("Test07 page",[
            "Test07 page" => "test07_page.txt",
            "Module:Test07 module1/doc" => "test07_module1doc.txt",
            "Module:Test07 module2/doc" => "test07_module2doc.txt",
            "Module:Test07 module1" => "test07_module1.txt",
            "Module:Test07 module2" => "test07_module2.txt",
        ]),
        testPage("Test08 page",[
            "Test08 page" => "test08_page.txt",
            "Data:Test08 page" => "test08_data.txt",
        ]),
        testPage("Test09 page",[
            "Test09 page" => "test09_page.txt",
            "Data:Test09 page" => "test09_data.txt",
            "File:Test09 image1.png" => "test09_image1.png",
            "File:Test09 image2.png" => "test09_image2.png",
            "Template:Test09 template1" => "test09_template1.txt",
            "Template:Test09 template2" => "test09_template2.txt",
            "Module:Test09 module1/doc" => "test09_module1doc.txt",
            "Module:Test09 module2/doc" => "test09_module2doc.txt",
            "Module:Test09 module1" => "test09_module1.txt",
            "Module:Test09 module2" => "test09_module2.txt",
            "Test09 page/subpage" => "test09_subpage.txt",
            "Test09 page/subpage/subpage" => "test09_subsubpage.txt"
        ])
    ];
    echo implode(",\n",$array)
    ?>
    , {
      "id": "60b3ec00-3d04-4ab3-94a2-832c05b0838f",
      "comment": "",
      "command": "type",
      "target": "id=searchInput",
      "targets": [],
      "value": "Test09 page"
    }, {
      "id": "39a12a5e-69b2-4e68-9ae8-690adfd3d5f1",
      "comment": "",
      "command": "click",
      "target": "id=searchButton",
      "targets": [],
      "value": ""
    }, {
      "id": "25162a6b-17b4-46a9-9a25-0b29c7f412f3",
      "comment": "",
      "command": "click",
      "target": "css=#p-cactions",
      "targets": [],
      "value": ""
    }, {
      "id": "881d6060-15e3-44e4-9650-3826d141942d",
      "comment": "",
      "command": "click",
      "target": "linkText=Push",
      "targets": [],
      "value": ""
    }, {
      "id": "881d6060-15e3-44e4-9650-3826d141942e",
      "comment": "",
      "command": "pause",
      "target": "10000",
      "targets": [],
      "value": ""
    },
    {
      "id": "25162a6b-17b4-46a9-9a25-0b29c7f412ff",
      "comment": "",
      "command": "click",
      "target": "id=forcePush",
      "targets": [],
      "value": ""
    }, {
      "id": "881d6060-15e3-44e4-9650-3826d14194ff",
      "comment": "",
      "command": "click",
      "target": "id=buttonCheckAll",
      "targets": [],
      "value": ""
    } ,
    <?php
    echo assertPushCompleted(); 
    ?>
    ,{
        "id": "c4048c4c-afa1-4061-8416-f09a98488160",
        "comment": "",
        "command": "click",
        "target": "css=#pt-logout",
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
    "timeout": 10000,
    "tests": ["1ccf65af-d49d-4a6f-8ce7-12ed8942e70f"]
  }],
  "urls": ["http://serverdev-mediawiki1.localdomain/"],
  "plugins": []
}
