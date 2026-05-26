CREATE OR REPLACE FUNCTION public.marc_mobius()
RETURNS TABLE(
    hrid text,
    title text,
    marc_998t text
)
LANGUAGE SQL
STABLE
PARALLEL SAFE
AS $$
SELECT 
    i.instance_hrid as hrid,
    i.title as title,
    mt.content as marc_998t
from folio_source_record.marc__t mt
JOIN folio_derived.instance_ext i ON i.instance_id = mt.instance_id
WHERE mt.field = '998' AND mt.sf = 't' AND mt.content is not null
$$