-- Drop with explicit signature to avoid ambiguity
DROP FUNCTION IF EXISTS link_count;

-- Create function; consider schema-qualifying the function name if needed, e.g. reporting.link_count
CREATE FUNCTION link_count(
    /* parameter for public note filter */
    public_note text DEFAULT ''
)
RETURNS TABLE(
    856_public_note text,
    records bigint
)
LANGUAGE SQL
STABLE
AS $func$
SELECT 
    u.public_note AS 856_public_note,
    COUNT(u.public_note) AS records
FROM folio_derived.instance_electronic_access AS u
JOIN folio_derived.instance_ext AS inst 
  ON u.instance_hrid = inst.instance_hrid
WHERE u.public_note LIKE ('%' || public_note || '%')
GROUP BY u.public_note
ORDER BY records DESC
$func$;