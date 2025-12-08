--metadb:function mobius_loans

DROP FUNCTION IF EXISTS mobius_loans;

CREATE FUNCTION mobius_loans(
    campus_prefix text DEFAULT '')
RETURNS TABLE(
    user_barcode text,
    last_name text,
    loan_status text,
    loan_date date,
    due_date date,
    MOBIUS_service_point text,
    barcode text,
    title text,
    shelving_location text,
    call_number text,
    volume text,
    material_type text,
    loan_type text,
    loan_uuid text,
    item_uuid text)
AS $$
SELECT 
	jsonb_extract_path_text(u.jsonb, 'barcode') AS user_barcode,
	jsonb_extract_path_text(u.jsonb, 'personal', 'lastName') AS last_name,
	l.loan_status as loan_status,
	cast (l.loan_date as DATE) as loan_date,
	cast (l.loan_due_date as DATE) as due_date,
	l.checkout_service_point_name as MOBIUS_service_point,
	l.barcode as barcode, 
	b.title as title,
	l.item_effective_location_name_at_check_out as shelving_location,
	items.effective_call_number as call_number,
	items.volume as volume,
	l.material_type_name as material_type,
	l.permanent_loan_type_name as loan_type,
	l.loan_id as loan_uuid,
	l.item_id as item_uuid
FROM folio_derived.loans_items AS l
	join folio_derived.item_ext as items on l.item_id = items.item_id
	join folio_derived.holdings_ext as h on items.holdings_record_id = h.holdings_id
	join folio_derived.instance_ext as b on h.instance_id = b.instance_id
	join folio_users.users as u on l.user_id = u.id
WHERE (l.item_effective_location_name_at_check_out like campus_prefix ||'%') and (l.checkout_service_point_name like 'DCB%') and (l.loan_status <> 'Closed')
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
