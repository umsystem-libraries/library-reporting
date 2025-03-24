--metadb:function shining_circulation

-- Report pulls Shining a Light items with loan and renewal counts.

DROP FUNCTION IF EXISTS shining_circulation;

CREATE FUNCTION shining_circulation(
)
RETURNS TABLE(
    campus_name text,
    library_name text,
    location_name text,
    material_type text,
    title text,
    author_name date,
    publication_date text,
    barcode text,
    item_id text,
    item_hrid text,
    instance_id text,
    instance_hrid text,
    status_name text,
    created_date date,
    statistical_code_name text,
    total_loans text,
    total_renewals text)
AS $$
SELECT
	stat.statistical_code_name,
	cast (itemext.created_date as DATE),
	instext.title,
	--These functions put all the unique authors and publication dates into the same cell
	string_agg (distinct authors.contributor_name,' | ') as contributors,
	string_agg (distinct pubdate.date_of_publication, ' | ') as publication_dates,
	itemext.barcode,
	itemext.material_type_name as item_material_type_name,
    itemext.permanent_location_name,
    itemext.permanent_loan_type_name,
    itemext.effective_call_number,
    itemext.volume,
    itemext.copy_number,
	itemext.status_name,
	circ.num_loans,
	circ.num_renewals,	
	ll.library_name,
	itemext.item_id as item_id,
    itemext.item_hrid as item_hrid,
	instext.instance_id as instance_id,
    instex.instance_hrid as instance_hrid
FROM folio_derived.instance_ext as instext
	 LEFT JOIN folio_derived.instance_contributors AS authors ON instext.instance_id = authors.instance_id
	 LEFT JOIN folio_derived.instance_publication AS pubdate ON instext.instance_id = pubdate.instance_id
	 LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id        
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id       
     LEFT JOIN folio_derived.item_ext AS itemext ON he.holdings_id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     left join folio_derived.instance_formats as instfmt on instext.instance_id = instfmt.instance_id
     left join folio_derived.item_statistical_codes as stat on itemext.item_id = stat.item_id
     left join folio_derived.loans_renewal_count as circ on itemext.item_id = circ.item_id
WHERE stat.statistical_code = 'umkcshining'
group by 
	itemext.barcode,
	stat.statistical_code_name,
	itemext.created_date,
	instext.title,
	itemext.barcode,
	itemext.material_type_name,
    itemext.permanent_location_name,
    itemext.permanent_loan_type_name,
    itemext.effective_call_number,
    itemext.volume,
    itemext.copy_number,
	itemext.status_name,
	circ.num_loans,
	circ.num_renewals,	
	ll.library_name,
	itemext.item_id,
    itemext.item_hrid,
	instext.instance_id,
    instex.instance_hrid
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
