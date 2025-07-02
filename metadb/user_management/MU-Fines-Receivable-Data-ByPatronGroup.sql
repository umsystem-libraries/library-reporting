-- Fines Receivable Report by Patron group
-- Change opt_ value in "customFields" for the relevant campus. This is from the FOLIO Custom Fields configuration for "Campus"
	-- MST = "opt_0"
	-- MU = "opt_1"
	-- SHS = "opt_2"
	-- UMKC = "opt_3"
	-- UMSL = "opt_4"
-- This script will:
--	compile from the loans_items derived table, the folio_users.users__ table (for the JSON containing campus affiliation), and
--	the fees_fines.accounts__t__ table a list of, for users affiliated with a particular campus (per FOLIO data):
--		how many of that campus' patrons have items checked out
--		how many items are checked out (to patrons affiliated with that campus)
--		how many patrons (affiliated with that campus) have overdue items
--		how many overdue items (campus-affiliated patrons)
--		how many overdue items are overdue enough for a fine to be due (campus-affiliated patrons)
--		total sum of remaining fees/fines (campus-affiliated patrons)
--	grouped by 'patron group' name.

with feesfines as (
select * from folio_feesfines.accounts__t__ as ffa
where ffa.__current = true
),
overdue_loans as (
select * from folio_derived.loans_items as fdli
	left join folio_users.users__ as u1 on fdli.user_id = u1.id
where fdli.loan_status = 'Open' and u1.jsonb @> '{"customFields":{"campus_2":["opt_1"]}}' and u1."__current" = true and fdli.loan_due_date < CURRENT_DATE
)
SELECT 
	li.patron_group_name,
	COUNT(distinct li.user_id) as "# of patrons w/items",
	COUNT(distinct li.item_id) as "# of checked out items",
	COUNT (distinct ol.user_id) as "# of patrons w/overdue",
	COUNT (distinct ol.item_id) as "# of overdue items",
	COUNT (distinct ff.item_id) as "# of overdue w/fine",
	SUM(ff.remaining) as "Sum of Fee/Fine (remaining)"
from folio_derived.loans_items AS li
	left join folio_users.users__ as u on li.user_id = u.id
	left join feesfines as ff on li.loan_id = ff.loan_id
	left join overdue_loans as ol on li.loan_id = ol.loan_id
where li.loan_status = 'Open' and u.jsonb @> '{"customFields":{"campus_2":["opt_1"]}}' and u."__current" = true
group by li.patron_group_name
