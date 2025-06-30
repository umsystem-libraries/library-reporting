--metadb:function mobius_loans

DROP FUNCTION IF EXISTS mobius_loans;

CREATE FUNCTION mobius_loans(
    start_date date DEFAULT '2000-01-01',
    end_date date DEFAULT '2050-01-01',
)
RETURNS TABLE(
    library_name text,
    loan_count text
)
AS $$
SELECT
	l.current_item_permanent_location_library_name as library_name,
    loan_id as loan_count
    FROM folio_derived.loans_items AS l
    WHERE (l.loan_date between start_date and end_date) and l.current_item_permanent_location_campus_name = 'University of Missouri - Kansas City' and l.checkout_service_point_name like 'DCB%'
    GROUP BY l.current_item_permanent_location_library_name
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
