'use strict';

import LoginPageMediawiki1 from '../../pageobjects/login.page.mediawiki1.js';
import MainPage from '../../pageobjects/main.page.js';
import EditPage from '../../pageobjects/edit.page.js';
import DataPage from '../../pageobjects/data.page.js';

describe('Suite de tests convertis', function () {

    it('w1-admin-create-data-page', async () => {
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameAdmin,
            browser.options.params.password
        );

        const title = 'TestPage' + Math.random();
        await MainPage.open(title);
        await EditPage.edit('page_test');

        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_test');

        await DataPage.open();
        await EditPage.edit('page_data-test');
        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_data-test');
        await MainPage.logout();
    });

    // Test: w1-admin-create-userdata-page
    it('w1-admin-create-userdata-page', async () => {
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameAdmin,
            browser.options.params.password
        );

        await $('a=Admin').click();
        await $('a=UserData').click();
        let statusOK = await browser.execute(() => document.getElementById("wpTextbox1") !== null);
        if (!statusOK) {
            await $('a=Edit').click();
        }
        await EditPage.edit('page_userdata-test');

        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_userdata-test');
        await MainPage.logout();
    });

    // Test: w1-userClassic-cannot-create-data-page
    it('w1-userClassic-cannot-create-data-page', async () => {
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameClassic,
            browser.options.params.password
        );

        let title = 'TestPage' + Math.random();

        await MainPage.open(title);
        await EditPage.edit('page_test');

        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_test');

        await DataPage.open();

        await expect($('#wpTextbox1')).not.toExist();
        await MainPage.logout();
    });

    it('w1-userClassic-cannot-create-userdata-page', async () => {
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameClassic,
            browser.options.params.password
        );
        await $('a=UserClassic').click();
        await $('a=UserData').click();
        await expect($('#wpTextbox1')).not.toExist();
        await MainPage.logout();
    });

    // Test: w1-userData-create-data-page
    it('w1-userData-create-data-page', async () => {
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameData,
            browser.options.params.password
        );
        let title = 'TestPage' + Math.random();

        await MainPage.open(title);
        await EditPage.edit('page_test');

        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_test');

        await DataPage.open();
        await EditPage.edit('page_data-test');

        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_data-test');
        await MainPage.logout();
    });

    it('w1-userData-create-userdata-page', async () => {
        await LoginPageMediawiki1.open();
        await LoginPageMediawiki1.login(
            browser.options.params.usernameData,
            browser.options.params.password
        );
        await $('a=UserData').click();
        await $("//li[@id='ca-data_user']/a").click();
        let statusOK = await browser.execute(() => document.getElementById("wpTextbox1") !== null);
        if (!statusOK) {
            await $('a=Edit').click();
        }

        await EditPage.edit('page_userdata-test');

        await expect($("//div[@id='mw-content-text']/div/p")).toHaveText('page_userdata-test');
        await MainPage.logout();
    });

});      