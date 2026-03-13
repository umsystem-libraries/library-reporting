--metadb:function link_count

DROP FUNCTION IF EXISTS link_count;

CREATE FUNCTION link_count(
    /* parameter for public note */
    public_note text DEFAULT '')
RETURNS TABLE(
    856_public_note text,
    suppressed text,
    records bigint) AS
$$
SELECT 
    u.public_note as 856_public_note,
    inst.discovery_suppress::text,
    COUNT(u.public_note) as records
FROM folio_derived.instance_electronic_access AS u
join folio_derived.instance_ext as inst on u.instance_hrid = inst.instance_hrid
where u.public_note like ('%'||public_note||'%')
group by u.public_note, inst.discovery_suppress
order by records desc
$$
LANGUAGE SQL;
