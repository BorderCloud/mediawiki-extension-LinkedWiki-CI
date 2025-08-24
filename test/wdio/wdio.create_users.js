'use strict';

require( 'dotenv' ).config();
const { config } = require( './wdio.conf.js' );

exports.config = { ...config,
  specs: [
		'specs/create_users.js'
	],
};
