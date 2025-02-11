SELECT
	i.item_id,
	inst.instance_hrid AS instance_hrid,
	i.created_date AS create_date,
	i.barcode,
	i.status_name AS status,
	i.effective_location_name,
	i.temporary_location_name,
	i.permanent_location_name,
	i.effective_call_number,
	i.chronology,
	i.enumeration,
	i.material_type_name,
	i.discovery_suppress as item_suppressed,
	link.title,
	em.effective_shelving_order,
	string_agg (distinct ic.contributor_name,' | ') as author,
	string_agg (DISTINCT ip.publisher, ' | ') AS publisher, 
	string_agg (DISTINCT ip.date_of_publication,' | ') AS date_publication,
	string_agg (DISTINCT sub.subjects, ' | ') AS inst_subject,
	--loans_items.item_status AS loan_item_status,
	--loans_items.loan_due_date,
	--loans_items.loan_return_date,
	loan_renewals.num_loans	
FROM 
	folio_derived.item_ext AS i
	LEFT JOIN folio_derived.loans_items ON i.item_id = loans_items.item_id
	LEFT JOIN folio_derived.loans_renewal_count AS loan_renewals ON i.item_id = loan_renewals.item_id
	LEFT JOIN folio_derived.items_holdings_instances AS link ON i.item_id = link.item_id
	LEFT JOIN folio_inventory.item__t__ as em on i.item_id = em.id
	LEFT JOIN folio_derived.instance_ext AS inst ON link.instance_id = inst.instance_id 
	LEFT JOIN folio_derived.instance_contributors AS ic ON inst.instance_id = ic.instance_id 
	LEFT JOIN folio_derived.instance_publication ip ON inst.instance_id = ip.instance_id 
	LEFT JOIN folio_derived.instance_subjects AS sub ON inst.instance_id = sub.instance_id 
WHERE

--i.created_date >= '2022-06-01'
 --AND i.created_date <= '2022-06-30'
--AND
i.effective_location_name  = 'UMKC Law General Collection' 
and
i.status_name in ('Aged to lost', 'Available', 'Awaiting delivery', 'Awaiting pickup', 'Checked out', 'Claimed returned', 'Declared lost', 'In process', 'In process (not requestable)', 'In transit', 'Intellection item', 'Long missing', 'Lost and paid', 'Missing', 'On order', 'Order closed', 'Paged', 'Restricted', 'Unavailable', 'Unknown')
GROUP BY
i.item_id,
inst.instance_hrid,
create_date,
i.barcode,
status,
i.effective_location_name,
i.temporary_location_name,
i.permanent_location_name,
i.effective_call_number,
i.chronology,
i.enumeration,
i.material_type_name,
item_suppressed,
link.title,
loan_item_status,
--loans_items.loan_due_date,
--loans_items.loan_return_date,
em.effective_shelving_order, 
--loan_renewals.num_loans;
