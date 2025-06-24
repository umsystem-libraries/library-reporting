# MOBIUS Reports

MetaDB queries for MOBIUS (OpenRS) reports.

## MOBIUSBorrowingCount.sql
- Generates a count of MOBIUS item checkouts at a UM System libraries. The count is broken down by campus service point to accommodate branch library reporting needs.
- WHERE parameters: loan date, checkout service point name, item effective location name at check out (DCB = MOBIUS).
- **Replace START and END with the start and end loan dates you want to include, in yyyy-mm-dd format. End date is inclusive so use the date after the end date you want to include. Example: use '2024-08-01' if you want to count checkouts through 2024-07-31.**
- **Replace VALUE with the desired service point name. Use wildcarding to get all service points for a campus. Example 'UMKC%' will retrieve all service points starting with UMKC.**

## MOBIUSLendingCount.sql
-Generates a count of UM System items checked out at MOBIUS libraries. The count is broken down by campus service point to accommodate branch library reporting needs.
- WHERE parameters: loan date, current item permanent location library name, checkout service point name (DCB% includes all MOBIUS service points).
- **Replace START and END with the start and end loan dates you want to include, in yyyy-mm-dd format. End date is inclusive so use the date after the end date you want to include. Example: use '2024-08-01' if you want to count checkouts through 2024-07-31.**
- **Replace VALUE with the desired library name. Use wildcarding to get all libraries for a campus. Example 'UMKC%' will retrieve all service points starting with UMKC.**