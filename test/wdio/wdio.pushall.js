'use strict';

require( 'dotenv' ).config();
const { config } = require( './wdio.conf.js' );

exports.config = { ...config,
  specs: [
		'specs/PushAll/suite_tests.js'
	],

	services: [
        ['monocart', {
            name: 'PushAll Coverage Report',
    		entryFilter: (entry) => entry.url.indexOf("PushAll") !== -1,
            reports: [
                //'v8',
				'v8-json',
                'console-details'
            ],
            outputDir: '../../coverage/report/PushAll'
        }]
    ]
};
