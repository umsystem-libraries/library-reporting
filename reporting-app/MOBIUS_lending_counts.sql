--metadb:function mobius_loans

DROP FUNCTION IF EXISTS mobius_loans;

CREATE FUNCTION mobius_loans(
    start_date date DEFAULT '1000-01-01',
    end_date date DEFAULT '3000-01-01'),
    campus text DEFAULT 'University of Missouri - Kansas City'

RETURNS TABLE(
    library_name text,
    loan_count bigint)
AS $$
SELECT ,
	l.current_item_permanent_location_library_name as library_name,	
	count (*) as loan_count
    FROM folio_derived.loans_items AS l
    WHERE l.loan_date between '2024-07-01' and '2025-08-01' and l.current_item_permanent_location_campus_name = 'University of Missouri - Kansas City' and l.checkout_service_point_name like 'DCB%'
    GROUP BY l.current_item_permanent_location_library_name
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
