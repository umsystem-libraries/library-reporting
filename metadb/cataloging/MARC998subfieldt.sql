-- MARC 998 $t = 1 to suppress in MOBIUS catalog
SELECT 
    i.instance_hrid as "Instance HRID",
    i.title,
    mt.content AS "MARC 998 $t"
FROM folio_source_record.marc__t mt
JOIN folio_derived.instance_ext i
  ON i.instance_id = mt.instance_id
WHERE mt.field = '998'
  AND mt.sf = 't'
  AND mt.content is not null;