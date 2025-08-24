'use strict';


import LoginPageMediawiki1 from '../../pageobjects/login.page.mediawiki1.js';
import MainPage from '../../pageobjects/main.page.js';
import EditPage from '../../pageobjects/edit.page.js';
import fs from 'fs';
import path from 'path';

import ImportWiki from '../../pageobjects/importwiki.js';

describe('Suite tests for LinkedWiki jobs', function () {

    const pathFiles = './specs/LinkedWiki';
    const imp = new ImportWiki(browser.options.params.urlWiki1, pathFiles);

    async function clearGraph() {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $('//*[@id="buttonClearNamedGraph"]/a').click();
        await $(`//pre[contains(.,'Clear graph <http://database-test1.localdomain/data> -- done')]`).waitForExist({ timeout: 30000 });
    }

    before(async () => {
        await LoginPageMediawiki1.open();
        await browser.pause(500);
        await LoginPageMediawiki1.login(
            browser.options.params.usernameData,
            browser.options.params.password
        );

        await clearGraph();
    });

    after(async () => {
        await browser.url(browser.options.params.urlWiki1);
        await MainPage.logout();
    });

    it('test301_checkAllEmpty', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#testJobsResult`)).toHaveText(`0`);
        await expect($(`#testNbPagesWithModules`)).toHaveText(`0`);
    });

    it('test301_create_module', async () => {
        await imp.importModule("Module:Test301", "test301_module.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#firstHeading`)).toHaveText(`Module:Test301`);
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#testNbPagesWithModules`)).toHaveText(`0`);
    });

    it('test301_create_page_read_module', async () => {
        await imp.importPage("Test301 page", "test301_pagereadmodule.txt");
        await expect($(`//div[@id='mw-content-text']/div/table/caption/div/span/a`)).not.toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_RDF_reader_module&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301 page')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#testNbPagesWithModules`)).toHaveText(`1`);
    });

    it('test301_create_page_read_query', async () => {
        await imp.importPage("Test301 pagereadquery", "test301_pagereadquery.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[1]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_sparql_query_cached&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301 pagereadquery')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#testNbPagesWithModules`)).toHaveText(`2`);
    });

    it('test301_create_page_read_querynocache', async () => {
        await imp.importPage("Test301 pagereadquerynocache", "test301_pagereadquerynocache.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[1]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_sparql_query_without_cache&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301 pagereadquerynocache')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`#testNbPagesWithModules`)).toHaveText(`3`);
    });

    it('test301_page_module_write1', async () => {
        await imp.importPage("Test301 pagewrite", "test301_pagewrite1.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_RDF_writer_module&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301 pagewrite')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 60000 });
        await expect($(`#testNbPagesWithModules`)).toHaveText(`4`);
    });

    it('test301_create_page_data', async () => {

        await imp.importPage("Data:Test301", "test301_data1.txt");
        await $(`a=RDF page`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_RDF_tag&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await $(`#testJobsQueueLoadRDF`).waitForExist({ timeout: 1 });
        await expect($(`#testNbPagesWithModules`)).toHaveText(`5`);
        await expect($(`//pre[contains(.,'InvalidatePageWithQuery ForAllQuery')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_pagereadquery`);
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//td[contains(.,'dataC')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_pagereadquerynocache`);
        await $(`//td[contains(.,'dataC')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_page`);
        await $(`//td[contains(.,'dataC')]`).waitForExist({ timeout: 30000 });
    });


    it('test301_create_page_data2', async () => {
        await imp.replacePage("Data:Test301", "test301_data2.txt");
        await $(`a=RDF page`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_RDF_tag&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`#testJobsQueueLoadRDF`).waitForExist({ timeout: 1 });
        await expect($(`//pre[contains(.,'InvalidatePageWithQuery ForAllQuery')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_pagereadquery`);
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[3]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//td[contains(.,'dataD')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_page`);
        await expect($(`//td[contains(.,'dataD')]`)).toBeExisting();
    });


    it('test301_create_page_read_query2', async () => {
        await imp.replacePage("Test301 pagereadquery", "test301_pagereadquery2.txt");
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//td[contains(.,'dataA')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:PagesWithProp?propname=wgLinkedWiki_page_with_sparql_query_cached&namespace=`);
        await $(`//div[@id='mw-content-text']/div[2][contains(.,'Test301 pagereadquery')]`).waitForExist({ timeout: 30000 });
    });

    it('test301_page_module_write2', async () => {

        await imp.replacePage("Test301 pagewrite", "test301_pagewrite2.txt");
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`//pre[contains(.,'InvalidatePageWithQuery ForAllQuery')]`).waitForExist({ timeout: 60000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_page`);
        await $(`//td[contains(.,'dataB')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_pagereadquery`);
        await $(`//td[contains(.,'dataB')]`).waitForExist({ timeout: 30000 });
    });

    it('test301_refreshall', async () => {
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave`);
        await $('//*[@id="buttonRefreshAll"]/a').click();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`//pre[contains(.,'InvalidatePageWithQuery ForAllQuery')]`).waitForExist({ timeout: 30000 });
        await $(`a=Refresh status of jobs`).click();
        await $(`#firstHeading`).waitForExist({ timeout: 30000 });
        await expect($(`//table[@id='linkedwiki-module-table']//td[contains(.,'Job pending')]`)).not.toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_pagereadquery`);
        await $(`//div[@id='mw-content-text']/div/table/tbody/tr[2]/td[contains(.,'Duration of query')]`).waitForExist({ timeout: 30000 });
        await expect($(`//td[contains(.,'dataB')]`)).toBeExisting();
        await browser.url(`${browser.options.params.urlWiki1}wiki/Test301_page`);
        await expect($(`//td[contains(.,'dataB')]`)).toBeExisting();
        await expect($(`//td[contains(.,'dataD')]`)).toBeExisting();
        await expect($(`//td[contains(.,'dataA')]`)).not.toBeExisting();
        await expect($(`//div[@id='mw-content-text']/div/table/tbody/tr[3]/td[contains(.,'dataC')]`)).not.toBeExisting();
    });

    it('test301_errors', async () => {
        await imp.replacePage("Data:Test301", "test301_data_with_error.txt");
        await $(`a=RDF page`).waitForExist({ timeout: 30000 });
        await imp.replacePage("Test301 pagereadquery", "test301_pagereadquery_with_error.txt");
        await $(`p`).click();
        await $(`//p[contains(.,'Sorry, the SPARQL server sent an error. (see details with parameter log=2)')]`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await browser.pause(1000);
        await $(`#testNbPagesWithModules`).waitForExist({ timeout: 30000 });
        await browser.url(`${browser.options.params.urlWiki1}wiki/Special:RDFSave?debug=true&runJobs=true`);
        await $(`//td[9]/span/a/span[2][contains(.,'ERROR')]`).waitForExist({ timeout: 30000 });
        await $(`//tr[5]/td[9]/span/a/span[2][contains(.,'ERROR')]`).waitForExist({ timeout: 30000 });
    });
});
