--metadb:function umkc_orders

-- Query to get open orders

DROP FUNCTION IF EXISTS umkc_orders;

CREATE FUNCTION umkc_orders(
)
RETURNS TABLE(
    acq_unit text,
    title text,
    date_ordered date,
    estimated_price bigint,
    selector text,
    fund text,
    physical_mat_type text,
    electronic_mat_type text,
    vendor text,
    po_line_number text,
    date_received date)
AS $$
SELECT 
acq.po_acquisition_unit_name as acq_unit, 
poline.title_or_package as title,
po.date_ordered as date_ordered,
cost.po_line_estimated_price as estimated_price,
poline.selector as selector,
fundname.fund_name as fund,
phys.pol_mat_type_name as physical_mat_type,
er.pol_er_mat_type_name as electronic_mat_type,
vendor.organization_name as vendor,
poline.po_line_number,
poline.receipt_date as date_received
from folio_orders.po_line__t as poline
	left join folio_derived.po_acq_unit_ids as acq on poline.purchase_order_id = acq.po_id
	left join folio_orders.purchase_order__t as po on poline.purchase_order_id = po.id
	left join folio_derived.po_lines_cost as cost on poline.id = cost.pol_id
	left join folio_derived.po_lines_phys_mat_type as phys on poline.id = phys.pol_id
	left join folio_derived.po_lines_er_mat_type as er on poline.id = er.pol_id
	left join folio_derived.po_lines_fund_distribution_transactions as fund on poline.po_line_number = fund.poline_number
	left join folio_derived.finance_funds as fundname on fund.fund_code = fundname.fund_code
	left join folio_derived.po_organization as vendor on po.po_number = vendor.po_number
	where po.order_type = 'One-Time' and po.workflow_status = 'Open' and acq.po_acquisition_unit_name like 'UMKC%'
group by
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
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
