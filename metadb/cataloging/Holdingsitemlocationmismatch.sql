select
	ll.campus_name as campus,
	ll.library_name as library,
	itemext.call_number as item_call_number,
	itemext.barcode as item_barcode,
	itemext.item_id as item_uuid,
	itemext.item_hrid as item_hrid,
	instext.title as title,
	instext.instance_id as instance_uuid,
	instext.instance_hrid as instance_hrid,
    itemext.chronology as item_chronology,
    itemext.enumeration as item_enumberation,
    itemext.volume as item_volume,
    itemext.status_name as item_status,
    itemext.status_date::date as item_status_date,
    itemext.effective_location_name as item_effective_location,
    itemext.permanent_location_name as item_permanent_location,
    itemext.temporary_location_name as item_temporary_location,
    he.call_number as holdings_call_number,
    he.id as holdings_uuid,
    he.holdings_hrid as holdings_hrid,
	he.permanent_location_name as holdings_permanent_location,
	he.temporary_location_name as holdings_temporary_location,
    ii.effective_shelving_order COLLATE "C"

FROM folio_derived.instance_ext AS instext
     LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id        
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id       
     LEFT JOIN folio_derived.item_ext AS itemext ON he.id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     LEFT JOIN folio_derived.item_notes AS itemnotes ON itemext.item_id = itemnotes.item_id
     left join folio_derived.instance_contributors as contributors on instext.instance_id = contributors.instance_id

WHERE 
	itemext.permanent_location_name <> he.permanent_location_name


GROUP BY 
ll.campus_name,
	ll.library_name,
	itemext.call_number,
	itemext.barcode,
	itemext.item_id,
	itemext.item_hrid,
	instext.title,
	instext.instance_id,
	instext.instance_hrid,
    itemext.chronology,
    itemext.enumeration,
    itemext.volume,
    itemext.status_name,
    itemext.status_date,
    itemext.effective_location_name,
    itemext.permanent_location_name,
    itemext.temporary_location_name,
    he.call_number,
    he.id,
    he.holdings_hrid,
	he.permanent_location_name,
	he.temporary_location_name,
    ii.effective_shelving_order COLLATE "C"

	