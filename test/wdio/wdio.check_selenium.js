'use strict';

require( 'dotenv' ).config();
const { config } = require( './wdio.conf.js' );

exports.config = { ...config,
  specs: [
		'specs/check_mediawiki_1_2.js'
	],	
	services: [
        ['monocart', {
            name: 'LinkedWiki Coverage Report',
            // v8 (default) or istanbul (requires instrumenting source code)
            // coverageProvider: 'v8',
    		entryFilter: (entry) => entry.url.indexOf("LinkedWiki") !== -1,
            reports: [
                //'v8',
				'v8-json',
                'console-details'
            ],
            outputDir: '../../coverage/report/check'
        }]
    ]
};
