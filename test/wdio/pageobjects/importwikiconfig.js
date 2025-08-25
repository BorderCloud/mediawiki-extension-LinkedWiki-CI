'use strict';

class ImportWikiConfig {
    async addWikiConfig(name, url, api, user, keyuser) {
        await $('a=Preferences').click();
        await $('//span[contains(.,"Targeted wikis")]').click();
        await $('//fieldset[@id="mw-prefsection-pushall-pushall-preference-targets"]/fieldset/div/div/div/div/span/span/button/span[2]').click();

        await $("#ooui-3").setValue(name);
        await browser.pause(200);
        await $("#ooui-5").setValue(url);
        await browser.pause(200);
        await $("#ooui-7").setValue(api);
        await browser.pause(200);
        await $("#ooui-9").setValue(user);
        await browser.pause(200);
        await $("#ooui-11").setValue(keyuser);
        await browser.pause(200);
        await $("div.oo-ui-processDialog-actions-primary a").click()

        await $("//*[@id=\"prefcontrol\"]/button/span[2]").click()
        await browser.pause(5000);

    }
}

export default new ImportWikiConfig();