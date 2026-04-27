--metadb:function pol_noloc

-- Query to get pol_noloc

DROP FUNCTION IF EXISTS pol_noloc;

CREATE FUNCTION pol_noloc(
    acq_unit text DEFAULT '*'
)
RETURNS TABLE(
    acq_unit text,
    pol_uuid text,
    pol_number text,
    title text,
    shelving_location text)
AS $$
SELECT 
    acq.po_acquisition_unit_name as acq_unit,
    loc.pol_id as pol_uuid,
    instance.po_line_number as pol_number,
    instance.title as title,
    loc.pol_location_name as shelving_location
FROM folio_derived.po_lines_locations AS loc
left JOIN folio_derived.po_instance as instance on loc.pol_id = instance.po_line_id
left join folio_derived.po_acq_unit_ids as acq on instance.po_number = acq.po_number
WHERE loc.pol_location_name IS null and acq.po_acquisition_unit_name = acq_unit
order by
    acq_unit
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
