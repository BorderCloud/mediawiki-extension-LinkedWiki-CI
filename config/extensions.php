# Enabled extensions. Most of the extensions are enabled by adding
# wfLoadExtension( 'ExtensionName' );
# to LocalSettings.php. Check specific extension documentation for more details.
# The following extensions were automatically enabled:
wfLoadExtension( 'ApiSandbox' );
wfLoadExtension( 'Babel' );
wfLoadExtension( 'Capiunto' );
wfLoadExtension( 'CategoryTree' );
wfLoadExtension( 'Cite' );
wfLoadExtension( 'CiteThisPage' );
wfLoadExtension( 'cldr' );
wfLoadExtension( 'CodeEditor' );
// wfLoadExtension( 'ConfirmEdit' ); // Disable capcha during the automatic tests
wfLoadExtension( 'Gadgets' );
wfLoadExtension( 'ImageMap' );
wfLoadExtension( 'InputBox' );
wfLoadExtension( 'Interwiki' );
wfLoadExtension( 'LinkedWiki' );
wfLoadExtension( 'LocalisationUpdate' );
wfLoadExtension( 'Math' );
wfLoadExtension( 'NamespaceData' );
require_once "$IP/extensions/NetworkAuth/NetworkAuth.php";
wfLoadExtension( 'Nuke' );
wfLoadExtension( 'ParserFunctions' );
wfLoadExtension( 'PdfHandler' );
wfLoadExtension( 'Poem' );
wfLoadExtension( 'PushAll' );
wfLoadExtension( 'Renameuser' );
wfLoadExtension( 'Scribunto' );
wfLoadExtension( 'SpamBlacklist' );
wfLoadExtension( 'SyntaxHighlight_GeSHi' );
wfLoadExtension( 'TitleBlacklist' );
wfLoadExtension( 'Translate' );
wfLoadExtension( 'UniversalLanguageSelector' );
// wfLoadExtension( 'Variables' ); Todo replace/remove 
wfLoadExtension( 'WikiEditor' );

# Enables use of WikiEditor by default but still allows users to disable it in preferences
$wgDefaultUserOptions['usebetatoolbar'] = 1;

# Enables link and table wizards by default but still allows users to disable them in preferences
$wgDefaultUserOptions['usebetatoolbar-cgd'] = 1;

# Displays the Preview and Changes tabs
$wgDefaultUserOptions['wikieditor-preview'] = 1;

# Displays the Publish and Cancel buttons on the top right side
$wgDefaultUserOptions['wikieditor-publish'] = 1;

# End of automatically generated settings.
# Add more configuration options below.
$wgAllowDisplayTitle = true;
$wgRestrictDisplayTitle = false;

# CleanChanges
/*
require_once "$EXT/CleanChanges/CleanChanges.php";
$wgCCTrailerFilter = true;
$wgCCUserFilter = false;
$wgDefaultUserOptions['usenewrc'] = 1;
*/

# LocalisationUpdate
$wgLocalisationUpdateDirectory = "$IP/cache";

# Translate
$wgGroupPermissions['user']['translate'] = true;
$wgGroupPermissions['user']['translate-messagereview'] = true;
$wgGroupPermissions['user']['translate-groupreview'] = true;
$wgGroupPermissions['user']['translate-import'] = true;
$wgGroupPermissions['sysop']['pagetranslation'] = true;
$wgGroupPermissions['sysop']['translate-manage'] = true;
$wgTranslateDocumentationLanguageCode = 'qqq';

#wfLoadExtension( 'WikiEditor' );
#wfLoadExtension( 'CodeEditor' );
$wgDefaultUserOptions['usebetatoolbar'] = 1;

#wfLoadExtension( 'SyntaxHighlight_GeSHi' );
$wgPygmentizePath = "/usr/local/bin/pygmentize";

$wgScribuntoDefaultEngine = 'luastandalone';
$wgScribuntoUseGeSHi = true;
$wgScribuntoUseCodeEditor = true;
