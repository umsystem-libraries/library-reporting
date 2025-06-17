# Collection Management .sql scripts for MetaDB

## ItemListByLocation.sql
- This script returns a detailed item list for items matching a list of Item Effective Location[s] AND Material Type[s]. Edit these lists in the WHERE clause.
- JOINs instance, holdings, locations, item, item_note, and contributors tables to assemble human-readable (resolving IDs to names, details, etc.) output.
- Originally developed to support identification of potential duplicates at UM Depository (specifically outputs chronology/enumeration/volume and contributors), but could be useful or have fields added for a variety of scenarios.

## ItemListByStatCode.sql
- Returns a list of items for a specific statistical code.
- **You need to replace VALUE with a valid statistical code in the WHERE clause.**

## ItemCountByCampus
- Developed to support ARL/ACRL statistics. Filtering on campus name and location, as well as a variety of properties of item/instance/holding type and formats.
- Contains multiple blocks for different needs in identifying monographs, serials, and media. Comment in and out the necessary 'where' blocks.
- Contains a commented 'select distinct' line at the top with an 'as instance_count'. What we've done here is commented those lines *out* to view the data returned and confirm that the materials in the result set appear to correctly match the criteria. The uncommenting the 'select distinct...as' lines returns the **distinct** instance_ids that can then be counted to arrive at the distinct title count. For example the result may return many items for a set of serials on one title, or multiple CDs in a two-volume set, etc., that are on the same instance.

## UMIProquestBrokenLinks.sql
- Script used to locate all items where the instance record has an "electronic access" field value matching an old URL pattern from UMI (microfilm predecessor to Proquest for theses and dissertations)
- Retrieve enough bibliographic metadata to locate the ETD in PQDT and get the new permalink, along with enough information (instance ID) to locate each record for correction

## InHouseUseByBarcode.sql
- if you have a comma-separated list of barcode strings, you can paste it in the WHERE...in(<list goes here>) to determine in-house uses for those specific items.
- In-house use determined by a check-in where the status_before_checkin is "Available" (e.g. it was on the shelf, not checked out, not in transit, etc. etc.)

## InHouseUseByLibrary.sql
- if you want the list of everything tagged as an in-house use for a particular library, use this one.

## LoanCountByItem.sql
- List of loaned items matching a date filter and location_library_code filter to find out which items from that library have been loaned, and how many times

## WithdrawnItems.sql
- List of items with Withdrawn status.
- **Replace BEGIN and END with starting and ending dates, using yyyy-mm-dd format, to limit to withdrawn items where status was changed between start and end (remove this entirely for all withdrawn items).**
- **Replace VALUE in permanent location name to a valid location. NOTE: You can wildcard. Example: 'UMKC%' will retrieve items in locations starting with UMKC.**
