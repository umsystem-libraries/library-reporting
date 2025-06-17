SELECT 
	instance.instance_id, 
	instance.instance_hrid, 
	cast (instance.cataloged_date as date) as cataloged_date, 
	instance.title, 
	instance.instance_source, 
	instance.discovery_suppress, 
	instance.staff_suppress, 
	instance.status_name,
	instance.record_source,
	cast (instance.record_created_date as date) as created_date,
	instance.is_bound_with,
	holdings.holdings_hrid as holdings_hrid
FROM folio_derived.instance_ext as instance
	left join folio_derived.holdings_ext as holdings on instance.instance_id = holdings.instance_id 
WHERE holdings.holdings_hrid is null
;