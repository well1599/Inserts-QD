-- GERA OS INSERTS DA REGRA CONTROLE_RETENÇÃO

select distinct UUID() AS job_id, 'CONTROLE_RETENCAO' REGRA_NOME,
'DD' TIPO_INTERVALO,
'1' INTERVALO,
c.tabelas TABELA,
'' COLUNA,
'PeriododeRetenção' VALORES_PARAMETROS,
string(current_date()) as dat_ref,
'0' as status_tabela,
'Medium|100-100' ORIGEM,
c. domínio as DOMINION,
---SUBIR DIRETO NA JOBS

concat("INSERT INTO bdq.jobs VALUES", "(","'", job_id, "'",",","'", regra_nome, "'",",","'", TIPO_INTERVALO,"'",",","'", INTERVALO,"'",",","'", TABELA,"'",",","'",
COLUNA,"'",",","'", VALORES_PARAMETROS, "'",",","'", dat_ref, "'",",", "'", status_tabela,"'",",","'", ORIGEM,"'",",","'", DOMINIO, "'",")",';') as inserts

----ou se for SUBIR PARA sqlScripptInThenBDQ --
--concat("INSERT INTO bdq.sqlScriptInTheBDQ (sqlScriptID, erro, SQL_script, status) VALUES", '("',job_id,'",',"'",""","INSERT INTO bdq.jobs VALUES ","(\"",
  --job_id, '\"',',', '\"', regra_nome, '\"',', ','\"', TIPO_INTERVALO, '\"',',','\"', INTERVALO, "',',','\"', TABELA, '\"',', ', '\"', COLUNA, '\"',',',"\"",
  --VALORES_PARAMETROS, '\"',',','\"', dat_ref, '\"',',','\"', status_tabela, '\"',',','"\"", ORIGEM, '\"',',','\"", DOMINIO, "\")'",',', '"not done"', ');') as inserts


