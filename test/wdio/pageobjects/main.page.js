class MainPage {
    get logoutLink() {
        return $('#pt-logout a');
    }
    
    get searchInput() {
        return $('#searchInput');
    }

    get searchButton() {
        return $('#searchButton');
    }
    
    async logout() {
        // await this.logoutLink.waitForExist({ timeout: 30000 });
        await this.logoutLink.click();
    }
    
    async open(title) {
        await this.searchInput.setValue(title);
        await this.searchButton.click();
        await $(`a=${title}`).waitForExist({ timeout: 30000 });
        await $(`a=${title}`).click();
    }

    async purge() {
        await $('#p-cactions').click();
        await $('a=Purge').click();
        await $(`button.oo-ui-inputWidget-input.oo-ui-buttonElement-button`).click();
    }

    async edit() {
        await $('#ca-edit span').click();
    }
}

export default new MainPage();
