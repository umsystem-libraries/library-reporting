-- MARC 998 $t = 1 to suppress in MOBIUS catalog

DROP FUNCTION IF EXISTS marc_998;

CREATE FUNCTION marc_998()

RETURNS TABLE(
    hrid text,
    title text,
    marc_998t text)
AS $$
SELECT 
    i.instance_hrid as hrid,
    i.title as title,
    mt.content as marc_998t
from folio_source_record.marc__t mt
    JOIN folio_derived.instance_ext i
        ON i.instance_id = mt.instance_id
    WHERE mt.field = '998'
        AND mt.sf = 't'
        AND mt.content is not null
order by
    title
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
