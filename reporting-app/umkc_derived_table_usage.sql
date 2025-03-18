--metadb:function derived_usage

-- Test query to get circulations for selected items

DROP FUNCTION IF EXISTS derived_usage;

CREATE FUNCTION derived_usage()
RETURNS TABLE(
    scheme text,
    table_name text,
    usage bigint,
    last_scanned_date date
)
AS $$
SELECT 
    schemaname as scheme, 
    relname as table_name, 
    seq_scan as usage, 
    last_seq_scan as last_scanned_date,  
from pg_stat_user_tables WHERE schemaname LIKE 'folio_derived%'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
