SELECT 
	l.current_item_permanent_location_library_name,	
	count (l.loan_id)
FROM folio_derived.loans_items AS l
WHERE l.loan_date between 'START' and 'END' and l.current_item_permanent_location_library_name like 'VALUE'and l.checkout_service_point_name like 'DCB%'
group by l.current_item_permanent_location_library_name