class LoginPageMediawiki2 {
    get usernameInput() {
        return $('#wpName1');
    }
    get passwordInput() {
        return $('#wpPassword1');
    }
    get loginBtn() {
        return $('#wpLoginAttempt');
    }
    get loginLink() {
        return $('#pt-login span');
    }

    async open() {
        await browser.url(browser.options.params.urlWiki2);
        await this.loginLink.waitForExist({ timeout: 30000 });
        await this.loginLink.click();
    }

    async login(username, password) {
        await this.usernameInput.setValue(username);
        await this.passwordInput.setValue(password);
        await this.loginBtn.click();
    }
}

export default new LoginPageMediawiki2();