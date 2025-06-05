select
	instext.instance_hrid,
	instext.title,
	ie.effective_call_number,
	ie.item_hrid,
	ie.barcode,
	ie.permanent_location_name,
	COUNT(ci.id) as "In House Uses"
from folio_derived.instance_ext as instext
    LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id
    LEFT JOIN folio_derived.item_ext AS ie ON he.holdings_id = ie.holdings_record_id     
	LEFT JOIN folio_derived.loans_items AS li ON ie.item_id = li.item_id
	left join folio_derived.locations_libraries as ll on ie.permanent_location_id = ll.location_id 
	LEFT JOIN folio_circulation.check_in__t__ AS ci ON ie.item_id = ci.item_id
WHERE ci.item_status_prior_to_check_in = 'Available'
	and ll.library_code = 'CENGR'
group by instext.instance_hrid, instext.title, ie.effective_call_number, ie.item_hrid, ie.barcode, ie.permanent_location_name 