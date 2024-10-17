# Projeto Conectando Banco de Dados PostgreSQL no Microsoft Power BI

Desenvolvimento de Projeto de Banco de Dados com SQL/PostgreSQL.<br> 
`Aula 10, Módulo 01 (SQL).` 

Instituição: [Digital College Brasil](https://digitalcollege.com.br/) (Fortaleza/CE) <br>
Curso: Data Analytics (Turma 18) <br>
Instrutora: [Nayara Wakweski](https://github.com/NayaraWakewski) <br>

<br>

## Etapas de Desenvolvimento

<br>

## Restore do Banco de Dados
- Criar banco de dados: nortwind (Interface gráfica). <br>
![screenshot](/images/create_database.png) <br>

- Fazer "Restore" do banco de dados (Interface gráfica). <br>
![screenshot](/images/restore.png) <br>

<br>

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
dim_tempo (Tabela dimensão)
dim_produto (Tabela dimensão)
dim_regiao (Tabela dimensão)
fato_vendas (Tabela fato) 
Obs.: Modelagem e criação das tabelas/colunas do data_warehouse vieram desenvolvidas neste projeto.

<br>

## Inserir valores (insert into) nas tabelas do data_warehouse

- 1ª Tabela dimensão dim_tempo. Comandos SQL: <br>
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

<br>

- Tabela dimensão dim_produto. Comandos SQL: <br>
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

<br>



<br>

## Meus Contatos

- Business Card - [Renato Albuquerque](https://rma-contacts.vercel.app/)
- Linkedin - [renato-malbuquerque](https://www.linkedin.com/in/renato-malbuquerque/)
- Discord - [Renato Albuquerque#0025](https://discordapp.com/users/992621595547938837)