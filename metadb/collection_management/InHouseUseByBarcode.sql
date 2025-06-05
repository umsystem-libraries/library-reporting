SELECT *
FROM folio_derived.item_ext AS ie
	LEFT JOIN folio_circulation.check_in__t__ AS ci ON ie.item_id = ci.item_id 
WHERE ci.item_status_prior_to_check_in = 'Available'
	and ie.barcode in(
'010-002061645',
'010-007368145',
'010-101810328',
'010-103811859',
'010-501349365',
'010-501858448',
'010-505407971'
	)
