'use strict';

class CreateUserPage {
    get specialPagesLink() { return $('a=Special pages'); }
    get createAccountLink() { return $('a=Create account'); }
    get usernameInput() { return $('#wpName2'); }
    get passwordInput() { return $('#wpPassword2'); }
    get retypePasswordInput() { return $('#wpRetype'); }
    get createAccountBtn() { return $('#wpCreateaccount'); }
    get userDataLink() { return $('a=UserData'); }
    get changeGroupsLink() { return $('a=Change user groups'); }
    get dataGroupCheckbox() { return $('#wpGroup-data'); }
    get saveGroupsBtn() { return $('[name="saveusergroups"]'); }

    async navigateToCreateAccount() {
        await this.specialPagesLink.click();
        await this.createAccountLink.click();
    }

    async createAccount(username, password) {
        await this.usernameInput.setValue(username);
        await this.passwordInput.setValue(password);
        await this.retypePasswordInput.setValue(password);
        await this.createAccountBtn.click();
    }

    async setUserGroupToData() {
        await this.userDataLink.click();
        await this.changeGroupsLink.click();
        await this.dataGroupCheckbox.click();
        await this.saveGroupsBtn.click();
    }
}

export default new CreateUserPage();