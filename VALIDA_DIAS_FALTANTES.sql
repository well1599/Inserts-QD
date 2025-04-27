-- GERA OS INSERTS DA REGRA VALIDA_DIAS_FALTANTES

select distinct UUID() AS job_id,
'VALIDA_DIAS_FALTANTES' REGRA_NOME,
'DD' TIPO_INTERVALO,
'1' INTERVALO,
c.tabelas TABELA,
'' COLUNA,
case when lower(periodicidade) = 'semanal' then 'SS,1,1,1'
  when lower(periodicidade) = 'diaria (dias uteis)' then 'DU,1,1,1'
  when lower(periodicidade) = 'mensal' then 'MM,1,1,1'
  when lower(periodicidade) = 'diaria (all days)' then 'DD,1,1,1'
  when lower(periodicidade) = 'quinsenal' then 'DD,15,1,1'
  when lower(periodicidade) = 'semestral' then 'MM,6,1,1'
  ELSE 'erro'
end VALORES_PARAMETROS,
string(current_date()) as dat_ref,
'0' as status_tabela,
'Hight|100-100' ORIGEM,
c. domínio as DOMINION,
---SUBIR DIRETO NA JOBS

concat("INSERT INTO bdq.jobs VALUES", "(","'", job_id, "'",",","'", regra_nome, "'",",","'", TIPO_INTERVALO,"'",",","'", INTERVALO,"'",",","'", TABELA,"'",",","'",
COLUNA,"'",",","'", VALORES_PARAMETROS, "'",",","'", dat_ref, "'",",", "'", status_tabela,"'",",","'", ORIGEM,"'",",","'", DOMINIO, "'",")",';') as inserts

----ou se for SUBIR PARA sqlScripptInThenBDQ --
--concat("INSERT INTO bdq.sqlScriptInTheBDQ (sqlScriptID, erro, SQL_script, status) VALUES", '("',job_id,'",',"'",""","INSERT INTO bdq.jobs VALUES ","(\"",
  --job_id, '\"',',', '\"', regra_nome, '\"',', ','\"', TIPO_INTERVALO, '\"',',','\"', INTERVALO, "',',','\"', TABELA, '\"',', ', '\"', COLUNA, '\"',',',"\"",
  --VALORES_PARAMETROS, '\"',',','\"', dat_ref, '\"',',','\"', status_tabela, '\"',',','"\"", ORIGEM, '\"',',','\"", DOMINIO, "\")'",',', '"not done"', ');') as inserts

from bdq.oxygen_datasets a
left join regraswell c
on concat(upper((a.systemName)),'.', UPPER((a.dataset_name))) = upper(c.tabelas)
where a.collectionnames <> ''
and upper(a.'PeriododeRetenção') not in (0,'', 'NAO INFORMADO', 'NÃO INFORMADO')
and c.ch_dias_fal = 0
--limit 10
