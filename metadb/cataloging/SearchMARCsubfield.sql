select 
marc.instance_id as instance,
inst.cataloged_date as cataloged_date,
marc.field as field,
marc.sf as subfield,
marc.content as content

from 
folio_source_record.marc__t as marc 
LEFT JOIN folio_inventory.instance__t as inst on marc.instance_id = inst.id

where marc.field = '245'
and marc.sf = 'h'
and marc.content LIKE N'%\[electronic resource\]%'escape '\'
and inst.cataloged_date > '2023-06-30' and inst.cataloged_date < '2024-07-01'

group by
marc.instance_id,
inst.cataloged_date,
marc.field,
marc.sf,
marc.content