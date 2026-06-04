--metadb:function instance_counts

DROP FUNCTION IF EXISTS instance_counts;

CREATE FUNCTION instance_counts()
RETURNS TABLE(
    library_name text,
    materia_type text,
    instance_count bigint)
AS $$
select
	li.library_name as library_name,
	items.material_type_name as material_type,
	count (distinct he.instance_id ) as instance_count
FROM folio_derived.item_ext AS items
join folio_derived.holdings_ext he on items.holdings_record_id = he.id
join folio_derived.locations_libraries li on items.permanent_location_name = li.location_name
where (items.status_name != 'Withdrawn') and (items.permanent_location_name like 'UMKC%')
group by
	li.library_name,
	items.material_type_name
order by
	li.library_name,
	items.material_type_name
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;