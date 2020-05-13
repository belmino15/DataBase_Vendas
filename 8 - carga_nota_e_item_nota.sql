use mybi;

/*-------------Procedure para preencher vendas de notas--------------*/
delimiter $$
DROP PROCEDURE IF EXISTS Gerar_Item_de_nota_e_nota;
CREATE PROCEDURE Gerar_Item_de_nota_e_nota(
  IN quantidade_notas INT,
  in num_de_itens_nota_final INT
)

BEGIN

/* Declarar Variáveis para Gerar Vendas Aleatórias de Produtos*/
  DECLARE codigo_item_da_nota INT;
  DECLARE notafiscal_atual INT;
  DECLARE vQUANTIDADE INT; -- v(ariavel) QUANTIDADE
  DECLARE num_de_itens_nota INT;
  DECLARE vfkPRODUTO INT;
  DECLARE vfkCLIENTE INT;
  DECLARE vfkVENDEDOR INT;
  DECLARE vfkFORMA_PAGAMENTO INT;
  DECLARE id_item_nota_atual INT;
  DECLARE notafiscal_inicial INT;
  
/* Declara variáveis para Gerar Datas das Compras*/
  DECLARE ano INT ;
  DECLARE mes INT ;
  DECLARE dia INT ;
  DECLARE hora INT ;
  DECLARE minuto INT ;
  DECLARE segundo INT ;
  DECLARE dia_hora DATETIME;

/*Loop para geração de produtos em uma  nota fiscal até a quantidade de notas passadas como parâmetro*/

  SET notafiscal_inicial = (SELECT idNOTA_FISCAL FROM mybi.NOTA_FISCAL ORDER BY idNOTA_FISCAL DESC LIMIT 1);
  IF notafiscal_inicial IS NULL THEN
	SET notafiscal_atual = 1;
	SET notafiscal_inicial = 0;
  ELSE
	SET notafiscal_atual = notafiscal_inicial + 1;
  END IF;

  WHILE notafiscal_atual <= quantidade_notas + notafiscal_inicial  DO

    /*Partes dos Dias Aleatórios*/
      SET ano = CONVERT(FLOOR(RAND()*6+2010),CHAR);
      SET mes = CONVERT(FLOOR(RAND()*12+1),CHAR);
      SET dia = CONVERT(FLOOR(RAND()*28+1),CHAR);
      SET hora = CONVERT(FLOOR(RAND()*24),CHAR);
      SET minuto = CONVERT(FLOOR(RAND()*60),CHAR);
      SET segundo = CONVERT(FLOOR(RAND()*60),CHAR);	 
      SET dia_hora = (SELECT(CONVERT(CONCAT(ano,'-',mes,'-',dia,' ',hora,':',minuto,':',segundo),DATETIME)));

      /*Resumo das Notas Fiscais*/
      SET vfkCLIENTE = (SELECT idCLIENTE FROM CLIENTE ORDER BY RAND() LIMIT 1);
      SET vfkVENDEDOR = (SELECT idVENDEDOR FROM VENDEDOR ORDER BY RAND() LIMIT 1);
      SET vfkFORMA_PAGAMENTO = (SELECT idFORMA_PAGAMENTO FROM FORMA_PAGAMENTO ORDER BY RAND() LIMIT 1);
      
      INSERT INTO NOTA_FISCAL(idNOTA_FISCAL,DATA_VENDA,fkCLIENTE,fkVENDEDOR,fkFORMA_PAGAMENTO)
      VALUES (
        notafiscal_atual, -- idNOTA_FISCAL
        dia_hora, -- DATA_VENDA
        vfkCLIENTE, -- fkCLIENTE
        vfkVENDEDOR, -- fkVENDEDOR
        vfkFORMA_PAGAMENTO -- fkFORMA_PAGAMENTO
      );

    /*Criando os itens das notas fiscais*/
      SET id_item_nota_atual = (SELECT idITEM_NOTA FROM mybi.item_nota ORDER BY idITEM_NOTA DESC LIMIT 1);
      IF id_item_nota_atual IS NULL THEN
      	SET num_de_itens_nota = 1;
        SET id_item_nota_atual = 0;
	  ELSE
        SET num_de_itens_nota = id_item_nota_atual + 1;
      END IF;
      WHILE num_de_itens_nota < id_item_nota_atual + num_de_itens_nota_final + 1 DO
          SET vQUANTIDADE = FLOOR(RAND()*9+1);
          SET vfkPRODUTO = (SELECT idPRODUTO FROM PRODUTO ORDER BY RAND() LIMIT 1);
          INSERT INTO ITEM_NOTA(idITEM_NOTA,QUANTIDADE,TOTAL,fkPRODUTO,fkNOTA_FISCAL)
          VALUES (
            num_de_itens_nota, -- idITEM_NOTA
            vQUANTIDADE, -- QUANTIDADE
            vQUANTIDADE * (SELECT VALOR FROM PRODUTO WHERE vfkPRODUTO = PRODUTO.idPRODUTO), -- TOTAL
            vfkPRODUTO,-- fkPRODUTO
            notafiscal_atual -- fkNOTA_FISCAL
          );
          SET num_de_itens_nota = num_de_itens_nota + 1;
      END WHILE;  

      SET notafiscal_atual = notafiscal_atual + 1;

  END WHILE;
END $$
delimiter ;

/*Chama a função*/

/* Teste
CALL Gerar_Item_de_nota_e_nota(10,1);
CALL Gerar_Item_de_nota_e_nota(10,2);
CALL Gerar_Item_de_nota_e_nota(10,3);
*/

CALL Gerar_Item_de_nota_e_nota(225,1);
CALL Gerar_Item_de_nota_e_nota(175,2);
CALL Gerar_Item_de_nota_e_nota(160,3);
CALL Gerar_Item_de_nota_e_nota(125,4);
CALL Gerar_Item_de_nota_e_nota(120,5); -- Gera 10 notas com 5 itens
CALL Gerar_Item_de_nota_e_nota(75,6);
CALL Gerar_Item_de_nota_e_nota(75,7);
CALL Gerar_Item_de_nota_e_nota(25,8);
CALL Gerar_Item_de_nota_e_nota(15,9);
CALL Gerar_Item_de_nota_e_nota(5,10);
