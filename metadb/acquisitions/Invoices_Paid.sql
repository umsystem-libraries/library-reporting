--Invoices Query (adapted from CU Boulder)
SELECT
acqu.po_acquisition_unit_name as "Acq Unit",
cast (i.invoice_date as date) as "Invoice Date",
org.name AS "Vendor",
i.vendor_invoice_no as "Vendor Invoice No.",
il.invoice_line_number as "Invoice Line",
il.total AS "Invoice Line Total",
il.invoice_line_status as "Invoice Line Status",
pol.po_line_number as "POL",
f.name as "Fund",
il.description AS "Order Name",
l.description AS "Ledger",
i.folio_invoice_no as "FOLIO Invoice No.",
cast (i.payment_date as date) as "Payment Date",
i.payment_method as "Payment Method",
t.transaction_type as "Transaction Type",
t.amount AS "Transaction Amount",
pol.receipt_status as "Receipt Status",
cast (pol.receipt_date as date) as "Receipt Date"
FROM folio_invoice.invoice_lines__t AS il
LEFT JOIN folio_invoice.invoices__t AS i ON i.id = il.invoice_id 
LEFT JOIN folio_finance.transaction__t AS t ON il.id = t.source_invoice_line_id 
LEFT JOIN folio_finance.fund__t AS f ON t.from_fund_id = f.id
LEFT JOIN folio_finance.ledger__t AS l ON f.ledger_id = l.id 
LEFT JOIN folio_orders.po_line__t AS pol ON il.po_line_id = pol.id
LEFT JOIN folio_orders.purchase_order__t AS po ON po.id = pol.purchase_order_id 
LEFT JOIN folio_derived.po_acq_unit_ids AS acqu ON po.id = acqu.po_id 
LEFT JOIN folio_organizations.organizations__t AS org ON po.vendor = org.id
WHERE ACQU.po_acquisition_unit_name like 'UMKC%'
order by acqu.po_acquisition_unit_name, i.invoice_date, i.vendor_invoice_no, il.invoice_line_number
;