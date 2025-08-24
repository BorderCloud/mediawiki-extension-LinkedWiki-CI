'use strict';

import path from 'path';
import MainPage from './main.page.js';
import EditPage from './edit.page.js';

import fs from 'fs';

class ImportWiki {
    constructor(urlWiki, filePath) {
        this.urlWiki = urlWiki;
        this.filePath = filePath;
    }

    async editWithFile(filename) {
        const fileContent = fs.readFileSync(path.join(this.filePath, filename), 'utf8');
        const myTextarea = await EditPage.content;
        await myTextarea.waitForClickable({ timeout: 45000 }); // 45 sec

        const lines = fileContent.split('\n');
        await myTextarea.clearValue();
        for (let i = 0; i < lines.length; i += 100) {
            const chunk = lines.slice(i, i + 100);
            const chunkAsString = chunk.join('\n');
            await myTextarea.addValue(chunkAsString);
            await browser.pause(500); 
        }

        await EditPage.save.click();
    }

    async importPage(title, filename) {
        const isUserPage = title.startsWith("User");
        if (isUserPage) {
            await browser.url(`${this.urlWiki}w/index.php/${title}?action=edit`);
        } else {
            await browser.url(this.urlWiki);
            await MainPage.open(title);
        }
        await this.editWithFile(filename);
    }

    async replacePage(title, filename) {
        await MainPage.searchInput.setValue(title);
        await MainPage.searchButton.click();
        await MainPage.edit()
        await this.editWithFile(filename);
    }

    async importModule(title, filename) {
        await browser.url(this.urlWiki);
        await MainPage.open(title);
        await browser.pause(2000);
        // check if the OOUI editor is enable
        const elementSelector = "textarea#wpTextbox1[style*='display: none']";
        const elementCount = await $$(elementSelector).length;
        if (elementCount === 1) {
            await $('.oo-ui-icon-markup').click();
        }
        await this.editWithFile(filename);
    }

    async importFile(filename) {
        await browser.url(this.urlWiki);
        // await browser.url(`${this.baseUrl}wiki/Main_Page`);
        await $('#t-upload a').click();
        await $('#wpUploadFile').setValue(path.resolve(this.filePath, filename));
        await $('[name="wpUpload"]').click();
        
        await browser.pause(2000);
        const forceUploadButton = await $('//button[@name="wpUploadIgnoreWarning"]');
        if (await forceUploadButton.isExisting()) {
            await forceUploadButton.click();
            await browser.pause(2000);
        }
    }
}

export default ImportWiki;