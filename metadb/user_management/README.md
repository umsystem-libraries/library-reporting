# User Management .sql scripts for MetaDB

## loans_by_user_campus.sql
Lists:
- item barcode
- item permanent location
- user_ID (FOLIO UUID)
- user JSON data

For all open loans matching the campus FOLIO "custom field" value:  
	-- MST = "opt_0"  
	-- MU = "opt_1"  
	-- SHS = "opt_2"  
	-- UMKC = "opt_3"  
	-- UMSL = "opt_4"

## MU-Fines-Receivable-Data-ByLocation.sql
- Fines Receivable Report by Item Permanent Location
- Change opt_ value in "customFields" for the relevant campus. This is from the FOLIO Custom Fields configuration for "Campus"  
	-- MST = "opt_0"  
	-- MU = "opt_1"  
	-- SHS = "opt_2"  
	-- UMKC = "opt_3"  
	-- UMSL = "opt_4"
#### This script will:
compile from the loans_items derived table, the folio_users.users__ table (for the JSON containing campus affiliation), and
	the fees_fines.accounts__t__ table a list of, for users affiliated with a particular campus (per FOLIO data):
		- how many of that campus' patrons have items checked out
		- how many items are checked out (to patrons affiliated with that campus)
-		how many patrons (affiliated with that campus) have overdue items
-		how many overdue items (campus-affiliated patrons)
-		how many overdue items are overdue enough for a fine to be due (campus-affiliated patrons)
-		total sum of remaining fees/fines (campus-affiliated patrons)
-	grouped by 'current_item_permanent_location_name'

## MU-Fines-Receivable-Data-ByPatronGroup.sql
- Fines Receivable Report by Patron group
- Change opt_ value in "customFields" for the relevant campus. This is from the FOLIO Custom Fields configuration for "Campus"  
	-- MST = "opt_0"  
	-- MU = "opt_1"  
	-- SHS = "opt_2"  
	-- UMKC = "opt_3"  
	-- UMSL = "opt_4"
#### This script will:
compile from the loans_items derived table, the folio_users.users__ table (for the JSON containing campus affiliation), and
the fees_fines.accounts__t__ table a list of, for users affiliated with a particular campus (per FOLIO data):
-		how many of that campus' patrons have items checked out
-		how many items are checked out (to patrons affiliated with that campus)
-		how many patrons (affiliated with that campus) have overdue items
-		how many overdue items (campus-affiliated patrons)
-		how many overdue items are overdue enough for a fine to be due (campus-affiliated patrons)
-		total sum of remaining fees/fines (campus-affiliated patrons)
-	grouped by 'patron group' name.
