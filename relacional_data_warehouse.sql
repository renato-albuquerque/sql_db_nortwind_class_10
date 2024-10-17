-- AULA 10, 05/10 

-- Elaborar as consultas abaixo no relacional e no Data Warehouse.

-- 1. Total de venda

-- Relacional

-- Analisar a lógica de como calcular o total de vendas.

SELECT 
	SUM((pd.preco_unitario * pd.quantidade) * (1 - pd.desconto))::numeric(18,2) as total_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id

SELECT * FROM pedidos
SELECT * FROM pedido_detalhe

---Data Warehouse

SELECT SUM(venda)::numeric(18,2) as total_venda
FROM data_warehouse.fato_vendas 

SELECT * FROM data_warehouse.fato_vendas 

--2. Média de venda

---Relacional

SELECT AVG((pd.preco_unitario * pd.quantidade) * (1 - pd.desconto))::numeric(18,2) as media_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id

SELECT * FROM pedidos


---Data Warehouse

SELECT AVG(venda)::numeric(18,2) as media_venda
FROM data_warehouse.fato_vendas 

SELECT * FROM data_warehouse.fato_vendas 

--3. Maior venda

--- Relacional
--- o calculo se refere ao total da venda.

SELECT MAX((pd.preco_unitario * pd.quantidade) * (1 - pd.desconto))::numeric(18,2) as maior_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id


--- Data Warehouse

SELECT MAX(venda)::numeric(18,2) as maior_venda
FROM data_warehouse.fato_vendas 

--4. Menor venda

--- Relacional

SELECT MIN((pd.preco_unitario * pd.quantidade) * (1 - pd.desconto))::numeric(18,2) as menor_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id

--- Data Warehouse

SELECT MIN(venda)::numeric(18,2) as menor_venda
FROM data_warehouse.fato_vendas 


--5. Listar venda por ano
--- Vou particionar a minha data, utilizando o comando date_part
--- Uma operação para calcular o total das vendas (SUM).

--- Relacional

SELECT 
	date_part('Year', data_pedido) as ano, 
SUM((pd.quantidade * pd.preco_unitario * (1 - pd.desconto)))::numeric(18,2)  as total_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id
GROUP BY ano

SELECT * FROM pedidos

--- Data Warehouse

SELECT 
	ano, 
	SUM(venda) as total_venda
FROM data_warehouse.fato_vendas fv
INNER JOIN data_warehouse.dim_tempo dt ON dt.id = fv.id_tempo
GROUP BY ano

SELECT * FROM data_warehouse.dim_tempo
SELECT * FROM data_warehouse.fato_vendas

--6. Listar venda por categoria
--- Verificar onde tem a informação de categoria.
--- Calcular o meu total de venda.

--- Relacional

SELECT 
	c.nome as categoria,
	SUM((pd.preco_unitario * pd.quantidade)*(1 - pd.desconto))::numeric(18,2) as total_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id
INNER JOIN produtos pr ON pr.id  = pd.id_produto
INNER JOIN categorias c ON c.id = pr.id_categoria
GROUP BY c.nome
ORDER BY total_venda DESC


--- Data Warehouse

SELECT 
	dp.categoria, 
	SUM(venda) as total_venda
FROM data_warehouse.fato_vendas fv
INNER JOIN data_warehouse.dim_produto dp ON dp.id = fv.id_produto
GROUP BY dp.categoria
ORDER BY total_venda DESC

SELECT * FROM data_warehouse.dim_produto
SELECT * FROM data_warehouse.fato_vendas

--7. Listar venda por produto

--- Relacional

SELECT 
	pr.nome as produto,
	SUM((pd.preco_unitario * pd.quantidade)*(1 - pd.desconto))::numeric(18,2) as total_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id
INNER JOIN produtos pr ON pr.id  = pd.id_produto
GROUP BY pr.nome
ORDER BY total_venda DESC

SELECT * FROM produtos

--- Data Warehouse

SELECT 
	dp.nome, 
	SUM(venda) as total_venda
FROM data_warehouse.fato_vendas fv
INNER JOIN data_warehouse.dim_produto dp ON dp.id = fv.id_produto
GROUP BY dp.nome
ORDER BY total_venda DESC

SELECT * FROM data_warehouse.dim_produto
SELECT * FROM data_warehouse.fato_vendas


--8.Listar venda por país

--Relacional

SELECT 
	p.pais_navio as pais,
	SUM((pd.preco_unitario * pd.quantidade)*(1 - pd.desconto))::numeric(18,2) as total_venda
FROM pedidos p
INNER JOIN pedido_detalhe pd ON pd.id_pedido = p.id
GROUP BY p.pais_navio
ORDER BY total_venda DESC

SELECT * FROM pedidos


--Data Warehouse

SELECT 
	pais, 
	SUM(venda) as total_venda
FROM data_warehouse.fato_vendas fv
INNER JOIN data_warehouse.dim_regiao dr ON dr.id = fv.id_regiao
GROUP BY pais
ORDER BY total_venda DESC


SELECT * FROM data_warehouse.dim_regiao
SELECT * FROM data_warehouse.fato_vendas

SELECT COUNT(venda)::numeric(18,2) as menor_venda
FROM data_warehouse.fato_vendas 



https://www.microsoft.com/pt-br/microsoft-365/business
