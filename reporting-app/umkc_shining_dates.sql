--metadb:function umkc_shining_dates

-- Query to get Shining a Light items

DROP FUNCTION IF EXISTS umkc_shining_dates;

CREATE FUNCTION umkc_shining_dates(
    start_date date DEFAULT '2000-01-01',
    end_date date DEFAULT '2050-01-01',
)
RETURNS TABLE(
    statistical_code text,
    instance_id text,
    instance_hrid text,
    item_id text,
    item_hrid text,
    title text,
    contributors text,
    publication_dates text,
    barcode text,
    item_location text,
    checkouts bigint)
AS $$
SELECT 
	stat.statistical_code_name as statistical_code,
    instances.instance_id as instance_id,
    instances.instance_hrid as instance_hrid,
    items.item_id as item_id,
    items.item_hrid as item_hrid,
    instances.title as title,
    string_agg (distinct authors.contributor_name,' | ') as contributors,
	string_agg (distinct pubdate.date_of_publication, ' | ') as publication_dates,
    items.barcode as barcode,
    items.effective_location_name as item_location,
	-- COUNT(*) AS checkouts
from folio_derived.loans_items as loans
    left join folio_derived.item_ext as items on loans.item_id = items.item_id
    left join folio_derived.item_statistical_codes as stat on items.item_id = stat.item_id
    LEFT JOIN folio_derived.holdings_ext AS holdings ON holdings.holdings_id = items.holdings_record_id
	left join folio_derived.instance_ext as instances on holdings.instance_id = instances.instance_id
    LEFT JOIN folio_derived.instance_contributors AS authors ON instances.instance_id = authors.instance_id
	LEFT JOIN folio_derived.instance_publication AS pubdate ON instances.instance_id = pubdate.instance_id
where start_date <= loans.loan_date AND loans.loan_date < end_date and stat.statistical_code = 'umkcshining'
group by
	stat.statistical_code_name,
    instances.instance_id,
    instances.instance_hrid,
	items.item_id,
    items.item_hrid,
	instances.title,
	items.barcode,
	items.effective_location_name
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
