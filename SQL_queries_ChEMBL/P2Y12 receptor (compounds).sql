SELECT
 c.molregno, 
 c.chebi_id, 
 act.standard_type, 
 act.standard_units, 
 act.relation,
 AVG(act.standard_value), MIN(act.standard_value), MAX(act.standard_value), 
 a.description, 
 d.journal, d.year, d.volume, d.issue, d.first_page, d.last_page, d.doc_id
FROM 
 target_dictionary td, assay2target a2t, assays a, activities act, molecule_dictionary c, docs d
WHERE 
 td.description = 'P2Y purinoceptor 12' AND
 td.organism = 'Homo sapiens' AND 
 a.assay_type = 'B' AND 
 act.standard_type = 'Ki' AND
 act.relation = '=' AND
 td.tid = a2t.tid AND
 a2t.assay_id = a.assay_id AND
 a.assay_id = act.assay_id AND
 a.doc_id = d.doc_id AND
 act.molregno = c.molregno AND NOT(act.standard_value IS NULL)
GROUP BY c.molregno, act.standard_units