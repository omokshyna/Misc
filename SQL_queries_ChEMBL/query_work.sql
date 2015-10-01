SELECT 
md.chembl_id as 'ID',
cr.compound_name as 'NAME',
cs.canonical_smiles as 'SMILES',
act.standard_type as 'TYPE', 
act.standard_relation as 'RELATION', 
if(act.standard_units = 'nM', 'M', act.standard_units) as 'UNITS',
if(act.standard_units = 'nM', act.standard_value/1000000000, act.standard_value) as 'VALUE',
if(act.standard_type IN ('Ki', 'EC50', 'IC50'), -log10(act.standard_value/1000000000), act.standard_value) as 'pVALUE',
if(a.description LIKE '%Antagonis%', 'Antagonism', if(a.description LIKE '%Agonis%', 'Agonism', 'NA')) as 'FUNCTION',
a.description as 'ASSAY_DESCRIPTION',
td.pref_name as 'TARGET_NAME',
td.organism as 'ORGANISM',
concat(ifnull(d.authors,''), ';', ifnull(d.title,''), ';', ifnull(d.journal,''), ',', ifnull(d.year,''), ',', 
ifnull(d.volume,''), ',', ifnull(d.first_page,''), '-', ifnull(d.last_page,'')) as 'REFERENCE'


FROM 
target_dictionary td, 
assays a, 
activities act, 
molecule_dictionary md,
compound_records as cr,
compound_structures as cs,
docs as d

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
d.doc_id = cr.doc_id
AND
act.standard_type IN ('IC50',  'Ki', 'EC50', 'logEC50', 'Potency', 'Efficacy') 
AND (td.pref_name LIKE '%5-ht2a%') 
AND td.organism = 'Homo sapiens'
AND act.standard_value IS NOT null

ORDER BY act.standard_type, act.standard_relation