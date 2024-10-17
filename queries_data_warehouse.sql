-- FIRST:
-- CRIAR BD (nortwind).
-- RESTORE DO BD.
-- TRUNCATE CASCADE NAS TABELAS DO SCHEMA data_warehouse (CRIAR AS TABELAS do data_warehouse).
-- INSERT INTO data_warehouse (bd producao [schema public] para data_warehouse).

--- 1º FAZER A MODELAGEM E CRIAÇÃO DAS TABELAS.
--- 2º ENTENDER SOBRE AS COLUNAS QUE VÃO NAS DIMENSÕES E FATO.
--- 3º CRIAR A DIM_TEMPO.
--- 4º CRIAR AS DIMENSÕES, SEMPRE ANTES DA FATO.

---DIM_TEMPO
--- PODE SER UM SCRIPT PADRÃO

INSERT INTO data_warehouse.dim_tempo(data, ano, mes, dia, dia_da_semana, mes_extenso)
SELECT 
	dt as data,
    EXTRACT(YEAR FROM dt) AS ano,
    EXTRACT(MONTH FROM dt) AS mes,
    EXTRACT(DAY FROM dt) AS dia,
    TO_CHAR(dt, 'Day') AS dia_da_semana,
    TO_CHAR(dt, 'Month') AS mes_extenso
FROM
    generate_series(CURRENT_DATE - INTERVAL '30 years', 
	CURRENT_DATE + INTERVAL '5 years', INTERVAL '1 day') AS dt;

SELECT * 
FROM data_warehouse.dim_tempo
ORDER BY id DESC;


--- Carregamento da Dimensão de Região

INSERT INTO data_warehouse.dim_regiao (pais, cidade, regiao)
SELECT DISTINCT 
pais_navio as pais, 
cidade_navio as cidade, 
regiao_navio as regiao
FROM pedidos;

SELECT * FROM data_warehouse.dim_regiao;
SELECT * FROM pedidos;


--- Carregamento da Dimensão de Produtos

INSERT INTO data_warehouse.dim_produto (nome, categoria)
SELECT DISTINCT  
pr.nome, 
c.nome as categoria
FROM produtos pr
INNER JOIN categorias c on c.id = pr.id_categoria;

SELECT * FROM data_warehouse.dim_produto;
SELECT * FROM produtos;


--- Carregamento da Fato

INSERT INTO data_warehouse.fato_vendas(id_tempo,id_produto,id_regiao, quantidade, venda)
SELECT
dt.id as id_tempo, --- dim_tempo
dp.id as id_produto, --- dim_produto
dr.id as id_regiao, --- dim_regiao
pd.quantidade, --- tabela de pedido detalhe
(pd.quantidade * pd.preco_unitario * (1 - pd.desconto))::numeric(18,2) as venda 
FROM pedidos p --- tabela de pedidos
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id
INNER JOIN produtos pr ON pr.id = pd.id_produto
INNER JOIN data_warehouse.dim_tempo dt ON dt.data = p.data_pedido
INNER JOIN data_warehouse.dim_produto dp ON dp.nome = pr.nome
INNER JOIN data_warehouse.dim_regiao dr ON dr.cidade = p.cidade_navio and dr.pais = p.pais_navio;


SELECT * FROM data_warehouse.fato_vendas;
SELECT * FROM produtos;

SELECT SUM(venda)::numeric(18,2) as total_venda
FROM data_warehouse.fato_vendas;


-- TABLES SCHEMA public (bd producao, ex.)
select * from public.categorias limit 5;
select * from public.clientes limit 5;
select * from public.empregado_territorios limit 5;
select * from public.fornecedores limit 5;
select * from public.funcionarios limit 5;
select * from public.pedido_detalhe limit 5;
select * from public.pedidos limit 5;
select * from public.produtos limit 5;
select * from public.regiao limit 5;
select * from public.territorios limit 5;
select * from public.transportadoras limit 5;
select * from public.us_estados limit 5;