'use strict';

import ImportWiki from '../pageobjects/importwiki.js';

import LoginPageMediawiki1 from '../pageobjects/login.page.mediawiki1.js';
import LoginPageMediawiki2 from '../pageobjects/login.page.mediawiki2.js';
import MainPage from '../pageobjects/main.page.js';

describe('Check mediawiki 1 2', function () {

    const pathFiles = './specs';

    const title = "TestPage";

    before(async () => {
        try {
            await browser.url(browser.options.params.urlWiki1);
            await MainPage.logout();
        } catch (e) {
            //Nothing
        }
        try {
            await browser.url(browser.options.params.urlWiki2);
            await MainPage.logout();
        } catch (e) {
            //Nothing
        }
    });

    after(async () => {
        try {
            await browser.url(browser.options.params.urlWiki1);
            await MainPage.logout();
        } catch (e) {
            //Nothing
        }
        try {
            await browser.url(browser.options.params.urlWiki2);
            await MainPage.logout();
        } catch (e) {
            //
        }
});

    it('mediawiki1', async () => {
        await LoginPageMediawiki1.open();
        await browser.pause(3000);
        await LoginPageMediawiki1.login(
            browser.options.params.usernameAdmin,
            browser.options.params.password
        );
        
        const imp = new ImportWiki(browser.options.params.urlWiki1, pathFiles);
        await imp.importPage(title,"page_test.wiki");

        const elementSelector = "//div[@id='mw-content-text']/div/table/tbody/tr[6]/td[contains(.,'Duration of query')]";
        await $(elementSelector).waitForExist({ timeout: 30000 });
        //   await $('a=Log out').click();

        await MainPage.logout();
    });

    it('mediawiki2', async () => {
        await browser.reloadSession();
        await browser.pause(1000);
        await LoginPageMediawiki2.open();
        await browser.pause(3000);
        await LoginPageMediawiki2.login(
            browser.options.params.usernameAdmin,
            browser.options.params.password
        );

        const imp = new ImportWiki(browser.options.params.urlWiki2, pathFiles);
        await imp.importPage(title,"page_test.wiki");
        const elementSelector = "//div[@id='mw-content-text']/div/table/tbody/tr[6]/td[contains(.,'Duration of query')]";
        await $(elementSelector).waitForExist({ timeout: 30000 });
        await MainPage.logout();
    });

});