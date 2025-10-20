--Campus codes: 0 = MST, 1 = MU, 2 = SHS, 3 = UMKC, 4 = UMSL
SELECT 
	users.id,
	jsonb_extract_path_text(users.jsonb, 'active') AS "Status",
	jsonb_extract_path_text(users.jsonb, 'personal', 'lastName') AS "Last Name",
	jsonb_extract_path_text(users.jsonb, 'personal', 'firstName') AS "First Name",
	jsonb_extract_path_text(users.jsonb, 'username') AS "Username",
	jsonb_extract_path_text(users.jsonb, 'personal', 'email') AS "Email",
	jsonb_extract_path_text(spname.jsonb, 'name') as "Default Service Point",
	jsonb_extract_path_text(users.jsonb, 'customFields', 'campus_2') AS "Campus",
	jsonb_extract_path_text(users.jsonb, 'departments') AS "Department",
	groups.group_name AS "Patron Group",
	jsonb_extract_path_text(perms.jsonb, 'permissions') AS "Permissions"
FROM folio_permissions.permissions_users as perms
JOIN folio_users.users as users on jsonb_extract_path_text(perms.jsonb, 'userId') = cast(users.id as text)
join folio_derived.users_groups as groups on cast(jsonb_extract_path_text(perms.jsonb, 'userId') as uuid) = groups.user_id 
left join folio_inventory.service_point_user as sp on jsonb_extract_path_text(perms.jsonb, 'userId') = jsonb_extract_path_text(sp.jsonb, 'userId')
left join folio_inventory.service_point as spname on jsonb_extract_path_text(sp.jsonb, 'defaultServicePointId') = cast(spname.id as text)
where jsonb_extract_path_text(perms.jsonb, 'permissions') != '[]'