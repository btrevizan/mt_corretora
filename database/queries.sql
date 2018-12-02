-- a. No mínimo uma delas deve necessitar ser respondida com a cláusula group by
-- a1. O nome do trader e o valor médio de seus clientes.
SELECT pessoa.nome, AVG(saldo)
FROM trader
JOIN rl_tradercliente as tc ON tc.co_trader = trader.co_trader
JOIN cliente ON cliente.co_cliente = tc.co_cliente
JOIN pessoa ON trader.cpf = pessoa.cpf
GROUP BY pessoa.nome;

-- a2. O nome do trader e o total de remuneração por ano (salario + bonus). O salário de um trader é de 150 mil por ano.
SELECT P.nome Trader, 150000+SUM(valor) Remuneracao
FROM trader T 
INNER JOIN Pessoa P USING(cpf)
NATURAL JOIN rl_traderbonus
NATURAL JOIN bonus
GROUP BY P.nome
ORDER BY Remuneracao DESC;

-- a3. Um ranking com os 5 funcionarios com mais atendimentos ao cliente registrados
SELECT nome Funcionario, COUNT(*) Quantidade_de_atendimentos
FROM Funcionario F
INNER JOIN Pessoa P USING(cpf)
INNER JOIN RL_Chat Ch USING(co_funcionario)
GROUP BY P.nome, Ch.co_funcionario
ORDER BY Quantidade_de_atendimentos DESC
LIMIT 5;

-- b. No mínimo duas delas deve necessitar ser respondida com subconsulta;
-- b2. O nome do cliente e o valor total de investimentos e retornos em ativos do tipo título prefixado.
SELECT P.nome, valor_investido_em_prefixados, valor_recebido_em_prefixados 
FROM(	
	SELECT P.cpf, SUM( (OT.quantidade * OT.preco_unitario) ) valor_investido_em_prefixados
	FROM Cliente C 
	INNER JOIN Pessoa P USING(cpf)
	INNER JOIN ordem_titulo OT USING(co_cliente)
	INNER JOIN titulo T USING(co_titulo)
	WHERE T.tipo = 'PreFixado' AND OT.compra = true
	GROUP BY P.cpf) PreFix_Comprados
LEFT JOIN (SELECT P.cpf, SUM( (OT.quantidade * OT.preco_unitario) ) valor_recebido_em_prefixados
	FROM Cliente C 
	INNER JOIN Pessoa P USING(cpf)
	INNER JOIN ordem_titulo OT USING(co_cliente)
	INNER JOIN titulo T USING(co_titulo)
	WHERE T.tipo = 'PreFixado' AND OT.compra = false
	GROUP BY P.cpf) PreFix_Vendidos
	USING(cpf)
INNER JOIN Pessoa P USING(cpf);

-- c. No mínimo uma delas (diferente da consulta acima) deve necessitar do operador NOT EXISTS para responder questões
-- do tipo TODOS ou NENHUM que <referencia>
-- c1. O saldo e nome dos clientes que investem apenas em ações do tipo ON.
SELECT nome, saldo
FROM cliente NATURAL JOIN pessoa
WHERE co_cliente IN (SELECT co_cliente FROM ordem_acao NATURAL JOIN acao WHERE acao.nome LIKE '%ON%') AND
NOT EXISTS (SELECT * FROM ordem_titulo WHERE co_cliente = cliente.co_cliente);

-- c2. O nome dos traders que aconselham apenas clientes com perfil agressivo (e que ja aconselharam pelo menos um cliente).
SELECT P.nome Trader
FROM Trader T NATURAL JOIN Pessoa P
WHERE NOT EXISTS(SELECT *
				FROM RL_TraderCliente TC NATURAL JOIN Cliente C
				 WHERE C.perfil <> 'agressivo'
				 AND co_trader = T.co_trader
				)
AND T.co_trader IN(SELECT DISTINCT co_trader FROM RL_TraderCliente);
