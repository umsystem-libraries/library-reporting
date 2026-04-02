--select distinct instance_id from --count titles held
(select
	ll.campus_name,
	ll.library_name,
    itemext.permanent_location_name,
    itemext.barcode,
	itemext.material_type_name as item_material_type_name,
	he.type_name as holdings_type_name,
	instext.mode_of_issuance_name,
	instfmt.instance_format_name,
	instext.type_name as instance_type_name,
	instext.title,
	itemext.item_id,
	instext.instance_id,
	itemext.status_name,
	itemext.created_date
from folio_derived.instance_ext as instext
     LEFT JOIN folio_derived.holdings_ext AS he ON instext.instance_id = he.instance_id        
     LEFT JOIN folio_derived.locations_libraries AS ll ON he.permanent_location_id = ll.location_id       
     LEFT JOIN folio_derived.item_ext AS itemext ON he.holdings_id = itemext.holdings_record_id
     LEFT JOIN folio_inventory.item__t AS ii ON itemext.item_id = ii.id
     left join folio_derived.instance_formats as instfmt on instext.instance_id = instfmt.instance_id
/*USE THIS BLOCK FOR "PHYSICAL BOOKS (TITLE COUNT)*/
/*
where (ll.campus_name='University of Missouri - Columbia' or itemext.permanent_location_name in ('MU Library Depository 1', 'MU Library Depository 2', 
'MU Special Collections Library Depository 1','MU Special Collections Library Depository 2'))
	and ll.library_name not in ('Law Library ')
	--and he.type_name in ('Monograph') --commenting out this line for now: Seth reports that "a lot of serial holdings were migrated as type Monograph". Throwing out this filter raised an additional 5,469 itmes (including "Multi-part monogaph" and NULL values, and some erroneously-encoded "Serial" items; Seth says to leave them)
	and instext.mode_of_issuance_name in ('single unit')
	and itemext.material_type_name in ('Book', 'Score', 'Atlas')
	and instfmt.instance_format_name in ('unmediated -- volume')
	and instext.type_name in ('text', 'still image', 'notated music', 'cartographic image')
	--and not itemext.status_name = 'Withdrawn' --withdrawn items purged at beginning of fiscal year; still need to count for this year, though...
	and itemext.created_date between '2000-01-01' and '2025-06-30'
	and itemext.barcode is not null
*/
/*USE THIS BLOCK FOR "PHYSICAL BOOKS (VOLUME COUNT)*/
/*do not need to select distinct instance ids for this one!!!*/
where (ll.campus_name='University of Missouri - Columbia' or itemext.permanent_location_name in ('MU Library Depository 1', 'MU Library Depository 2', 
'MU Special Collections Library Depository 1','MU Special Collections Library Depository 2'))
	and ll.library_name not in ('Law Library ')
	--and he.type_name in ('Monograph') --commenting out this line for now: Seth reports that "a lot of serial holdings were migrated as type Monograph". Throwing out this filter raised an additional 5,469 itmes (including "Multi-part monogaph" and NULL values, and some erroneously-encoded "Serial" items; Seth says to leave them)
	--and instext.mode_of_issuance_name in ('single unit') --should include bound journals, etc. as volumes
	and itemext.material_type_name in ('Book', 'Score', 'Atlas', 'Journal', 'Serial')
	and instfmt.instance_format_name in ('unmediated -- volume')
	and instext.type_name in ('text', 'still image', 'notated music', 'cartographic image')
	--and not itemext.status_name = 'Withdrawn' --withdrawn items purged at beginning of fiscal year; still need to count for this year, though...
	and itemext.created_date between '2000-01-01' and '2025-06-30'
	and itemext.barcode is not null

) --as instance_count
;