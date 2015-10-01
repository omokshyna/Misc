SELECT
t.chembl_id AS target_chembl_id,   
t.pref_name AS target_name,   
t.target_type,
t.organism,     
cs.`component_synonym`,
activities.standard_type as standard_type

FROM 
activities,
target_dictionary t,   
target_type tt,   
target_components tc,   
`component_synonyms` cs

WHERE t.target_type = tt.target_type 
AND t.tid           = tc.tid  
AND cs.`component_synonym` LIKE '5-ht2a'
AND t.organism = 'Homo sapiens'
AND (activities.standard_type = 'Ki' OR 'EC50')

ORDER BY activities.standard_type