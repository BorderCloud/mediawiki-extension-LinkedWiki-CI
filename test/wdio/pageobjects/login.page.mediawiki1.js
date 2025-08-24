class LoginPageMediawiki1 {
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
        return $('#pt-login-private span');
    }

    async open() {
        await browser.url(browser.options.params.urlWiki1);
        await this.loginLink.waitForExist({ timeout: 30000 });
        await this.loginLink.click();
    }

    async login(username, password) {
        await this.usernameInput.setValue(username);
        await this.passwordInput.setValue(password);
        await this.loginBtn.click();
    }
}

export default new LoginPageMediawiki1();


    //   await $("#pt-login-private span").waitForExist({ timeout: 30000 });
    //   await $("#pt-login-private span").click();
    //   await $('#wpName1').setValue(username);
    //   await $('#wpPassword1').setValue(password);
    //   await $("#wpLoginAttempt").click();
