select
	l.loan_id,
	l.item_id,
	l.loan_status,
	l.loan_date,
	l.loan_due_date,
	l.loan_return_date,
	l.checkout_service_point_name,
	l.loan_policy_name,
	l.patron_group_name
FROM folio_derived.loans_items AS l
WHERE l.loan_date between '2024-07-01' and '2025-07-01' and l.checkout_service_point_name like 'UMKC%'and l.item_effective_location_name_at_check_out = 'DCB'