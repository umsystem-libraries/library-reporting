--metadb:function count_loans

DROP FUNCTION IF EXISTS count_loans;

CREATE OR REPLACE FUNCTION count_loans(
    start_date date DEFAULT '1000-01-01',
    end_date date DEFAULT '3000-01-01'
)
RETURNS TABLE(
    barcode text,
    title text,
    permanent_location text,
    material_type text,
    loan_count bigint
)
AS $$
    SELECT
        i.barcode as barcode,
        inst.title AS title,
        loc.name AS permanent_location,
        mt.name AS material_type,
        COUNT(*) AS loan_count
    FROM folio_circulation.loan__t l
    LEFT JOIN folio_inventory.item__t i
        ON i.id = l.item_id::uuid
    LEFT JOIN folio_inventory.holdings_record__t h
        ON h.id = i.holdingsrecordid
    LEFT JOIN folio_inventory.instance__t inst
        ON inst.id = h.instanceid
    LEFT JOIN folio_inventory.location__t loc
        ON loc.id = h.permanentlocationid
    LEFT JOIN folio_inventory.material_type__t mt
        ON mt.id = i.materialtypeid
    WHERE start_date <= l.loan_date::date
      AND l.loan_date::date < end_date
    GROUP BY
        i.barcode,
        inst.title,
        loc.name,
        mt.name
    ORDER BY
        loan_count desc
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
