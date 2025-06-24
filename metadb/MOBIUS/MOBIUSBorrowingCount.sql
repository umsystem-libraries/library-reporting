SELECT 
	l.checkout_service_point_name,
	COUNT (l.loan_id)
FROM folio_derived.loans_items AS l
WHERE l.loan_date between 'START' and 'END' and l.checkout_service_point_name like 'VALUE'and l.item_effective_location_name_at_check_out = 'DCB'
group by l.checkout_service_point_name