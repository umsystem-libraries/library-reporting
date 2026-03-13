SELECT 
u.public_note as "856 Public Notes",
case
	when inst.discovery_suppress is true then 'Yes'
	when inst.discovery_suppress is false then 'No'
	else 'Unknown'
end as "Suppressed for Discovery",
COUNT(u.public_note) as "Records"
FROM folio_derived.instance_electronic_access AS u
join folio_derived.instance_ext as inst on u.instance_hrid = inst.instance_hrid
where u.public_note like ('%UMKC%')
group by u.public_note, inst.discovery_suppress
order by "Records" desc