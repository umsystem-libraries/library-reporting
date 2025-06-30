# MOBIUS Reports

MetaDB queries for MOBIUS (OpenRS) reports.

## MOBIUSBorrowingCount.sql
- Count of MOBIUS item checkouts at a UM System libraries. The count is broken down by campus service point to accommodate branch library reporting needs.
- WHERE parameters: loan date, checkout service point name, item effective location name at check out (DCB = MOBIUS).
- **Replace START and END with the start and end loan dates you want to include, in yyyy-mm-dd format. End date is inclusive so use the date after the end date you want to include. Example: use '2024-08-01' if you want to count checkouts through 2024-07-31.**
- **Replace VALUE with the desired service point name. Use wildcarding to get all service points for a campus. Example 'UMKC%' will retrieve all service points starting with UMKC.**

## MOBIUSBorrowingDetails.sql
- List of loans for MOBIUS items borrowed by UM System Libraries. Item info is generally lacking due to OpenRS functionality.
- Replace SELECT fields with * if you want to see all the available fields.
- replace WHERE parameters with your own, but keep l.item_effective_location_name_at_check_out = 'DCB' for MOBIUS.

## MOBIUSLendingCount.sql
- Generates a count of UM System items checked out at MOBIUS libraries. The count is broken down by campus service point to accommodate branch library reporting needs.
- WHERE parameters: loan date, current item permanent location library name, checkout service point name (DCB% includes all MOBIUS service points).
- **Replace START and END with the start and end loan dates you want to include, in yyyy-mm-dd format. End date is inclusive so use the date after the end date you want to include. Example: use '2024-08-01' if you want to count checkouts through 2024-07-31.**
- **Replace VALUE with the desired library name. Use wildcarding to get all libraries for a campus. Example 'UMKC%' will retrieve all service points starting with UMKC.**

## MOBIUSLendingDetails.sql
- List of loans with item details for UM System items loaned to MOBIUS libraries.
- Replace WHERE parameters with your own, but keep l.checkout_service_point_name like 'DCB%' for MOBIUS.