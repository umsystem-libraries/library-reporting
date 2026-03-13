--metadb:function umkc_orders

-- Query to get open orders

DROP FUNCTION IF EXISTS users_by_group;

CREATE FUNCTION users_by_group()
RETURNS TABLE(
    group text,
    users bigint)
AS $$
SELECT 
	group_name as group,
	COUNT(user_id) AS users
from folio_derived.users_groups
group by
    group_name
order by
    group_name asc
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;