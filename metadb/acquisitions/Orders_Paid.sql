select
	cast (it.payment_date as date) as "Payment Date",
	acq.po_acquisition_unit_name as "Acq Unit",
	orders.order_type as "Order Type",
CASE
    WHEN sub.po_ongoing_is_subscription = true THEN 'Yes'
    ELSE 'No'
end as "Subscription?",
	acq.po_number as "PO",
	poline.po_line_number as "POL",
	poline.title_or_package as "Title",
	poline.order_format as "Order Format",
	phys.pol_mat_type_name as "Material Type",
	eresource.provider_org_name as "Access Provider",
	ermat.pol_er_mat_type_name as "Material Type E",
string_agg(
prod.product_id || ': ' || prod.product_id_type,
   '; '
) AS "Product IDs",
	poline.source as "Source",
	poline.requester as "Requester",
	poline.po_line_description as "Description",
	poline.payment_status as "Payment Status",
	inv.invoice_line_status as "Invoice Line Status",
	inv.total as "Total",
	fit.transaction_fund_code as "Fund Code",
	fit.transactions_expense_class_name as "Expense Class"
FROM folio_orders.po_line__t poline 
left join folio_derived.po_lines_er_mat_type as ermat on poline.id = ermat.pol_id
left join folio_invoice.invoice_lines__t inv on poline.id = inv.po_line_id 
left join folio_invoice.invoices__t it on inv.invoice_id = it.id 
left JOIN folio_derived.finance_invoice_transactions fit ON fit.invoice_line_id = inv.id
left join folio_derived.po_acq_unit_ids as acq on poline.purchase_order_id = acq.po_id
left join folio_orders.purchase_order__t as orders on poline.purchase_order_id = orders.id 
left join folio_derived.po_ongoing as sub on orders.id = sub.po_id
left join folio_derived.po_lines_eresource as eresource on poline.id = eresource.pol_id
left join folio_derived.po_lines_phys_mat_type as phys on poline.id = phys.pol_id
left join folio_derived.po_prod_ids as prod on poline.id = prod.pol_id
where acq.po_acquisition_unit_name like 'UMKC%' and poline.payment_status like '%Paid%' and it.payment_date > '2025-06-30'
group by acq.po_acquisition_unit_name, orders.order_type, sub.po_ongoing_is_subscription, acq.po_number, poline.po_line_number, poline.title_or_package, poline.order_format, phys.pol_mat_type_name, eresource.provider_org_name, ermat.pol_er_mat_type_name, poline.source, poline.requester, poline.po_line_description, poline.payment_status, inv.invoice_line_status, inv.total, it.payment_date, fit.transaction_fund_code, fit.transactions_expense_class_name
order by it.payment_date, acq.po_number