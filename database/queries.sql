-- a. No mínimo uma delas deve necessitar ser respondida com a cláusula group by
-- a2. O nome do trader e o valor médio de seus clientes.
SELECT pessoa.nome, AVG(saldo)
FROM trader
JOIN rl_tradercliente as tc ON tc.co_trader = trader.co_trader
JOIN cliente ON cliente.co_cliente = tc.co_cliente
JOIN pessoa ON trader.cpf = pessoa.cpf
GROUP BY pessoa.nome;

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
SELECT P.nome, SUM( (OT.quantidade * OT.preco_unitario) ) Valor
FROM Cliente C 
INNER JOIN Pessoa P USING(cpf)
INNER JOIN ordem_titulo OT USING(co_cliente)
INNER JOIN titulo T USING(co_titulo)
WHERE T.tipo = 'PreFixado'
GROUP BY P.cpf, P.nome;

-- c. No mínimo uma delas (diferente da consulta acima) deve necessitar do operador NOT EXISTS para responder questões
-- do tipo TODOS ou NENHUM que <referencia>
-- c1. O valor total da conta e nome dos clientes que investem apenas em ações do tipo ON.
-- c2. O nome dos traders que atendem clientes apenas com perfil agressivo.