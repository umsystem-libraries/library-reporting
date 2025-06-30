select
	l.loan_id,
	l.item_id,
	l.loan_status,
	l.loan_date,
	l.loan_due_date,
	l.loan_return_date,
	l.checkout_service_point_name,
	b.title,
	l.item_effective_location_name_at_check_out,
	items.effective_call_number,
	items.volume,
	l.material_type_name,
	l.permanent_loan_type_name
FROM folio_derived.loans_items AS l
	join folio_derived.item_ext as items on l.item_id = items.item_id
	join folio_derived.holdings_ext as h on items.holdings_record_id = h.holdings_id
	join folio_derived.instance_ext as b on h.instance_id = b.instance_id
WHERE l.loan_date >= '2024-07-01' and l.current_item_permanent_location_library_name like 'UMKC%'and l.checkout_service_point_name like 'DCB%'