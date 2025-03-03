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
    instance_id text,
    status_name text,
    created_date date,
    statistical_code_name text,
    total_loans text,
    total_renewals text)
AS $$
SELECT
	ll.campus_name as campus_name,
	ll.library_name as library_name,
    itemext.permanent_location_name as location_name,
	itemext.material_type_name as material_type,
	instext.title as title,
    cast (pubdate.date_of_publication as date) as publication_date,
	pubdate.date_of_publication as publication_date,
	itemext.barcode as barcode,
	itemext.item_id as item_id,
	instext.instance_id as instance_id,
	itemext.status_name as status_name,
	itemext.created_date as created_date,
	stat.statistical_code_name as statistical_code_name,
    circ.num_loans,
	circ.num_renewals  
FROM folio_derived.instance_ext as instext
     LEFT JOIN folio_derived.instance_contributors AS authors ON instext.instance_id = authors.instance_id
	 LEFT JOIN folio_derived.instance_publication AS pubdate ON instext.instance_id = pubdate.instance_id
     LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id        
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id       
     LEFT JOIN folio_derived.item_ext AS itemext ON he.holdings_id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     LEFT JOIN folio_derived.instance_formats as instfmt on instext.instance_id = instfmt.instance_id
     LEFT JOIN folio_derived.item_statistical_codes as stat on itemext.item_id = stat.item_id
     LEFT JOIN folio_derived.loans_renewal_count as circ on itemext.item_id = circ.item_id
WHERE (ll.library_name='UMKC Music/Media Library')
	AND stat.statistical_code = 'umkcshining'
ORDER BY he.permanent_location_name 
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
