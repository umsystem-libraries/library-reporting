--metadb:function loan_count_by_item

-- Report produces a list of individual loans which can then be
-- grouped and summed to create loans and renewals counts.

DROP FUNCTION IF EXISTS loan_count_by_item;

CREATE FUNCTION loan_count_by_item(
    /* Choose a start and end date for the loans period */
    start_date date DEFAULT '2000-01-01',
    end_date date DEFAULT '2050-01-01',
    /* Specify one of the following to filter by location */
    items_permanent_location_filter text DEFAULT '', -- 'Online', 'Annex', 'Main Library'
    items_temporary_location_filter text DEFAULT '', -- 'Online', 'Annex', 'Main Library'
    items_effective_location_filter text DEFAULT '', -- 'Online', 'Annex', 'Main Library'
    /* The following connect to the item's permanent location */
    institution_filter text DEFAULT '', -- 'KÃ¸benhavns Universitet', 'Montoya College'
    campus_filter text DEFAULT '', -- 'Main Campus', 'City Campus', 'Online'
    library_filter text DEFAULT '') -- 'Datalogisk Institut', 'Adelaide Library'
returns TABLE(
    date_range text,
    instance_HRID text,
    item_HRID text,
    title text,
    num_loans bigint,
    num_renewals bigint,
    last_loan_date timestamptz,
    last_return_date timestamptz,
    barcode text,
    effective_call_number text,
    loan_type_name text,
    material_type_name text,
    permanent_location_name text,
    effective_location_name text) as
&&
SELECT start_date || ' to ' || end_date AS date_range,
	instext.instance_hrid,
	ie.item_hrid,
	instext.title,
	COUNT(li.loan_id) as "Number of Loans",
	coalesce(SUM(li.renewal_count), 0) as "Number of Renewals",
	MAX(li.loan_date) AS "Last Loan Date",
	MAX(li.loan_return_date) as "Last Return Date",
	ie.barcode,
	ie.effective_call_number,
	ie.permanent_loan_type_name,
	ie.material_type_name as "material type",
	ie.permanent_location_name,
	ie.effective_location_name
from folio_derived.instance_ext as instext
    LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id
    LEFT JOIN folio_derived.item_ext AS ie ON he.holdings_id = ie.holdings_record_id     
	LEFT JOIN folio_derived.loans_items AS li ON ie.item_id = li.item_id and li.loan_date > start_date
	left join folio_derived.locations_libraries as ll on ie.permanent_location_id = ll.location_id 
where ll.library_code = 'CENGR' 
group by date_range, instext.instance_hrid, ie.item_hrid, instext.title, ie.effective_call_number, ie.item_hrid, ie.barcode, ie.permanent_location_name, li.loan_policy_name, ie.material_type_name  
&&
LANGUAGE SQL;
