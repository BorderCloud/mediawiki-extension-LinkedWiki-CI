'use strict';

require( 'dotenv' ).config();
const { config } = require( './wdio.conf.js' );

exports.config = { ...config,
  specs: [
		'specs/LinkedWiki/suite_tests_page.js',
		'specs/LinkedWiki/suite_tests_job.js'
	],
	services: [
        ['monocart', {
            name: 'LinkedWiki Coverage Report',
    		entryFilter: (entry) => entry.url.indexOf("LinkedWiki") !== -1,
            reports: [
                //'v8',
				'v8-json',
                'console-details'
            ],
            outputDir: '../../coverage/report/LinkedWiki'
        }]
    ]
};
