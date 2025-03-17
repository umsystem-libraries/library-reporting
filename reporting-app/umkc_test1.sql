--metadb:function UMKC test query

-- Test query to work through MetaDB to Reporting App translations.

DROP FUNCTION IF EXISTS umkc_test;

CREATE FUNCTION umkc_test()
RETURNS TABLE(
    holdings_id text,
    title text,
    holdings_hrid text,
    library_name text)
AS $$
SELECT 
	holdings.instance_id as holdings_id,
	instance.title as title,
	holdings.holdings_hrid as holdings_hrid,
	libraries.library_name as library_name
FROM folio_derived.holdings_ext as holdings
	left join folio_derived.instance_ext as instance on holdings.instance_id = instance.instance_id	
	LEFT JOIN folio_derived.locations_libraries AS libraries ON holdings.permanent_location_id = libraries.location_id
	LEFT JOIN folio_derived.item_ext AS items ON holdings.holdings_id = items.holdings_record_id
where items.holdings_record_id is null and libraries.library_name = 'UMKC Miller Nichols Library'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
