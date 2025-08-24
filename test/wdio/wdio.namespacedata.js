'use strict';

require( 'dotenv' ).config();
const { config } = require( './wdio.conf.js' );

exports.config = { ...config,
  specs: [
		'specs/NamespaceData/suite_tests.js'
	],

	services: [
        ['monocart', {
            name: 'NamespaceData Coverage Report',
    		entryFilter: (entry) => entry.url.indexOf("NamespaceData") !== -1,
            reports: [
                //'v8',
				'v8-json',
                'console-details'
            ],
            outputDir: '../../coverage/report/NamespaceData'
        }]
    ]
};
