SELECT
	ll.library_name,           
    itemext.effective_location_name,
	he.permanent_location_name as holdings_perm_loc_name,
    itemext.permanent_location_name as item_perm_loc_name,
    itemext.barcode,
    instext.title,
    itemext.chronology,
    itemext.enumeration,
    itemext.volume,
    ip.publisher,
    contributors.contributor_name,
    itemext.status_name AS item_status,
    itemext.status_date::date as item_status_date,
--    string_agg (distinct itemnotes.note,' | ') as item_notes,
    itemext.material_type_name AS format,
    he.temporary_location_name as holdings_temp_loc_name,   
    itemext.temporary_location_name as item_temp_loc_name, 
    instext.instance_hrid,
    instext.instance_id,--added LM    
    he.holdings_hrid,
    itemext.item_id,
    itemext.item_hrid,    
    ii.effective_shelving_order COLLATE "C"

FROM folio_derived.instance_ext AS instext
	 left join folio_derived.instance_publication as ip on instext.instance_id = ip.instance_id 
     LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id  
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id       
     LEFT JOIN folio_derived.item_ext AS itemext ON he.holdings_id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     LEFT JOIN folio_derived.item_notes AS itemnotes ON itemext.item_id = itemnotes.item_id
     left join folio_derived.instance_contributors as contributors on instext.instance_id = contributors.instance_id

WHERE 
	ip.publisher ilike '%gruyter%'
	--and	itemext.effective_location_name in ('MU Library Depository 1', 'MU Library Depository 2')
	--AND itemext.material_type_name in ('Serial', 'Journal', 'Book')

/*order by 
	instext.title,
	itemext.chronology,
	itemext.enumeration,
	itemext.volume
*/
GROUP BY 
	ll.library_name,           
	    he.permanent_location_name,
	    he.temporary_location_name,
	    itemext.permanent_location_name,
	    itemext.temporary_location_name,
	    itemext.effective_location_name,
	    instext.instance_hrid,
	    instext.instance_id, --added
	    he.holdings_hrid,
	    itemext.item_id,
	    itemext.item_hrid,
	    itemext.barcode,
        instext.title,
	    itemext.chronology,
	    itemext.enumeration,
	    itemext.volume,
        ip.publisher,	    
	    contributors.contributor_name,
        itemext.status_name,
        itemext.status_date::date,
        itemext.material_type_name,
        ii.effective_shelving_order COLLATE "C"
;