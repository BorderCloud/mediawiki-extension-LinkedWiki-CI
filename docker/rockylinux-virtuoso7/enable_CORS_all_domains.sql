DB.DBA.VHOST_REMOVE (lpath=>'/sparql');
DB.DBA.VHOST_DEFINE (lpath=>'/sparql', ppath=>'/!sparql/', is_dav=>1, vsp_user=>'dba', opts=>vector('cors', '*', 'browse_sheet', '', 'noinherit', 'yes'));
