-- a. No mínimo uma delas deve necessitar ser respondida com a cláusula group by
-- a2. O nome do trader e o rendimento médio de seus clientes.
SELECT t.nome, AVG(saldo - (SUM(deposito.quantidade) - SUM(saque.quantidade)))
FROM cliente
NATURAL JOIN trader as t
NATURAL JOIN conta_vinculada
JOIN movimentacao as deposito ON deposito.co_conta_vinculada = conta_vinculada.co_conta_vinculada AND deposito.tipo = 'D'
JOIN movimentacao as saque ON saque.co_conta_vinculada = conta_vinculada.co_conta_vinculada AND saque.tipo = 'S'
GROUP BY t.nome;

-- a3. O nome do trader e o total de remuneração por ano (salario + bonus). O salário de um trader é de 150 mil por ano.
SELECT P.nome Trader, 150000+SUM(valor) Remuneracao
FROM trader T 
INNER JOIN Pessoa P USING(cpf)
NATURAL JOIN rl_traderbonus
NATURAL JOIN bonus
GROUP BY P.nome
ORDER BY Remuneracao DESC;

-- a4. O nome do funcionário de suporte com mais atendimentos.

SELECT P.Nome, COUNT(*) Atendimentos
FROM Funcionario F
INNER JOIN Pessoa P USING(cpf)
INNER JOIN RL_Chat Ch USING(co_funcionario)
GROUP BY P.Nome, F.co_funcionario
ORDER BY Atendimentos DESC;
														   
														   
-- b. No mínimo duas delas deve necessitar ser respondida com subconsulta;
-- b2. O nome do cliente e o valor total em ativos do tipo título prefixado.
SELECT P.nome, prefix_comprados, prefix_vendidos 
FROM(	
	SELECT P.cpf, SUM( (OT.quantidade * OT.preco_unitario) ) Prefix_Comprados
	FROM Cliente C 
	INNER JOIN Pessoa P USING(cpf)
	INNER JOIN ordem_titulo OT USING(co_cliente)
	INNER JOIN titulo T USING(co_titulo)
	WHERE T.tipo = 'PreFixado' AND OT.compra = true
	GROUP BY P.cpf) PreFix_Comprados
LEFT JOIN (SELECT P.cpf, SUM( (OT.quantidade * OT.preco_unitario) ) Prefix_Vendidos
	FROM Cliente C 
	INNER JOIN Pessoa P USING(cpf)
	INNER JOIN ordem_titulo OT USING(co_cliente)
	INNER JOIN titulo T USING(co_titulo)
	WHERE T.tipo = 'PreFixado' AND OT.compra = false
	GROUP BY P.cpf) PreFix_Vendidos
	USING(cpf)
INNER JOIN Pessoa P USING(cpf)

-- c. No mínimo uma delas (diferente da consulta acima) deve necessitar do operador NOT EXISTS para responder questões
-- do tipo TODOS ou NENHUM que <referencia>
-- c1. O valor total da conta e nome dos clientes que investem apenas em ações do tipo ON.
-- c2. O nome dos traders que atendem clientes apenas com perfil agressivo.

-- f. Definir um procedimento armazenado que deve ser disparado ao atualizar uma tabela (inserção, atualização ou
-- remoção de tuplas). Você deve pesquisar a linguagem do SGBD escolhido para definir um procedimento, e programar
-- este procedimento nesta linguagem. Será considerada a utilidade do procedimento proposto. Procedimentos triviais não
-- serão valorizados.
-- f1. Quando uma movimentacão é criada, atualizar o saldo do cliente.
-- f2. Quando uma ordem é criada, atualizar o saldo do cliente.
-- f3. Quando o status de uma ordem é atualizado, atualizar o saldo do cliente.