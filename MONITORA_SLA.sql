-- GERA OS INSERTS DA REGRA MONITORA_SLA

select distinct UUID() AS job_id,
'MONITORA_SLA' REGRA_NOME,
'DD' TIPO_INTERVALO,
'1' INTERVALO,
c.tabelas TABELA,
'' COLUNA,
case when lower(periodicidade) 'semanal' then concat('1,SS,', case when lower(SLO) in ('00:00') then '23' else left(SLO, 2) end,',N,N,1')
when lower(periodicidade) = 'diaria (dias uteis)' then concat('1,DD,', case when lower(SLO) in ('00:00') then '23' else left(SLO, 2) end, ',S,N,1')
when lower(periodicidade) = 'diaria (all days)' then concat('1,DD,', case when lower(SLO) in ('00:00') then '23' else left(SLO, 2) end,',N,N,1')
when lower(periodicidade) = 'mensal' then concat('1,MM,', case when lower(SLO) in ('', 'não informado', '00:00') then '23' else left(SLO, 2) end,',N,N,1') END
VALORES_PARAMETROS,
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
and c.ch_mon_sla = 0
--limit 10
