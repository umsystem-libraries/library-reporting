SELECT	
    acq.po_acquisition_unit_name as acq_unit, 
    poline.title_or_package as title,
    cast (po.date_ordered as DATE) as date_ordered,
    cast (cost.po_line_estimated_price as numeric) as estimated_price,
    poline.selector as selector,
    fundname.fund_name,
    phys.pol_mat_type_name as physical_mat_type,
    er.pol_er_mat_type_name as electronic_mat_type,
    vendor.organization_name as vendor,
    poline.po_line_number,
    cast (poline.receipt_date as date) as date_received
FROM folio_orders.po_line__t as poline
	left join folio_derived.po_acq_unit_ids as acq on poline.purchase_order_id = acq.po_id
	left join folio_orders.purchase_order__t as po on poline.purchase_order_id = po.id
	left join folio_derived.po_lines_cost as cost on poline.id = cost.pol_id
	left join folio_derived.po_lines_phys_mat_type as phys on poline.id = phys.pol_id
	left join folio_derived.po_lines_er_mat_type as er on poline.id = er.pol_id
	left join folio_derived.po_lines_fund_distribution_transactions as fund on poline.po_line_number = fund.poline_number
	left join folio_derived.finance_funds as fundname on fund.fund_code = fundname.fund_code
	left join folio_derived.po_organization as vendor on po.po_number = vendor.po_number
	where po.order_type = 'One-Time' and po.workflow_status = 'Open'and acq.po_acquisition_unit_name like 'VALUE'
GROUP BY
    acq.po_acquisition_unit_name,
    poline.title_or_package,
    po.date_ordered,
    cost.po_line_estimated_price,
    poline.selector,
    fundname.fund_name,
    phys.pol_mat_type_name,
    er.pol_er_mat_type_name,
    vendor.organization_name,
    poline.po_line_number,
    poline.receipt_date
ORDER BY
    acq_unit,
    fundname.fund_name,
    date_ordered
;