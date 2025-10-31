--metadb:function count_inhouse

DROP FUNCTION IF EXISTS count_inhouse;

CREATE FUNCTION count_inhouse(
    start_date date DEFAULT '1000-01-01',
    end_date date DEFAULT '3000-01-01')
RETURNS TABLE(
    location_name text,
    inhouse_count bigint)
AS $$
SELECT 
ll.location_name as location_name,
COUNT(ci.item_id) as inhouse_count
FROM folio_circulation.check_in__t AS ci
join folio_derived.locations_libraries as ll on ci.item_location_id = ll.location_id
WHERE ci.item_status_prior_to_check_in = 'Available' and ci.request_queue_size = '0' and ll.location_name like 'UMKC%' 
group by ll.location_name
order by location_name asc
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
