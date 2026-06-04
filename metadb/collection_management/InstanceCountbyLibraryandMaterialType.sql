select
	li.library_name,
	items.material_type_name,
	count (distinct he.instance_id )
FROM folio_derived.item_ext AS items
join folio_derived.holdings_ext he on items.holdings_record_id = he.id
join folio_derived.locations_libraries li on items.permanent_location_name = li.location_name
where (items.status_name != 'Withdrawn') and (items.permanent_location_name like 'UMKC%')
group by
	li.library_name,
	items.material_type_name
order by
	li.library_name,
	items.material_type_name