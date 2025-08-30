
// Insert your Google API key, if you use Google charts. 
// https://developers.google.com/maps/documentation/javascript/get-api-key
$wgLinkedWikiGoogleApiKey = "GOOGLE_MAP_API_KEY";

// Insert your OpenStreetMap Access Token, if you use OpenStreetMap via the Leaflet charts.
// https://www.mapbox.com/api-documentation/#access-tokens
$wgLinkedWikiOSMAccessToken = "OPENSTREETMAP_ACCESS_TOKEN";

$wgLinkedWikiConfigSPARQLServices["http://database-test1.localdomain/data"] = array(
	"debug" => false,
	"isReadOnly" => false,
	"typeRDFDatabase" => "virtuoso",
	"endpointRead" => "http://database-test1.localdomain:8890/sparql/",
	"endpointWrite" => "http://database-test1.localdomain:8890/sparql-auth/",
	"login" => "dba",
	"password" => "dba",
	"HTTPMethodForRead" => "POST",
	"HTTPMethodForWrite" => "POST",
	"lang" => "en",
	"storageMethodClass" => "DatabaseTestDataMethod",
	"nameParameterRead" => "query",
	"nameParameterWrite" => "update"
);

$wgLinkedWikiCheckRDFPage = true;

#If you want to replace Wikidata by this SPARQL service, you need to add also this line:
$wgLinkedWikiSPARQLServiceByDefault= "http://database-test1.localdomain/data";
#If you want to use this SPARQL service to save all RDF data of wiki, you need to add this line:
$wgLinkedWikiSPARQLServiceSaveDataOfWiki= "http://database-test1.localdomain/data";
$wgLinkedWikiGraphsToCheckWithShacl[] = "http://example.com/graph1";
$wgLinkedWikiGraphsToCheckWithShacl[] = "http://example.com/graph2";

$egPushAllAttachedNamespaces[] = "Data";

# Log-in unlogged users from these networks
$wgNetworkAuthUsers[] = [
        'iprange' => [ '127.0.0.1','172.19.0.2','172.19.0.4'],
        'user'    => 'NetworkAuthUser',
];
$wgNetworkAuthSpecialUsers[] = 'NetworkAuthUser';


$wgGroupPermissions['data']['delete'] = true;

$wgJobRunRate = 0;
error_reporting( E_ALL );
#ini_set( 'display_errors', 1 );
