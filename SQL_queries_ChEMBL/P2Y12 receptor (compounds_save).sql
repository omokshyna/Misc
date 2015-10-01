SELECT
 CONCAT(
  cs.molfile, '\n',
  ">  <chembl_id>", '\n', c.chembl_id, '\n', '\n',
  ">  <Ki average, nM>", '\n', AVG(act.standard_value), '\n', '\n',
  ">  <assay description>", '\n', a.description, '\n', '\n', 
  ">  <reference>", '\n', CONCAT(d.journal, " ", d.year, ", ", d.volume, " (", d.issue, ") p.", d.first_page, "-", d.last_page, " id=", d.doc_id), '\n', '\n',
  "$$$$"
 )
FROM 
 target_dictionary td, assay2target a2t, assays a, activities act, molecule_dictionary c, docs d, compound_structures cs
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
 act.molregno = c.molregno AND 
 cs.molregno = c.molregno AND
 NOT(act.standard_value IS NULL) AND
 c.molregno IN (
'582786',
'582714',
'582694',
'582660',
'582715',
'603033',
'561151',
'603034',
'582724',
'582777',
'568277',
'582743',
'579047',
'561137',
'555832',
'582776',
'582683',
'582789',
'582790',
'582684',
'566427',
'559303',
'582659',
'582801',
'557587',
'582738',
'568266',
'566383',
'566416',
'579022',
'579054',
'603023',
'579048',
'579021',
'603083',
'579057',
'578985',
'579053',
'579033',
'579049',
'603020',
'579052',
'579056',
'579059',
'603027',
'579042',
'578973',
'604268',
'603014',
'603029',
'578928',
'578929',
'578971',
'578976',
'578991',
'579009',
'603032',
'579004',
'579045',
'603800',
'603806',
'579028',
'603077',
'603610',
'603617',
'602933',
'603013',
'579002',
'579050',
'603008',
'603765',
'603773',
'579060',
'579001',
'603045',
'603074',
'603076',
'603084',
'603619',
'603771',
'604197',
'603767',
'603010',
'603618',
'578987',
'579039',
'579043',
'603079',
'603085',
'603763',
'578997',
'579026',
'603775',
'604025',
'604271',
'578939',
'579019',
'578998',
'603605',
'603768',
'603787',
'604021',
'604177',
'604183',
'578975',
'579046',
'603078',
'603760',
'603777',
'603793',
'578995',
'603026',
'603075',
'603803',
'604174',
'604184',
'604189',
'578983',
'579023',
'603609',
'604168',
'578934',
'579025',
'603016',
'603051',
'603783',
'604192',
'604264',
'578993',
'579005',
'579007',
'579024',
'603604',
'603759',
'579058',
'603009',
'603613',
'604194',
'603081',
'604091',
'604167',
'604270',
'579044',
'603069',
'604165',
'579051',
'579055',
'603784',
'604263',
'578989',
'603753',
'603757',
'603761',
'604272',
'602934',
'604262',
'603799',
'602932',
'603012',
'603030',
'604024',
'578979',
'603608',
'579027',
'603754',
'579037',
'603024',
'604193',
'578967',
'603041',
'603755',
'603756',
'603795',
'603802',
'604188',
'603611',
'578977',
'603031',
'603772',
'603046',
'603598',
'603774',
'579029',
'603068',
'603778',
'604170',
'603792',
'578972',
'603048',
'579031',
'603794',
'603797',
'603798',
'603807',
'604195',
'603060',
'603080',
'603764',
'603796',
'604089',
'578942',
'603607',
'603931',
'578992',
'603612',
'604185',
'604196',
'579006',
'603047',
'603053',
'603688',
'603025',
'603600',
'603776',
'604187',
'603601',
'603040',
'603052',
'603021',
'603035',
'603790',
'604169',
'578996',
'603521',
'603752',
'555819',
'603780',
'579032',
'603082',
'603062',
'579003',
'579030',
'603808',
'579000',
'603011',
'604179',
'603791',
'603805',
'603769',
'603022',
'604186',
'604554',
'603018',
'603524',
'579038',
'603039',
'604266',
'578986',
'579035',
'579041',
'603043',
'603692',
'604265',
'603042',
'603603',
'604190',
'604261',
'603691',
'603044',
'603522',
'604173',
'603602',
'603614',
'578981',
'579008',
'603751',
'603781',
'604022',
'603063',
'603782',
'579034',
'603055',
'603064',
'603689',
'603779',
'603801',
'604175',
'604180',
'579040',
'559245',
'562918',
'578935',
'578936',
'578974',
'578984',
'579018',
'579020',
'603015',
'603061',
'603616',
'603690',
'603758',
'603770',
'603788',
'604023',
'604182',
'604191',
'604475',
'555881',
'578927',
'578943',
'578999',
'579036',
'603017',
'603028',
'603054',
'603785',
'603804',
'603869',
'604267',
'603038',
'603067',
'604181',
'557534',
'568276',
'578994',
'603599',
'568275',
'557605',
'562930',
'578941',
'603036',
'603685',
'604092',
'604327',
'578938',
'603050',
'603057',
'578969',
'603065',
'604166',
'562919',
'564640',
'566442',
'603056',
'603347',
'603520',
'604163',
'578937',
'578980',
'603786',
'603789',
'604476',
'501788',
'603070',
'578968',
'578988',
'603049',
'603059',
'604171',
'604178',
'604269',
'559282',
'568274',
'603073',
'501650',
'603019',
'603606',
'557575',
'603066',
'603072',
'562827',
'578932',
'557535',
'603762',
'604260',
'564560',
'578990',
'582785',
'603037',
'578940',
'603058',
'603071',
'604474',
'566443',
'604328',
'564664',
'561092',
'578982',
'562908',
'578978',
'604090',
'564663',
'555890',
'578945',
'603523',
'604392',
'562838',
'603615',
'604259',
'603766',
'603868',
'603930',
'604326',
'561150',
'604258',
'559318',
'555880',
'501789',
'603437',
'604176',
'578930',
'603436',
'604395',
'501720',
'568230',
'604172',
'557544',
'559271',
'561149',
'603687',
'578970',
'578931',
'568217',
'604164',
'559319',
'561091',
'604020',
'603433',
'557604',
'604161',
'604553',
'559304',
'555820',
'561104',
'568265',
'604088',
'603346',
'578944',
'582668',
'603597',
'568246',
'561141',
'555859',
'559317',
'578933',
'564639',
'562882',
'604394',
'566391',
'566479',
'603748',
'561090',
'559288',
'603434',
'604162',
'603351',
'561082',
'562813',
'603865',
'555918',
'603749',
'566384',
'561043',
'603864',
'604393',
'555891',
'501721',
'603435',
'501651',
'501649',
'582693',
'561044',
'603867',
'603350',
'603438',
'501719',
'555790',
'603866',
'603929',
'603928',
'604477',
'564548',
'603926',
'438604',
'604555',
'501648',
'501458',
'582798',
'501459',
'564549',
'218035',
'582712',
'604399',
'501372',
'564691',
'603750',
'501647',
'582723',
'438641',
'501519',
'438642',
'438892',
'501373',
'501457',
'501790',
'501522',
'501521',
'501520',
'501371')
GROUP BY c.molregno, act.standard_units
into outfile "D:\\QSAR\\Anti-thrombotic\\P2Y12 - ADP\\CHEMBL09\\p2y12.sdf"