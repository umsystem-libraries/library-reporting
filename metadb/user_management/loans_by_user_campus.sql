select 
	li.current_item_permanent_location_campus_name,
	li.barcode,
	instext.title,
	u.jsonb	
from folio_derived.loans_items as li
	left join folio_users.users__ as u on li.user_id = u.id
	left join folio_derived.holdings_ext AS he ON li.holdings_record_id = he.holdings_id
	left join folio_derived.instance_ext as instext on he.instance_id = instext.instance_id
where u.jsonb @> '{"customFields":{"campus_2":["opt_3"]}}' and "__current" = true
	and li.loan_status = 'Open'
;
