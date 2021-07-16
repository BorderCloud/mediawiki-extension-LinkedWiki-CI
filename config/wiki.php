## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs please see:
## http://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath = "/w";
$wgScriptExtension = ".php";
$wgArticlePath = "/wiki/$1";

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads  = true;
$wgGenerateThumbnailOnParse = false;
$wgUploadPath = "/images";
$wgUploadDirectory = "/var/www/mediawiki-images";

$wgUseInstantCommons = true;
$wgAllowExternalImages=true;
$wgExternalLinkTarget = '_blank';
