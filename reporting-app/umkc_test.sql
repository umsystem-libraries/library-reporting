--metadb:function umkc_test

-- Test query to get circulations for selected items

DROP FUNCTION IF EXISTS umkc_test;

CREATE FUNCTION umkc_test()
RETURNS TABLE(
    statistical_code text,
    item_id text,
    barcode text,
    item_location text,
    loans bigint,
    renewals bigint)
AS $$
SELECT 
	stat.statistical_code_name as statistical_code,
    circ.item_id as item_id,
    items.barcode as barcode,
    items.effective_location_name as item_location,
	circ.num_loans as loans,
	circ.num_renewals as renewals
from folio_derived.loans_renewal_count as circ
    left join folio_derived.item_ext as items on circ.item_id = items.item_id
    left join folio_derived.item_statistical_codes as stat on items.item_id = stat.item_id
where circ.num_loans > 0 and stat.statistical_code = 'umkcshining'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
