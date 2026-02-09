--select distinct instance_id from
(select
	ll.campus_name,
	ll.library_name,
    itemext.permanent_location_name,
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
/*USE THIS BLOCK FOR MONOGRAPHS*/
where (ll.campus_name='University of Missouri - Columbia' or itemext.permanent_location_name in ('MU Library Depository 1', 'MU Library Depository 2', 
'MU Special Collections Library Depository 1','MU Special Collections Library Depository 2'))
	and ll.library_name not in ('Law Library ')
	--and he.type_name in ('Monograph') --commenting out this line for now: Seth reports that "a lot of serial holdings were migrated as type Monograph". Throwing out this filter raised an additional 5,469 itmes (including "Multi-part monogaph" and NULL values, and some erroneously-encoded "Serial" items; Seth says to leave them)
	and instext.mode_of_issuance_name in ('single unit')
	and itemext.material_type_name in ('Book', 'Score')
	and instfmt.instance_format_name in ('unmediated -- volume')
	and instext.type_name in ('text', 'still image', 'notated music')
	and not itemext.status_name = 'Withdrawn'
	and itemext.created_date between '2000-01-01' and '2025-06-30'
/*USE THIS BLOCK FOR SERIALS*/
/*where (ll.campus_name='University of Missouri - Columbia' or itemext.permanent_location_name in ('MU Library Depository 1', 'MU Library Depository 2', 
'MU Special Collections Library Depository 1','MU Special Collections Library Depository 2'))
	and ll.library_name not in ('Law Library ')
	--and he.type_name in ('Serial') --some are NULL in the holdings table?
	and instext.mode_of_issuance_name in ('serial', 'integrating resource')
	--and itemext.material_type_name in ('Book', 'Score')
	and not instfmt.instance_format_name = 'computer -- online resource'
	--and instext.type_name in ('text', 'still image', 'notated music')
	and not itemext.status_name = 'Withdrawn'
	and itemext.created_date between '2000-01-01' and '2025-06-30'
*/
/*USE THIS BLOCK FOR MAPS*/
/*
where (ll.campus_name='University of Missouri - Columbia' or itemext.permanent_location_name in ('MU Library Depository 1', 'MU Library Depository 2', 
'MU Special Collections Library Depository 1','MU Special Collections Library Depository 2'))
	and ll.library_name not in ('Law Library ')
	and instext.mode_of_issuance_name in ('single unit')
	--and itemext.material_type_name in ('Map', 'Atlas') 
	and instext.type_name in ('cartographic image', 'cartographic dataset')
	and instfmt.instance_format_name in ('unmediated -- sheet', 'unmediated -- volume')
	and not itemext.status_name = 'Withdrawn'
	and itemext.created_date between '2000-01-01' and '2025-06-30'
*/
/*USE THIS BLOCK FOR MEDIA*/
/*where (ll.campus_name='University of Missouri - Columbia' or itemext.permanent_location_name in ('MU Library Depository 1', 'MU Library Depository 2', 
'MU Special Collections Library Depository 1','MU Special Collections Library Depository 2'))
	and ll.library_name not in ('Law Library ')
	and instext.mode_of_issuance_name not in ('serial', 'integrating resource')
	and itemext.material_type_name not in ('Book', 'Score')
    --and itemext.material_type_name like '%VHS%'
	and instext.type_name not in ('cartographic image', 'cartographic dataset', 'notated music')
	and instfmt.instance_format_name not in ('unmediated -- volume', 'computer -- online resource')
	and not itemext.status_name = 'Withdrawn'
	and itemext.created_date between '2000-01-01' and '2025-06-30'
*/
) --as instance_count

;
