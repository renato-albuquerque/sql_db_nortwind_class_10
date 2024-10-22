# Projeto Conectando Banco de Dados PostgreSQL no Microsoft Power BI

Desenvolvimento de Projeto de Banco de Dados com SQL/PostgreSQL.<br> 
`Aula 10, Módulo 01 (SQL).` 

Instituição: [Digital College Brasil](https://digitalcollege.com.br/) (Fortaleza/CE) <br>
Curso: Data Analytics (Turma 18) <br>
Instrutora: [Nayara Wakweski](https://github.com/NayaraWakewski) <br>

## Etapas de Desenvolvimento

## Restore do Banco de Dados
- Criar banco de dados: nortwind (Interface gráfica). <br>
![screenshot](/images/create_database.png) <br>

- Fazer "Restore" do banco de dados (Interface gráfica). <br>
![screenshot](/images/restore.png) <br>

## Tabelas (12) SCHEMA public (Simulando um bd produção)
- Comandos SQL: <br>
```
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
```
<br>

## Tabelas (4) SCHEMA data_warehouse (Simulando um data_warehouse)
dim_tempo (Tabela dimensão) <br>
dim_produto (Tabela dimensão) <br>
dim_regiao (Tabela dimensão) <br>
fato_vendas (Tabela fato) <br>
Obs.: Modelagem e criação das tabelas/colunas do data_warehouse vieram desenvolvidas neste projeto.

<br>

## Inserir valores (insert into) nas tabelas do data_warehouse

### 1ª Carregar tabela dimensão dim_tempo. Comandos SQL: <br>
```
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
ORDER BY id DESC
limit 5;
```
<br>

- Visualização: <br>

![screenshot](/images/dim_tempo.png) <br>

### Carregar tabela dimensão dim_produto. Comandos SQL: <br>
```
INSERT INTO data_warehouse.dim_produto (nome, categoria)
SELECT DISTINCT  
pr.nome, 
c.nome as categoria
FROM produtos pr
INNER JOIN categorias c on c.id = pr.id_categoria;

SELECT * FROM data_warehouse.dim_produto
limit 5;
```
<br>

- Visualização: <br>

![screenshot](/images/dim_produto.png) <br>

### Carregar tabela dimensão dim_regiao. Comandos SQL: <br>
```
INSERT INTO data_warehouse.dim_regiao (pais, cidade, regiao)
SELECT DISTINCT 
pais_navio as pais, 
cidade_navio as cidade, 
regiao_navio as regiao
FROM pedidos;

SELECT * FROM data_warehouse.dim_regiao
limit 5;
```
<br>

- Visualização: <br>

![screenshot](/images/dim_regiao.png) <br>

### Carregar tabela FATO fato_vendas. Comandos SQL: <br>
```
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

SELECT * FROM data_warehouse.fato_vendas
limit 10;
```
<br>

- Visualização: <br>

![screenshot](/images/fato_vendas.png) <br>

## Meus Contatos

- Business Card - [Renato Albuquerque](https://rma-contacts.vercel.app/)
- Linkedin - [renato-malbuquerque](https://www.linkedin.com/in/renato-malbuquerque/)
- Discord - [Renato Albuquerque#0025](https://discordapp.com/users/992621595547938837)