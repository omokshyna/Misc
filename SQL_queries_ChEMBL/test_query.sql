SELECT 
md.chembl_id as 'ID',
cr.compound_name as 'NAME',
cs.canonical_smiles as 'SMILES',
act.standard_type as 'TYPE', 
act.standard_relation as 'RELATION', 
case when act.standard_type='Ki' then act.standard_value end Ki,
case when act.standard_type='EC50' then act.standard_value end EC50,
case when act.standard_type='IC50' then act.standard_value end IC50,
case when act.standard_type='Efficacy' then act.standard_value end Efficacy,
case when act.standard_type='Potency' then act.standard_value end Potency,
if(a.description LIKE '%Antagonis%', 'Antagonism', if(a.description LIKE '%Agonis%', 'Agonism', 'NA')) as 'FUNCTION',
a.description as 'ASSAY_DESCRIPTION',
td.pref_name as 'TARGET_NAME',
td.organism as 'ORGANISM'

FROM 
target_dictionary td, 
assays a, 
activities act, 
molecule_dictionary md,
compound_records as cr,
compound_structures as cs

WHERE 
cs.molregno = md.molregno
AND
cr.molregno = md.molregno
AND
td.tid = a.tid 
AND 
a.assay_id = act.assay_id 
AND 
md.molregno = act.molregno 
AND 
act.standard_type IN ('IC50',  'Ki', 'EC50', 'logEC50', 'Potency', 'Efficacy') 
AND td.pref_name LIKE '%5-ht2a%'
AND td.organism = 'Homo sapiens'
AND act.standard_value IS NOT null

ORDER BY act.standard_type, act.standard_relation