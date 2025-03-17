--metadb:function circulated_items

-- Report pulls items with at least 1 FOLIO loan for the selected library.

DROP FUNCTION IF EXISTS circulated_items;

CREATE FUNCTION circulated_items(
)
RETURNS TABLE(
    created_date date,
    title text,
    contributors text,
    publication_dates text,
    barcode text,
    library text,
    shelving_location text,
    material_type text,
    loan_type text,
    call_number text,
    volume text,
    copy_number text,
    item_status text,
    loans bigint,
    renewals bigint,
    item_id uuid,
    instance_id uuid)
AS $$
SELECT
	cast (itemext.created_date as DATE) as created_date,
	instext.title as title,
	--These functions put all the unique authors and publication dates into the same cell
	string_agg (distinct authors.contributor_name,' | ') as contributors,
	string_agg (distinct pubdate.date_of_publication, ' | ') as publication_dates,
	itemext.barcode as barcode,
	itemext.material_type_name as material_type,
    itemext.permanent_location_name as shelving_location,
    itemext.permanent_loan_type_name as loan_type,
    itemext.effective_call_number as call_number,
    itemext.volume as volume,
    itemext.copy_number as copy_number,
	itemext.status_name as item_status,
	circ.num_loans as loans,
	circ.num_renewals as renewals,	
	ll.library_name as library,
	itemext.item_id as item_id,
	instext.instance_id as instance_id
FROM folio_derived.instance_ext as instext
	 LEFT JOIN folio_derived.instance_contributors AS authors ON instext.instance_id = authors.instance_id
	 LEFT JOIN folio_derived.instance_publication AS pubdate ON instext.instance_id = pubdate.instance_id
	 LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id        
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id       
     LEFT JOIN folio_derived.item_ext AS itemext ON he.holdings_id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     left join folio_derived.loans_renewal_count as circ on itemext.item_id = circ.item_id
WHERE ll.library_name = 'UMKC Law Library' AND circ.num_loans > 0
group by 
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
	instext.instance_id
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
