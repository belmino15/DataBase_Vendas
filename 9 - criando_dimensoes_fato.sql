/*drop view if exists soma; 

create view soma as
select fknota_fiscal, sum(total) as sum_total FROM ITEM_NOTA group by fknota_fiscal;

select * from soma;*/

/*-- DIMENSÕES

CLIENTE
CATEGORIA
VENDEDOR
PRODUTO
FORNECEDOR
FORMA DE PAGAMENTO
*/

-- dim_cliente

select * from cliente;

select idcliente, concat(nome, ' ', sobrenome) as nome_completo, sexo, date(nascimento) as nascimento from cliente;

-- dim_vendedor

select * from vendedor;

select v1.idVENDEDOR, v1.nome,v1.email,v2.nome as gerente,v2.email as email_gerente from vendedor v1
left join vendedor v2
on v2.idvendedor = v1.idGERENTE;

-- dim_categoria

select * from categoria;

-- dim_produto

select * from produto;

select idproduto, produto, valor, custo_medio, c.nome as categoria, f.nome as fornecedor from produto p
left join categoria c on p.fkcategoria = c.idCATEGORIA
left join fornecedor f on p.fkFORNECEDOR = f.idFORNECEDOR;

-- dim_fornecedor

select * from fornecedor;

-- dim_forma_pagamento

select * from forma_pagamento;

/* FATO

IDCLIENTE
IDVENDEDOR
IDPRODUTO
IDFORNECEDOR
IDNOTA
IDFORMA
QUANTIDADE
TOTAL_ITEM
DATA
CUSTO_TOTAL
LUCRO_TOTAL
*/

-- Tabela Fato

select * from item_nota i
left join nota_fiscal n
on n.idNOTA_FISCAL = i.fkNOTA_FISCAL
left join produto p
on p.idPRODUTO = i.fkPRODUTO;











-- QUERY DAS NOTAS COM O VALOR TOTAL DAS NOTAS (SOMA DOS ITENS)

select idNOTA_FISCAL, data_venda, fkcliente, fkvendedor, fkFORMA_PAGAMENTO, Total_nota from nota_fiscal
left join (select fknota_fiscal, sum(total) as TOTAL_NOTA FROM ITEM_NOTA group by fknota_fiscal) soma
on idnota_fiscal = soma.fkNOTA_FISCAL;

select * from nota_fiscal;


