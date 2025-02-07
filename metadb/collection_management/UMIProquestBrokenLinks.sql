SELECT
	ll.library_name,           
    itemext.effective_location_name,
    itemext.permanent_location_name as item_perm_loc_name,
    itemext.barcode,
    instext.title,
    contributors.contributor_name,
    ip.date_of_publication,
    instext.instance_hrid,
    instext.instance_id,    
    itemext.item_id,
    itemext.item_hrid,
    iea.uri
FROM folio_derived.instance_ext AS instext
	 LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id        
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id     
     LEFT JOIN folio_derived.item_ext AS itemext ON he.holdings_id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     LEFT JOIN folio_derived.item_notes AS itemnotes ON itemext.item_id = itemnotes.item_id
     left join folio_derived.instance_contributors as contributors on instext.instance_id = contributors.instance_id
     LEFT JOIN folio_derived.instance_electronic_access AS iea ON instext.instance_id = iea.instance_id
     left join folio_derived.instance_publication as ip on instext.instance_id = ip.instance_id
WHERE iea.uri LIKE '%lib.umi.com/cr/%'
;