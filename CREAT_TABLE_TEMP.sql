-- CRIANDO A TABELA TEMPORARIA DAS REGRAS PARA SABER QUAL TABELA PRECISA DE REGRA PARA A CRIAÇÃO DOS INSERTS

CREATE OR REPLACE TEMP VIEW regraswell as (
select tabelas, sum(ch_con_retn) ch_con_retn, sum(ch_mon_sla) ch_mon_sla, sum(ch_dias_fal) ch_dias_fal,
sum((ch_con_retn)+(ch_mon_sla)+(ch_dias_fal)) as soma, DOMINIO from (
select distinct lower(concat(b.systemName,".",b.dataset_name)) as TABELAS,
case when upper(c.regra_nome) like ('%CONTROLE_RETENCAOX') and upper(c.origen) = 'ADLS' then 1 else 0 end as ch_con_retn,
case when upper(c.regra_nome) like ('%MONITORA_SLA%') and upper(c.origen) = 'ADLS' then 1 else 0 end as ch_mon_sla,
case when upper(c.regra_nome) like ('%VALIDA_DIAS_FALTANTES%') and upper(c.origen) = 'ADLS' then 1 else 0 end as ch_dias_fal,
case when upper(tabelas) like 'S_ODS%' then 'ODS'
when UPPER(tabelas) like 'S_OBKIN%' then 'OPEN FINANCE'
when UPPER(tabelas) like 'S_STBR_OFIN%' then 'OPEN FINANCE'
when UPPER(tabelas) like 'S_STBR_CAC%' then 'CUSTOMER 360'
when UPPER(tabelas) like '%360%' then 'CUSTOMER 360'
when UPPER(tabelas) like 'S_DCT%' then 'CARTOES'
when UPPER(tabelas) like 'S_STBR_DAS%' then 'ANTIFRAUDES & SEGURANCAS'
when UPPER(tabelas) like 'S_STBR_DAT%' then 'ASSETS'
when UPPER(tabelas) like 'S_STBR_DCF%' then 'CLIENTES PF'
when UPPER(tabelas) like 'S_STBR_DCH%' then 'CASH MANAGEMENT'
when UPPER(tabelas) like 'S_STBR_DCI%' then 'CANAL FISICO'
when UPPER(tabelas) like 'S_STBR_DCJ%' then 'CLIENTES PJ'
when UPPER(tabelas) like 'S_STBR_DCP%' then 'CAPITALIZACAO'
when UPPER(tabelas) like 'S_STBR_DCR%' then 'CANAL REMOTO'
when UPPER(tabelas) like 'S_STBR_DCX%' then 'CANAL EXTERNO'
when UPPER(tabelas) like 'S_STBR_DOT%' then 'AUDITORIA'
when UPPER(tabelas) like 'S_STBR_DEC%' then 'Câmbio, Derivatives e Energia'
when UPPER(tabelas) like 'S_STBR_DFM%' then 'FINANCEIRA'
when UPPER(tabelas) like 'S_STBR_DFS%' then 'FINANCAS'
when UPPER(tabelas) like 'S_STBR_DGF%' then 'GENERAÇÃO Comercial PF'
when UPPER(tabelas) like 'S STBR_DGP%' then 'GESTAD Comercial PJ'
when UPPER(tabelas) like 'S_STBR_DGT%' then 'GARANTIAS'
when UPPER(tabelas) like 'S_STBR_DHM%' then 'RECURSOS HUMANOS'
when UPPER(tabelas) like 'S_STBR_DIB%' then 'IMOBILIARIO'
when UPPER(tabelas) like 'S_STBR_DIG%' then 'IVESTIMENT BANKING'
when UPPER(tabelas) like 'S_STBR_DG%' then 'INVESTIMENTOS'
when UPPER(tabelas) like 'S_STBR_DGT%' then 'JURIDICO'
when UPPER(tabelas) like 'S_STBR_DGT%' then 'MARKETING'
when UPPER(tabelas) like 'S_STBR_DGT%' then 'CANAIS DIGITAIS'
when UPPER(tabelas) like 'S_STBR_DGT%' then 'CONSORCIO'
when UPPER(tabelas) like 'S_STBR_DGT%' then 'COMPRAR E CONTRATOS'
when UPPER(tabelas) like 'S_STBR_DPL%' then 'COMPLIANCE'
when UPPER(tabelas) like 'S_STBR_DPS%' then 'PROSPECTS'
when UPPER(tabelas) like 'S_STBR_DRI%' then 'RISCOS'
when UPPER(tabelas) like 'S_DRI_DRI%' then 'RISCOS'
when UPPER(tabelas) like 'S_STBR_DRM%' then 'CRM'
when UPPER(tabelas) like 'S_STBR_DRP%' then 'RECUPERACAO'
when UPPER(tabelas) like 'S_STBR_DSA%' then 'SEGUROS'
when UPPER(tabelas) like 'S_STBR_DSG%' then 'CONSIGUINADO'
when UPPER(tabelas) like 'S_STBR_DTG%' then 'TECNOLOGIA'
when UPPER(tabelas) like 'S_STBR_DTG%' then 'RELACOES INSTITUCIONAIS'
when lower(tabelas) like 'g_stbr_ofin%' then 'OPEN FINANCE'
when lower(tabelas) like 'h_stbr_dri_dri_pf%' then 'RISCOS'
when lower(tabelas) like 'h_stbr_dfs_dbnjfn%' then 'FINANÇAS'
when lower(tabelas) like 'h_stbr_dfs_db_nme%' then 'FINANÇAS'
when lower(tabelas) like 'gstbr_quod%' then 'BUREAU'
WHEN lower(tabelas) like 'h_stbr_dfs_%' then 'FINANCES'
WHEN lower(tabelas) like 'h_stbr_dri_cra%' then 'RISCOS'
WHEN lower(tabelas) like 's_stbr_ofout%' then 'OPEN FINANCE'
WHEN lower(tabelas) like 's_stbr_ofout%' then 'OPEN FINANCE'
end as DOMINIO
  
from prd.bdq.oxygen_datasets b
left join prd.bdq.jobs c
on lower(c.tabela) = lower(concat(b.systentiane, ".",b.dataset_name))
LEFT join prd.bdq.estrutura_colecao_dados_mkp_stakeholders_dataset a
on b.dataset_id = a.datasetid
  
where b.datasetPublishStatus 'Published'
and b.axonStatus = 'Active' and b.lifecycle = 'Approved'
and a.fl_categoria_colecao <> 'Source Systems'
and lower(b.systemName) not like 'b_%'
and lower(b.systemName) not like 'ds_%'
and lower(b.systemName) not like 'stmc%'
and lower(b.systemName) not like 'stmcs%'
and lower(b.systemName) not like 'dba%'
and lower(b.systemName) not like 'dbap%'
and lower(b.systemName) not like 'dbaproc%'
  
-- and lower(b.systemName) not like 's_ods%' ---- TIRANDO AS TABELAS DO ODS
-- and upper(b.systemName) not like 'S_STBR_DIN%' ---- TIRANDO AS TABELAS DO INVESTIMENTO
  
AND upper(b.systemName) not like 'S_STBR_DIG%'

--AND upper(b.systemName) like '%360%'
--AND B.dataset_refNumber in ('DS-15685', 'DS-19171', 'DS-19172', 'DS-19173', 'DS-32277', 'DS-34868', 'DS-34869', 'DS-34878', 'DS-35981', 'DS-35984', 'DS-35906", 'DS-35987', 'DS-35988')
--and DOMAIN like '%360%' ---- Filtrando tabelas por dominios
  
---OU FILTRAR PELO NOME DA TABELA.DATASET ----->>>>
--AND lower(concat(b.systemName,".",b.dataset_name)) IN ('s_stbr_ofout.bcb_metricas_dadc_analitica', "s_stbr_ofout.bcb_metricas_dadc_sintetica","s_stor_ofout.bcb_metricas_dadc_sintetica_interno")
)
group by tabelas, DOMINIO
order by tabelas)
