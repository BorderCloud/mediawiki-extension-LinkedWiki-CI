'use strict';
const path = require('path');
// require( 'dotenv' ).config();
// const { config } = require( '../../servers/mediawiki1/htdocs/w/tests/selenium/wdio-mediawiki/wdio-defaults.conf.js' );

exports.config = {
	 logLevel: 'error',


	reporters: ['spec'],
	maxInstances: 1,
	capabilities: [
		{
		maxInstances: 1,
		browserName:   process.env._BROWSER || 'chrome', //firefox
		acceptInsecureCerts: true,
		excludeDriverLogs: ['*'],
		// 'goog:chromeOptions': {
		//   args: ['--window-size=1920,1080'],
		// },
		},
	],

	mochaOpts: {
		timeout: 900000 // seconds
	},

	params: {
		urlWiki1: 'http://serverdev-mediawiki1.localdomain/',
		urlWiki2: 'http://serverdev-mediawiki2.localdomain/',
		usernameAdmin: 'Admin', 
		usernameClassic: 'userClassic', 
		usernameData: 'userData',
		password: 'dockerpass'
	},

	// before: function (capabilities, specs) {
    //     console.log('--- Configuration Parameters ---');
    //     console.log(`urlWiki1: ${this.params.urlWiki1}`);
    //     console.log(`urlWiki2: ${this.params.urlWiki2}`);
    //     console.log(`usernameAdmin: ${this.params.usernameAdmin}`);
    //     console.log(`password: ${this.params.password}`);
    //     console.log('------------------------------');
    // },

	// onPrepare: function (config, capabilities) {
	// 	console.log('--------------------------------------------------');
	// 	console.log('Configuration WebdriverIO :');
    // 	console.log(JSON.stringify(config, null, 2));
	// 	console.log('--------------------------------------------------');
	// }
};
