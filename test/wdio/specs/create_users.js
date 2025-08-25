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

// describe('Create_users', function() {
//   let username = "Admin";
//   let usernameClassic = "userClassic";
//   let password = "dockerpass";

//   it('w1_create_userClassic', async () => {
//     await browser.url("http://serverdev-mediawiki1.localdomain/")
//     await $("#pt-login-private span").click();
//     await $("#wpName1").setValue(username) 
//     await $("#wpPassword1").setValue(password) 
//     await $("#wpLoginAttempt").click() 
//     await $("a=Special pages").click() 
//     await $("a=Create account").click() 
//     await $("#wpName2").setValue(usernameClassic) 
//     await $("#wpPassword2").setValue(password) 
//     await $("#wpRetype").setValue(password) 
//     await $("#wpCreateaccount").click() 
//     await $("a=Log out").click() 
//   });

//   it('w1_create_userData', async () => {
//     await browser.url("http://serverdev-mediawiki1.localdomain/") 
//     await $("#pt-login-private span").click();
//     await $("#wpName1").setValue(username) 
//     await $("#wpPassword1").setValue(password) 
//     await $("#wpLoginAttempt").click() 
//     await $("a=Special pages").click() 
//     await $("a=Create account").click() 
//     await $("#wpName2").setValue("userData") 
//     await $("#wpPassword2").setValue(password) 
//     await $("#wpRetype").setValue(password) 
//     await $("#wpCreateaccount").click() 
//     await $("a=UserData").click() 
//     await $("a=Change user groups").click() 
//     await $("#wpGroup-data").click() 
//     await $('[name="saveusergroups"]').click() 
//     await $("a=Log out").click() 
//   })

//   it('w2_create_userClassic', async () => {
//     await browser.url("http://serverdev-mediawiki2.localdomain/") 
//     await $("#pt-login span").click();
//     await $("#wpName1").setValue(username) 
//     await $("#wpPassword1").setValue(password) 
//     await $("#wpLoginAttempt").click() 
//     await $("a=Special pages").click() 
//     await $("a=Create account").click() 
//     await $("#wpName2").setValue(usernameClassic) 
//     await $("#wpPassword2").setValue(password) 
//     await $("#wpRetype").setValue(password) 
//     await $("#wpCreateaccount").click() 
//     await $("a=Log out").click() 
//   })

//   it('w2_create_userData', async () => {
//     await browser.url("http://serverdev-mediawiki2.localdomain/") 
//     await $("#pt-login span").click();
//     await $("#wpName1").setValue(username) 
//     await $("#wpPassword1").setValue(password) 
//     await $("#wpLoginAttempt").click() 
//     await $("a=Special pages").click() 
//     await $("a=Create account").click() 
//     await $("#wpName2").setValue("userData") 
//     await $("#wpPassword2").setValue(password) 
//     await $("#wpRetype").setValue(password) 
//     await $("#wpCreateaccount").click() 
//     await $("a=UserData").click() 
//     await $("a=Change user groups").click() 
//     await $("#wpGroup-data").click() 
//     await $('[name="saveusergroups"]').click() 
//     await $("a=Log out").click() 
//   })
// })