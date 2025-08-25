'use strict';

import fs from 'fs';
import ImportWiki from '../../pageobjects/importwiki.js';
import ImportWikiConfig from '../../pageobjects/importwikiconfig.js';
import LoginPageMediawiki1 from '../../pageobjects/login.page.mediawiki1.js';
import MainPage from '../../pageobjects/main.page.js';

describe('Mediawiki Test Suite', function () {

    const pathFiles = './specs/PushAll';
    const imp = new ImportWiki(browser.options.params.urlWiki1,pathFiles);

    before(async () => {
        // Import the pages in the Wiki1
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameAdmin,
            browser.options.params.password
        );

        await browser.pause(10000);

        // Test 01
        await imp.importPage("Test01 page","test01_page.txt");
        await imp.importPage("Test01 page/subpage","test01_subpage.txt");
        await imp.importPage("Test01 page/subpage/subpage","test01_subsubpage.txt");
        
        // Test 02
        await imp.importPage("Template:Test02 template1","test02_template1.txt");
        await imp.importPage("Test02 page","test02_page.txt");


        // Test 03
        await imp.importPage("Template:Test03 template1","test03_template1.txt");
        await imp.importPage("Template:Test03 template2","test03_template2.txt");
        await imp.importPage("Test03 page","test03_page.txt");

        // Test 04
        await imp.importFile("test04_image1.png");
        await imp.importPage("Test04 page","test04_page.txt");

        // Test 05
        await imp.importFile("test05_image1.png");
        await imp.importFile("test05_image2.png");
        await imp.importPage("Test05 page","test05_page.txt");

        // Test 06
        await imp.importModule("Module:Test06 module1","test06_module1.txt");
        await imp.importPage("Module:Test06 module1/doc","test06_module1doc.txt");
        await imp.importPage("Test06 page","test06_page.txt");

        // Test 07
        await imp.importModule("Module:Test07 module1","test07_module1.txt");
        await imp.importModule("Module:Test07 module2","test07_module2.txt");
        await imp.importPage("Module:Test07 module1/doc","test07_module1doc.txt");
        await imp.importPage("Module:Test07 module2/doc","test07_module2doc.txt");
        await imp.importPage("Test07 page","test07_page.txt");

        // Test 08
        await imp.importPage("Data:Test08 page","test08_data.txt");
        await imp.importPage("Test08 page","test08_page.txt");

        // Test 09
        await imp.importFile("test09_image1.png");
        await imp.importFile("test09_image2.png");
        await imp.importModule("Module:Test09 module1","test09_module1.txt");
        await imp.importModule("Module:Test09 module2","test09_module2.txt");
        await imp.importPage("Module:Test09 module1/doc","test09_module1doc.txt");
        await imp.importPage("Module:Test09 module2/doc","test09_module2doc.txt");
        await imp.importPage("Data:Test09 page","test09_data.txt");
        await imp.importPage("Template:Test09 template1","test09_template1.txt");
        await imp.importPage("Template:Test09 template2","test09_template2.txt");
        await imp.importPage("Test09 page","test09_page.txt");
        await imp.importPage("Test09 page/subpage","test09_subpage.txt");
        await imp.importPage("Test09 page/subpage/subpage","test09_subsubpage.txt");
        
        await MainPage.logout();

        // Insert the config
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameData,
            browser.options.params.password
        );

        await ImportWikiConfig.addWikiConfig(
            "wiki2",
            "http://serverdev-mediawiki2.localdomain/wiki/",
            "http://serverdev-mediawiki2.localdomain/w/api.php",
            "UserData@mediawiki1",
            "ff38s9u4feh07vjs2s6t88dh2pv5cfgv"
        )
        await ImportWikiConfig.addWikiConfig(
            "wiki2Bis",
            "http://serverdev-mediawiki2.localdomain/wiki/",
            "http://serverdev-mediawiki2.localdomain/w/api.php",
            "UserData@mediawiki1",
            "ff38s9u4feh07vjs2s6t88dh2pv5cfgv"
        )
        await MainPage.logout();

        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameData,
            browser.options.params.password
        );
    });

    after(async () => {
        await MainPage.logout();
    });

    async function pushAndVerify(mainPageTitle, pagesToVerify) {
        await browser.$('#searchInput').setValue(mainPageTitle);
        await browser.$('#searchButton').click();
        await browser.$('#p-cactions').click();
        await browser.$('a=Push').click();
        // await browser.pause(10000);
        await browser.$('#buttonCheckAll').click();
        await browser.$('tr:nth-child(2) .pushallButton').waitForExist({ timeout: 30000 });
        await browser.$('tr:nth-child(2) .pushallButton').click();
        await browser.waitUntil(async function () {
            return (await $('tr:nth-child(2) .pushallButton').getText()) === 'Push completed';
        }, { timeout: 30000 });

        for (const [title, filename] of Object.entries(pagesToVerify)) {
            const isModule = title.startsWith("Module:");
            const isFile = title.startsWith("File:");
            const isDoc = title.endsWith("/doc");

            // get window handle
            const tabWiki1 = await browser.getWindowHandle()
            const link = browser.$(`(//a[contains(text(), '${title}')])[1]`)
            const urlpageWiki2 = await link.getAttribute('href');
            // http://serverdev-mediawiki2.localdomain/wiki/Test09_page
            await browser.newWindow(urlpageWiki2);

            // await browser.switchWindow(urlpageWiki2);

            if (isFile) {
                // await browser.$('#firstHeading').waitForExist({ timeout: 30000 });
                const element =  await browser.$('#firstHeading');
                const actualValue = await element.getText();
                await browser.closeWindow();
                await browser.switchWindow(tabWiki1);
                // await expect(browser.$('#firstHeading')).toHaveText(title);
                expect(actualValue).toEqual(title);
            } else {

                await browser.$('#ca-viewsource').click();
                if (isModule && !isDoc) {
                    // await browser.pause(5000);
                    const elementCount = (await browser.$$("textarea#wpTextbox1[style*='display: none']")).length;
                    if (elementCount === 1) {
                        await browser.$('.oo-ui-icon-markup').click();
                    }
                }
                const expectedText = fs.readFileSync(`./specs/PushAll/${filename}`, 'utf8');
                const element = await browser.$('#wpTextbox1');
                const actualValue = await element.getValue();
                await browser.closeWindow();
                await browser.switchWindow(tabWiki1);
                expect(actualValue.trim()).toEqual(expectedText.trim());
            }
        }
    }

    // Test for Test01 page and its subpages
    it('should test Test01 page', async () => {
        await pushAndVerify('Test01 page', {
            "Test01 page": "test01_page.txt",
            "Test01 page/subpage": "test01_subpage.txt",
            "Test01 page/subpage/subpage": "test01_subsubpage.txt",
        });
    });

    // Test for Test02 page and templates
    it('should test Test02 page', async () => {
        await pushAndVerify('Test02 page', {
            "Test02 page": "test02_page.txt",
            "Template:Test02 template1": "test02_template1.txt",
        });
    });

    // Test for Test03 page and templates
    it('should test Test03 page', async () => {
        await pushAndVerify('Test03 page', {
            "Test03 page": "test03_page.txt",
            "Template:Test03 template1": "test03_template1.txt",
            "Template:Test03 template2": "test03_template2.txt",
        });
    });

    // Test for Test04 page and image
    it('should test Test04 page', async () => {
        await pushAndVerify('Test04 page', {
            "Test04 page": "test04_page.txt",
            "File:Test04 image1.png": "test04_image1.png"
        });
    });

    // Test for Test05 page and images
    it('should test Test05 page', async () => {
        await pushAndVerify('Test05 page', {
            "Test05 page": "test05_page.txt",
            "File:Test05 image1.png": "test05_image1.png",
            "File:Test05 image2.png": "test05_image2.png",
        });
    });

    // Test for Test06 page and module
    it('should test Test06 page', async () => {
        await pushAndVerify('Test06 page', {
            "Test06 page": "test06_page.txt",
            "Module:Test06 module1/doc": "test06_module1doc.txt",
            "Module:Test06 module1": "test06_module1.txt",
        });
    });

    // Test for Test07 page and modules
    it('should test Test07 page', async () => {
        await pushAndVerify('Test07 page', {
            "Test07 page": "test07_page.txt",
            "Module:Test07 module1/doc": "test07_module1doc.txt",
            "Module:Test07 module2/doc": "test07_module2doc.txt",
            "Module:Test07 module1": "test07_module1.txt",
            "Module:Test07 module2": "test07_module2.txt",
        });
    });

    // Test for Test08 page and data
    it('should test Test08 page', async () => {
        await pushAndVerify('Test08 page', {
            "Test08 page": "test08_page.txt",
            "Data:Test08 page": "test08_data.txt",
        });
    });

    // Test for Test09 page and everything
    it('should test Test09 page', async () => {
        await pushAndVerify('Test09 page', {
            "Test09 page": "test09_page.txt",
            "Data:Test09 page": "test09_data.txt",
            "File:Test09 image1.png": "test09_image1.png",
            "File:Test09 image2.png": "test09_image2.png",
            "Template:Test09 template1": "test09_template1.txt",
            "Template:Test09 template2": "test09_template2.txt",
            "Module:Test09 module1/doc": "test09_module1doc.txt",
            "Module:Test09 module2/doc": "test09_module2doc.txt",
            "Module:Test09 module1": "test09_module1.txt",
            "Module:Test09 module2": "test09_module2.txt",
            "Test09 page/subpage": "test09_subpage.txt",
            "Test09 page/subpage/subpage": "test09_subsubpage.txt"
        });
    });
});