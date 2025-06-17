select
	items.item_hrid,
	items.barcode,
	items.status_name,
	cast (items.status_date as date) as status_date,
	items.material_type_name,
	items.permanent_location_name
FROM folio_derived.item_ext AS items
left join folio_derived.item_tags as tags on items.item_id = tags.item_id 
where (items.status_date between 'BEGIND' and 'END') and (items.status_name = 'Withdrawn') and (items.permanent_location_name like 'VALUE')
group by
	items.item_hrid,
	items.barcode,
	items.status_name,
	status_date,
	items.material_type_name,
	items.permanent_location_name