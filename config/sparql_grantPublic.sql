--  #default config
--  grant SPARQL_UPDATE to "SPARQL"; 
--  grant execute on SPARUL_CLEAR to "SPARQL";
--  grant execute on SPARUL_CLEAR to SPARQL_UPDATE;
--  GRANT EXECUTE ON DB.DBA.SPARUL_LOAD_SERVICE_DATA TO "SPARQL";
--  GRANT EXECUTE ON DB.DBA.SPARQL_SD_PROBE TO "SPARQL";
--  GRANT EXECUTE ON DB.DBA.L_O_LOOK TO "SPARQL";
--  grant execute on DB.DBA.RDF_QUAD to SPARQL_UPDATE;
--  grant select on "DB.DBA.SPARQL_SINV_2" to "SPARQL";
--  grant execute on "DB.DBA.SPARQL_SINV_IMP" to "SPARQL";
-- grant execute on DB.DBA.SPARQL_INSERT_DICT_CONTENT  to "SPARQL";
-- grant execute on DB.DBA.SPARQL_INSERT_DICT_CONTENT  to SPARQL_UPDATE;
-- grant execute on DB.DBA.SPARQL_DELETE_DICT_CONTENT  to "SPARQL";
-- grant execute on DB.DBA.SPARQL_DELETE_DICT_CONTENT  to SPARQL_UPDATE;
-- grant execute on DB.DBA.SPARUL_LOAD  to "SPARQL";
-- grant execute on DB.DBA.SPARUL_LOAD  to SPARQL_UPDATE;



grant select on "DB.DBA.SPARQL_SINV_2" to "SPARQL";
grant execute on "DB.DBA.SPARQL_SINV_IMP" to "SPARQL";

grant execute on DB.DBA.SPARQL_INSERT_DICT_CONTENT  to SPARQL_UPDATE;
grant execute on DB.DBA.SPARQL_DELETE_DICT_CONTENT  to SPARQL_UPDATE;
grant execute on DB.DBA.SPARUL_LOAD  to SPARQL_UPDATE;
grant execute on DB.DBA.SPARUL_CLEAR to SPARQL_UPDATE;
