'use strict';

import LoginPageMediawiki1 from '../../pageobjects/login.page.mediawiki1.js';
import MainPage from '../../pageobjects/main.page.js';
import EditPage from '../../pageobjects/edit.page.js';
import fs from 'fs';
import path from 'path';

import ImportWiki from '../../pageobjects/importwiki.js';

describe('Suite tests for LinkedWiki pages', function () {

    const pathFiles = './specs/LinkedWiki';
    const imp = new ImportWiki(browser.options.params.urlWiki1, pathFiles);

    async function clearGraph() {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await browser.pause(3000);
        await $('//*[@id="buttonClearNamedGraph"]/a').click();
        await $(`//pre[contains(.,'Clear graph <http://database-test1.localdomain/data> -- done')]`).waitForExist({ timeout: 30000 });
    }

    before(async () => {
        await LoginPageMediawiki1.open();
        await browser.pause(1000);
        await LoginPageMediawiki1.login(
            browser.options.params.usernameData,
            browser.options.params.password
        );

        await clearGraph();
    });

    after(async () => {
        await browser.url(browser.options.params.urlWiki1);
        await MainPage.logout();
    });


    it('test00_config', async () => {
        await $(`a=Special pages`).click();
        await $(`a=LinkedWiki configuration`).click();
        await expect($(`//div[@id='mw-content-text']/table[2]/tbody/tr[3]/td[2]`)).toHaveText(`Enable`);
        await expect($(`//div[@id='mw-content-text']/table[2]/tbody/tr[6]/td[2]`)).toHaveText(`http://www.example.org/sparql`);
        await expect($(`//div[@id='mw-content-text']/table[2]/tbody/tr[8]/td[2]`)).toHaveText(`see file: LocalSettings.php`);
        await expect($(`//div[@id='mw-content-text']/table[2]/tbody/tr[9]/td[2]`)).toHaveText(`see file: LocalSettings.php`);
        await expect($(`//div[@id='mw-content-text']/table/tbody/tr[11]/td[2]`)).toHaveText(`POST`);
        await expect($(`//div[@id='mw-content-text']/table/tbody/tr[12]/td[2]`)).toHaveText(`POST`);
        await expect($(`//div[@id='mw-content-text']/table/tbody/tr[13]/td[2]`)).toHaveText(`query`);
        await expect($(`//div[@id='mw-content-text']/table/tbody/tr[14]/td[2]`)).toHaveText(`update`);
        await expect($(`//div[@id='mw-content-text']/table[2]/tbody/tr[15]/td[2]`)).toHaveText(`SimpleStorageMethod`);
        await expect($(`//table[2]/tbody/tr[17]/td[2]/pre[contains(.,'INSERT DATA')]`)).toBeExisting();
        await expect($(`//table[2]/tbody/tr[18]/td[2]/pre[contains(.,'SELECT DISTINCT  ?value')]`)).toBeExisting();
        await expect($(`//table[2]/tbody/tr[19]/td[2]/pre[contains(.,'SELECT DISTINCT  ?value')]`)).toBeExisting();
        await expect($(`//table[2]/tbody/tr[20]/td[2]/pre[contains(.,'SELECT DISTINCT  ?value')]`)).toBeExisting();
        await expect($(`//div[@id='mw-content-text']/table/tbody/tr[22]/td[2]`)).toHaveText(`en`);
        await expect($(`.wikitable:nth-child(10) tr:nth-child(2) > td`)).toHaveText(`http://database-test1.localdomain/data`);
        await expect($(`.wikitable:nth-child(8) tr:nth-child(6) > td:nth-child(2)`)).toHaveText(`https://query.wikidata.org/sparql`);
        await expect($(`.wikitable:nth-child(8) tr:nth-child(11) > td:nth-child(2)`)).toHaveText(`GET`);
        await expect($(`.wikitable:nth-child(8) tr:nth-child(15) > td:nth-child(2)`)).toHaveText(`WikidataStorageMethod`);
        await expect($(`//div[@id='mw-content-text']/table/tbody/tr[2]/td[2]`)).toHaveText(`Disable`);
    });

    it('test01', async () => {
        await imp.importPage("Test01 page","test01_page.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[16]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
    });

    it('test02', async () => {
        await imp.importPage("Test02 page","test02_page.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[6]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
    });

    it('test03', async () => {
        await imp.importPage("Test03 page","test03_page.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[6]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
    });

    it('test04', async () => {
        await imp.importPage("Test04 page","test04_page.txt");
        await expect($(`pre`)).toHaveText(`The configuration of http://unknown.org is not found in the file LinkedWiki/extension.json or in the LocalSettings.php.`);
    });

    it('test05', async () => {
        await imp.importPage("Test05 page","test05_page.txt");
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'where { <http://')]`).waitForExist({ timeout: 30000 });
    });

    it('test06', async () => {
        await imp.importPage("Test06 page","test06_page.txt");
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'where { <http://')]`).waitForExist({ timeout: 30000 });
    });

    it('test07', async () => {
        await imp.importPage("Test07 page","test07_page.txt");
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'where { <http://')]`).waitForExist({ timeout: 30000 });
    });

    it('test08', async () => {
        await imp.importPage("Test08 page","test08_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th`)).toHaveText(`name1`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[2]`)).toHaveText(`name2`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[3]`)).toHaveText(`name3`);
    });

    it('test09', async () => {
        await imp.importPage("Test09 page","test09_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th`)).toHaveText(`name1`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[2]`)).toHaveText(`name2`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[3]`)).toHaveText(`name3`);
    });

    it('test10', async () => {
        await imp.importPage("Test10 page","test10_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[1]`)).toHaveText(`name1`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[2]`)).toHaveText(`name2`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[3]`)).toHaveText(`name3`);
    });

    it('test11', async () => {
        await imp.importPage("Test11 page","test11_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th`)).toHaveText(``)
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[2]`)).toHaveText(`name2`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[3]`)).toHaveText(`name3`);
    });

    it('test12', async () => {
        await imp.importPage("Test12 page","test12_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th`)).toHaveText(``)
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[2]`)).toHaveText(`name2`);
        // Selenium IDE: verifyText | xpath=//div[@id='mw-content-text']/div/table/thead/tr/th[3] | name3
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[3]`)).toHaveText(`name3`);
    });

    it('test13', async () => {
        await imp.importPage("Test13 page","test13_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th`)).toHaveText(``)
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[2]`)).toHaveText(`name2`);
        await expect($(`//div[@id='mw-content-text']/div/table/thead/tr/th[3]`)).toHaveText(`name3`);
    });

    it('test14', async () => {
        await imp.importPage("Template:Test14 page template","test14_template.txt");
        await imp.importPage("Test14 page","test14_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`th`)).toHaveText(`Name1`);
    });

    it('test15', async () => {
        await imp.importPage("Template:Test15 page template","test15_template.txt");
        await imp.importPage("Test15 page","test15_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`th`)).toHaveText(`Name1`);
    });

    it('test16', async () => {
        await imp.importPage("Template:Test16 page template","test16_template.txt");
        await imp.importPage("Test16 page","test16_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`th`)).toHaveText(`Name1`);
    });

    it('test17', async () => {
        await imp.importPage("Template:Test17 page template1","test17_template1.txt");
        await imp.importPage("Template:Test17 page template2","test17_template2.txt");
        await imp.importPage("Test17 page","test17_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
    });

    it('test18', async () => {
        await imp.importPage("Template:Test18 page template1","test18_template1.txt");
        await imp.importPage("Template:Test18 page template2","test18_template2.txt");
        await imp.importPage("Test18 page","test18_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
    });

    it('test19', async () => {
        await imp.importPage("Template:Test19 page template1","test19_template1.txt");
        await imp.importPage("Template:Test19 page template2","test19_template2.txt");
        await imp.importPage("Test19 page","test19_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
    });

    it('test20', async () => {
        await imp.importPage("Test20 page","test20_page.txt");
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'INPUT WIKI:')]`).waitForExist({ timeout: 30000 });
    });

    it('test21', async () => {
        await imp.importPage("Test21 page","test21_page.txt");
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'INPUT WIKI:')]`).waitForExist({ timeout: 30000 });
    });

    it('test22', async () => {
        await imp.importPage("Test22 page","test22_page.txt");
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'INPUT WIKI:')]`).waitForExist({ timeout: 30000 });
    });

    it('test23', async () => {
        await imp.importPage("Test23 page","test23_page.txt");
        await $(`//div[@id='content']`).waitForExist({ timeout: 30000 });
        await expect($(`//div[@id='content'][not(contains(.,'Duration of query'))]`)).not.toHaveText(``);
    });

    it('test24', async () => {
        await imp.importPage("Test24 page","test24_page.txt");
        await $(`//div[@id='content'][not(contains(.,'Duration of query'))]`).waitForExist({ timeout: 30000 });
    });

    it('test25', async () => {
        await imp.importPage("Test25 page","test25_page.txt");
        await $(`//div[@id='content'][not(contains(.,'Duration of query'))]`).waitForExist({ timeout: 30000 });
    });

    it('test26', async () => {
        await imp.importPage("Test26 page","test26_page.txt");
        await $(`//div[@id='mw-content-text']/div/p[contains(.,'||')]`).waitForExist({ timeout: 30000 });
    });

    it('test27', async () => {
        await imp.importPage("Test27 page","test27_page.txt");
        await $(`//div[@id='mw-content-text']/div/p[contains(.,'||')]`).waitForExist({ timeout: 30000 });
    });

    it('test28', async () => {
        await imp.importPage("Test28 page","test28_page.txt");
        await $(`//div[@id='mw-content-text']/div/p[contains(.,'||')]`).waitForExist({ timeout: 30000 });
    });


    it('test29', async () => {
        await imp.importModule("Module:Test29 page","test29_module.lua");
        await imp.importPage("Test29 page","test29_page.txt");
        MainPage.purge()
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'TEST')]`).waitForExist({ timeout: 60000 });
        await expect($(`//div[@id='mw-content-text']/div/pre[contains(.,'KO')]`)).not.toBeExisting();
    });

    it('test30', async () => {
        await imp.importModule("Module:Test30 page","test30_module.lua");
        await imp.importPage("Test30 page","test30_page.txt");
        MainPage.purge()
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'TEST')]`).waitForExist({ timeout: 60000 });
        await expect($(`//div[@id='mw-content-text']/div/pre[contains(.,'KO')]`)).not.toBeExisting();
    });

    it('test31', async () => {
        await imp.importModule("Module:Test31 page","test31_module.lua");
        await imp.importPage("Test31 page","test31_page.txt");
        MainPage.purge()
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'TEST')]`).waitForExist({ timeout: 60000 });
        await expect($(`//div[@id='mw-content-text']/div/pre[contains(.,'KO')]`)).not.toBeExisting();
    });

    it('test32', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SpecialPages`);
        await $(`a=Refresh database`).click();
        await clearGraph();
        await imp.importPage("Data:Test32 page","test32_data.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#firstHeading`)).toHaveText(`Data:Test32 page`);
        await browser.url(`${browser.options.params.urlWiki1}w/index.php/Data:Test32_page?action=raw&export=rdf`);
        await $(`//pre`).waitForExist({ timeout: 30000 });

        const expectedText =  fs.readFileSync(path.join(pathFiles, 'test32_data_raw.txt'), 'utf8');
        const element = await $(`//pre`);
        const actualValue = await element.getText();

        await expect(actualValue.trim()).toEqual(expectedText.trim());
        await browser.url(browser.options.params.urlWiki1);
        await imp.importPage("Test32 page","test32_page.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[1]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SpecialPages`);
        await $(`a=Refresh database`).click();
        await $(`a=Save the RDF data in the wiki and/or refresh the queries`).click();
        await $(`//pre[4]`).waitForDisplayed({ timeout: 60000 });
        await expect($(`//pre[contains(.,'Load <http://serverdev-mediawiki1.localdomain/w/index.php?title=Data:Test32_page&action=raw&export=rdf> into graph <http://database-test1.localdomain/data> -- done')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test32_page`);
        await MainPage.purge();
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
    });

    it('test33', async () => {
        await imp.importModule("Module:Test33 page","test33_module.txt");
        await imp.importPage("Test33 page","test33_page.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`#p-cactions > .vector-menu-checkbox`).click();
        await $(`a=Move`).click();
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#firstHeading`)).toHaveText(`Move Test33 page`);
        await $(`[name="wpNewTitleMain"]`).setValue(`Test33 pageMoved`);
        await $(`//button/span[2]`).click();
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#firstHeading`)).toHaveText(`Move succeeded`);
        await $(`#movepage-newlink`).click();
        await $(`//div[@id='mw-content-text']/div/table[2]/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`//div[@id='mw-content-text']/div/table[3]/tbody/tr[1]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`//div[@id='mw-content-text']/div/table[4]/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//a[contains(@href, '/w/index.php?title=Test33_pageMoved&action=purge')]`)).toBeExisting();
        await $(`#p-cactions > .vector-menu-checkbox`).click();
        await $(`a=Delete`).click();
        const buttonName = (await $$(`//button[@name='wpConfirmB']`)).length;
        if (buttonName == 1) {
            await $(`[name="wpConfirmB"]`).click();
        } else {
            await $(`#wpConfirmB > .oo-ui-labelElement-label`).click();
        }
        await $(`p:nth-child(2)`).click();
        await $(`//p[contains(.,'Data deleted.')]`).waitForExist({ timeout: 30000 });
        await expect($(`//p[contains(.,'Data deleted.')]`)).toHaveText(`Data deleted.`);
        await browser.url(`http://database-test1.localdomain/sparql?default-graph-uri=&query=select+count%28*%29+as+%3Fc+where%0D%0A+%7B+%3Chttp%3A%2F%2Fserverdev-mediawiki1.localdomain%2Fwiki%2FTest33_page%3E+%3Fy+%3Fz+.+%7D%0D%0ALIMIT+15&format=text%2Fhtml&timeout=0&signal_void=on`);
        await $(`//pre[contains(.,'0')]`).waitForExist({ timeout: 30000 });
        await browser.url(`http://database-test1.localdomain/sparql?default-graph-uri=&query=select+count%28*%29+as+%3Fc+where%0D%0A+%7B+%3Chttp%3A%2F%2Fserverdev-mediawiki1.localdomain%2Fwiki%2FTest33_pageMoved%3E+%3Fy+%3Fz+.+%7D%0D%0ALIMIT+15&format=text%2Fhtml&timeout=0&signal_void=on`);
        await $(`//pre[contains(.,'0')]`).waitForExist({ timeout: 30000 });
    });

    it('test34', async () => {
        await imp.importModule("Module:Test34 page infobox","test34_module_infobox.txt");
        await imp.importModule("Module:Test34 page save","test34_module_save_data.txt");

        await imp.importPage("Test34 page","test34_page1.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`a=Check data`)).not.toBeExisting();
        await expect($(`a=test`)).not.toBeExisting();

        await imp.replacePage("Test34 page","test34_page2.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`a=Check data`)).toBeExisting();
        await expect($(`a=test`)).toBeExisting();
        await expect($(`.mw-ext-linkedwiki-new-value`)).toBeExisting();

        await imp.replacePage("Test34 page","test34_page3.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`a=Check data`)).not.toBeExisting();
        await expect($(`a=test`)).toBeExisting();

        await imp.replacePage("Test34 page","test34_page4.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`a=Check data`)).not.toBeExisting();
        await expect($(`a=test`)).toBeExisting();
        await expect($(`.mw-ext-linkedwiki-value-equal`)).toBeExisting();

        await imp.replacePage("Test34 page","test34_page5.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`a=Check data`)).toBeExisting();
        await expect($(`a=test`)).not.toBeExisting();
        await expect($(`.mw-ext-linkedwiki-new-value`)).toBeExisting();
    });

    it('test35', async () => {
        await imp.importPage("Data:Test35 page","test35_data.txt");
        await $(`a=RDF schema`).waitForExist({ timeout: 30000 });
        await $(`a=RDF page`).waitForExist({ timeout: 30000 });
        await $(`a=Special pages`).click();
        await $(`a=Refresh database`).click();
        await $(`a=Save the RDF data in the wiki and/or refresh the queries`).click();
        await $(`//pre[4]`).waitForDisplayed({ timeout: 60000 });
        await $(`//pre[contains(.,'Load <http://serverdev-mediawiki1.localdomain/w/index.php?title=Data:Test35_page&action=raw&export=rdf> into graph <http://database-test1.localdomain/data> -- done')]`).waitForExist({ timeout: 30000 });
        await $(`a=Special pages`).click();
        await $(`a=RDF test cases`).click();
        await $(`a=Refresh test cases`).click();
        await $(`//td[contains(.,'value not of datatype')]`).waitForExist({ timeout: 30000 });
        await expect($(`//pre[contains(.,'http://example.com/graph1')]`)).toBeExisting();
        await expect($(`//pre[contains(.,'http://example.com/graph2')]`)).toBeExisting();
    });

    it('test36', async () => {
        await imp.importPage("Data:Test36 page","test36_data.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await $(`#p-cactions > .vector-menu-checkbox`).click();
        await $(`a=Turtle`).click();
        await $(`pre`).waitForExist({ timeout: 30000 });

        const expectedText =  fs.readFileSync(path.join(pathFiles, 'test36_data_raw.txt'), 'utf8');
        const element = await $(`pre`);
        const actualValue = await element.getText();

        await expect(actualValue.trim()).toEqual(expectedText.trim());
    });

    it('test37', async () => {
        await imp.importPage("Data:Test37 page","test37_data_with_error.txt");
        await $(`//div[@id='mw-content-text']/div/div[contains(.,'syntax error at')]`).waitForExist({ timeout: 30000 });
        await imp.editWithFile("test37_data.txt");
        await expect($(`//div[@id='mw-content-text']/div/div[contains(.,'syntax error at')]`)).not.toBeExisting();
        await expect($(`a=Pages with syntax highlighting errors`)).not.toBeExisting();
    });

    it('test38', async () => {
        await imp.importModule("Module:Test38 page","test38_module.lua");
        await imp.importPage("Test38 page","test38_page.txt");
        await MainPage.purge();
        await $(`//div[@id='mw-content-text']/div/pre[contains(.,'TEST')]`).waitForExist({ timeout: 60000 });
        await expect($(`//div[@id='mw-content-text']/div/pre[contains(.,'KO')]`)).not.toBeExisting();
    });

    it('test39', async () => {
        await imp.importPage("Test39 page","test39_page.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[16]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[15]/td`).waitForDisplayed({ timeout: 1, reverse: true });
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[5]/td`).waitForDisplayed({ timeout: 1 });
    });

    it('test40', async () => {
        await imp.importPage("Test40","test40.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await imp.importPage("Data:Test40","test40_data.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await imp.importPage("Talk:Test40","test40_talk.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#testJobs`).waitForExist({ timeout: 60000 });
        await browser.url(`${browser.options.params.urlWiki1}w/index.php/Talk:Test40`);
        await $(`//table[1]//td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`//table[2]//td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//table[2]/tbody/tr/td[2]`)).toHaveText(`test40_main`);
        await expect($(`//table[1]//td[2]`)).toHaveText(`test40_data`);
    });

    it('test41', async () => {
        await imp.importPage("User:Test41","test41_user.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });

        await imp.importPage("UserData:Test41","test41_userdata.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });

        await imp.importPage("User talk:Test41","test41_usertalk.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#testJobs`).waitForExist({ timeout: 60000 });
        await browser.url(`${browser.options.params.urlWiki1}w/index.php/User talk:Test41`);
        await $(`//table[1]//td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`//table[2]//td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//table[2]/tbody/tr/td[2]`)).toHaveText(`test41_user`);
        await expect($(`//table[1]//td[2]`)).toHaveText(`test41_userdata`);
    });

    it('test42', async () => {
        await imp.importPage("Test42 page","test42_page.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`//p[contains(.,'error')]`)).not.toBeExisting();
    });

    it('test43', async () => {
        await imp.importPage("Template:Test43 page template1","test43_template1.txt");
        await imp.importPage("Test43 page","test43_page.txt");
        await $(`//div[@id='mw-content-text']/div/table`).waitForExist({ timeout: 30000 });
        await expect($(`//p[contains(.,'error')]`)).not.toBeExisting();
    });

    it('test44', async () => {
        await imp.importPage("Template:Test44 page template1","test44_template1.txt");
        await imp.importPage("Test44 page","test44_page.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`//p[contains(.,'error')]`)).not.toBeExisting();
    });

    it('test45', async () => {
        await imp.importPage("Template:Test45 page template1","test45_template1.txt");
        await imp.importPage("Template:Test45 page template2","test45_template2.txt");
        await imp.importPage("Template:Test45 page template3","test45_template3.txt");
        await imp.importPage("Test45 page","test45_page.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`//p[contains(.,'error')]`)).not.toBeExisting();
    });

    it('test46', async () => {
        await imp.importPage("Template:Test46 page template1","test46_template1.txt");
        await imp.importPage("Test46 page","test46_page.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`//p[contains(.,'error')]`)).not.toBeExisting();
    });

    it('test100_special_sparql_T1_html', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SparqlQuery`);
        await $(`.custom-control:nth-child(2) > .custom-control-label`).click();
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await $(`#execQuery`).click();
        await expect($(`//select[@id='config'][contains(.,'http://database-test1.localdomain/data')]`)).toBeExisting();
        await $(`//div[@id='result']/table/tbody/tr[16]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`a=Howto use this query in this wiki`).click();
        await expect($(`//pre[contains(.,'SELECT')]`)).toBeExisting();
    });


    it('test101_special_sparql_T1_js', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SparqlQuery`);
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await $(`#config`).selectByVisibleText(`http://www.wikidata.org`);
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await browser.pause(1000);
        await $(`#execQuery`).click();
        await expect($(`//select[@id='config'][contains(.,'http://www.wikidata.org')]`)).toBeExisting();
        await $(`//div[@id='result-datatable_info'][contains(.,'Showing 1 to 10 of 15 entries')]`).waitForExist({ timeout: 5000 });
        await $(`a=Howto use this query in this wiki`).click();
        await expect($(`//pre[contains(.,'options=width=100%!height=500px')]`)).toBeExisting();
    });

    it('test102_special_sparql_T2_html', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SparqlQuery`);
        await $(`#execQuery`).waitForExist({ timeout: 30000 });
        await $(`#config`).selectByVisibleText(`http://database-test1.localdomain/data`);
        await $(`.custom-control:nth-child(2) > .custom-control-label`).click();
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await browser.pause(1000);
        await $(`#execQuery`).click();
        await expect($(`//select[@id='config'][contains(.,'http://www.wikidata.org')]`)).toBeExisting();
        await $(`//div[@id='result']/table/tbody/tr[16]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 5000 });
        await $(`a=Howto use this query in this wiki`).click();
        await expect($(`//pre[contains(.,'SELECT')]`)).toBeExisting();
    });

    it('test103_special_sparql_T2_js', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SparqlQuery`);
        await $(`#execQuery`).waitForExist({ timeout: 30000 });
        await $(`#config`).selectByVisibleText(`http://database-test1.localdomain/data`);
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await browser.pause(1000);
        await $(`#execQuery`).click();
        await $(`#result`).waitForExist({ timeout: 30000 });
        await expect($(`#result`)).toHaveText(`This SPARQL service is not accessible via Javascript.`);
    });


    it('test104_special_sparql_T3_html', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SparqlQuery`);
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await $(`#config`).selectByVisibleText(`Other`);
        await $(`#endpointOther`).waitForDisplayed({ timeout: 30000 });
        await $(`#endpointOther`).setValue(`http://database-test1.localdomain:8890/sparql`);
        await $(`.custom-control:nth-child(2) > .custom-control-label`).click();
        await $(`#execQuery`).waitForDisplayed({ timeout: 30000 });
        await $(`#execQuery`).click();
        await $(`//div[@id='result']/table/tbody/tr[16]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await $(`a=Howto use this query in this wiki`).click();
        await expect($(`//pre[contains(.,'endpoint=http://database-test1.localdomain:8890/sparql')]`)).toBeExisting();
    });

    it('test105_special_sparql_T3_js', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SparqlQuery`);
        await $(`#execQuery`).waitForExist({ timeout: 30000 });
        await browser.pause(1000);
        await $(`#config`).selectByVisibleText(`Other`);
        await $(`#endpointOther`).setValue(`http://database-test1.localdomain:8890/sparql`);
        await $(`#execQuery`).waitForExist({ timeout: 30000 });
        await browser.pause(1000);
        await $(`#execQuery`).click();
        await $(`//div[@id='result-datatable_info'][contains(.,'Showing 1 to 10 of 15 entries')]`).waitForExist({ timeout: 5000 });
        await $(`a=Howto use this query in this wiki`).click();
        await expect($(`//div[@id='htmlTab']/div/pre[contains(.,'SELECT')]`)).toBeExisting();
    });

    it('test200_special_Flintl_T1', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:SpecialPages`);
        await $(`a=SPARQL Flint editor`).click();
        await expect($(`#flint-title`)).toHaveText(`Flint SPARQL Editor 1.0.3`);
    });
});
