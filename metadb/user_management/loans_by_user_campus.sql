select 
	li.barcode,
	li.current_item_permanent_location_campus_name,
	li.user_id,
	u.id,
	u.jsonb	
from folio_derived.loans_items as li
	left join folio_users.users__ as u on li.user_id = u.id
where u.jsonb @> '{"customFields":{"campus_2":["opt_3"]}}' and "__current" = true
	and li.loan_status = 'Open'
;
