'use strict';

import CreateUserPage from '../pageobjects/create_user.page.js';
import LoginPageMediawiki1 from '../pageobjects/login.page.mediawiki1.js';
import LoginPageMediawiki2 from '../pageobjects/login.page.mediawiki2.js';
import MainPage from '../pageobjects/main.page.js';

describe('Create_users', function () {


  it('w1_create_userClassic', async () => {
    await LoginPageMediawiki1.open();
    await LoginPageMediawiki1.login(
      browser.options.params.usernameAdmin,
      browser.options.params.password
    );
    await CreateUserPage.navigateToCreateAccount();
    await CreateUserPage.createAccount(
      browser.options.params.usernameClassic,
      browser.options.params.password
    );
    await MainPage.logout();

  });

  it('w1_create_userData', async () => {
    await LoginPageMediawiki1.open();
    await LoginPageMediawiki1.login(
      browser.options.params.usernameAdmin,
      browser.options.params.password
    );
    await CreateUserPage.navigateToCreateAccount();
    await CreateUserPage.createAccount(
      browser.options.params.usernameData,
      browser.options.params.password
    );
    await CreateUserPage.setUserGroupToData();
    await MainPage.logout();

  });

  it('w1_create_NetworkAuthUser', async () => {
    await LoginPageMediawiki1.open();
    await LoginPageMediawiki1.login(
      browser.options.params.usernameAdmin,
      browser.options.params.password
    );
    await CreateUserPage.navigateToCreateAccount();
    await CreateUserPage.createAccount(
      "NetworkAuthUser",
      browser.options.params.password
    );
    await MainPage.logout();

  });

  it('w2_create_userClassic', async () => {
    await browser.reloadSession();
    await browser.pause(1000);
    await LoginPageMediawiki2.open();
    await LoginPageMediawiki2.login(
      browser.options.params.usernameAdmin,
      browser.options.params.password
    );
    await CreateUserPage.navigateToCreateAccount();
    await CreateUserPage.createAccount(
      browser.options.params.usernameClassic,
      browser.options.params.password
    );
    await MainPage.logout();

  });

  it('w2_create_userData', async () => {
    await LoginPageMediawiki2.open();
    await LoginPageMediawiki2.login(
      browser.options.params.usernameAdmin,
      browser.options.params.password
    );
    await CreateUserPage.navigateToCreateAccount();
    await CreateUserPage.createAccount(
      browser.options.params.usernameData,
      browser.options.params.password
    );
    await CreateUserPage.setUserGroupToData();
    await MainPage.logout();

  });
});
