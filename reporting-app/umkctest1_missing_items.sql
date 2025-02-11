--metadb:function missing_items

-- Report pulls a list of missing items, by location if entered, for searching.

DROP FUNCTION IF EXISTS missing_items;

CREATE FUNCTION missing_items(
    shelving_location text DEFAULT '04e89fe3-0739-49f2-9296-713e1e034ddd'
)
RETURNS TABLE(
    item_location text,
    item_barcode text,
    item_call_number text,
    item_enumeration text,
    item_volume text,
    item_title text)
AS $$
WITH missing AS (
    SELECT jsonb_extract_path_text(jsonb, 'id')::uuid AS item_id
        FROM folio_inventory.item
        WHERE jsonb_extract_path_text(jsonb, 'status', 'name') = 'Missing' AND jsonb_extract_path_text(jsonb, 'permanentLocationId') = shelving_location
)
SELECT loc.name AS item_location,
       item.barcode AS item_barcode,
       hld.call_number AS item_call_number,
       item.enumeration AS item_enumeration,
       item.volume AS item_volume,
       inst.title AS item_title
    FROM missing
        LEFT JOIN folio_inventory.item__t AS item ON missing.item_id = item.id
        LEFT JOIN folio_inventory.location__t AS loc ON item.effective_location_id::uuid = loc.id
        LEFT JOIN folio_inventory.holdings_record__t AS hld ON item.holdings_record_id::uuid = hld.id
        LEFT JOIN folio_inventory.instance__t AS inst ON hld.instance_id::uuid = inst.id
    ORDER BY item_title, item_location, item_call_number
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
