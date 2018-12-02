from src import Database
import psycopg2


def queries():
    sql1 = "SELECT pessoa.nome, AVG(saldo) FROM trader JOIN rl_tradercliente as tc ON tc.co_trader = trader.co_trader JOIN cliente ON cliente.co_cliente = tc.co_cliente JOIN pessoa ON trader.cpf = pessoa.cpf GROUP BY pessoa.nome;"
    sql2 = "SELECT P.nome Trader, 150000+SUM(valor) Remuneracao FROM trader T INNER JOIN Pessoa P USING(cpf) NATURAL JOIN rl_traderbonus NATURAL JOIN bonus GROUP BY P.nome ORDER BY Remuneracao DESC;"
    sql3 = "SELECT nome Funcionario, COUNT(*) Quantidade_de_atendimentos FROM Funcionario F INNER JOIN Pessoa P USING(cpf) INNER JOIN RL_Chat Ch USING(co_funcionario) GROUP BY P.nome, Ch.co_funcionario ORDER BY Quantidade_de_atendimentos DESC LIMIT 5;"
    sql4 = "SELECT P.nome, prefix_comprados, prefix_vendidos FROM(SELECT P.cpf, SUM( (OT.quantidade * OT.preco_unitario) ) Prefix_Comprados FROM Cliente C INNER JOIN Pessoa P USING(cpf) INNER JOIN ordem_titulo OT USING(co_cliente) INNER JOIN titulo T USING(co_titulo) WHERE T.tipo = 'PreFixado' AND OT.compra = true GROUP BY P.cpf) PreFix_Comprados LEFT JOIN (SELECT P.cpf, SUM( (OT.quantidade * OT.preco_unitario) ) Prefix_Vendidos FROM Cliente C INNER JOIN Pessoa P USING(cpf) INNER JOIN ordem_titulo OT USING(co_cliente) INNER JOIN titulo T USING(co_titulo) WHERE T.tipo = 'PreFixado' AND OT.compra = false GROUP BY P.cpf) PreFix_Vendidos USING(cpf) INNER JOIN Pessoa P USING(cpf);"
    sql5 = "SELECT nome, saldo FROM cliente NATURAL JOIN pessoa WHERE co_cliente IN (SELECT co_cliente FROM ordem_acao NATURAL JOIN acao WHERE acao.nome LIKE '%ON%') AND NOT EXISTS (SELECT * FROM ordem_titulo WHERE co_cliente = cliente.co_cliente);"
    sql6 = "SELECT P.nome Trader FROM Trader T NATURAL JOIN Pessoa P WHERE NOT EXISTS(SELECT * FROM RL_TraderCliente TC NATURAL JOIN Cliente C WHERE C.perfil <> 'agressivo' AND co_trader = T.co_trader) AND T.co_trader IN(SELECT DISTINCT co_trader FROM RL_TraderCliente)"

    return [sql1, sql2, sql3, sql4, sql5, sql6]


def main():
    print("MT Corretora (Database)")
    print("A qualquer momento, você pode pressinar as seguintes opções para executar os comandos pré-definidos:")
    print("1 - O nome do trader e o valor médio de seus clientes.")
    print("2 - O nome do trader e o total de remuneração por ano (salario + bonus). O salário de um trader é de 150 mil por ano.")
    print("3 - Um ranking com os 5 funcionarios com mais atendimentos ao cliente registrados")
    print("4 - O nome do cliente e o valor total em ativos comprador e vendidos do tipo título prefixado.")
    print("5 - O saldo e nome dos clientes que investem apenas em ações do tipo ON.")
    print("6 - O nome dos traders que aconselham apenas clientes com perfil agressivo e que ja aconselharam pelo menos um cliente.")
    print("Digite 'exit' para sair.")

    db = Database()
    predefined_queries = queries()
    input_string = "mt-corretora> "

    sql = input(input_string)
    while sql != 'exit':
        # Clear input
        if sql.isdigit():
            i = int(sql) - 1

            if i not in range(0, 6):
                print("Invalid option")
            else:
                sql = predefined_queries[i]
                print(sql)

        sql = sql.lower()

        # Execute sql
        results = []
        try:
            results = db.execute(sql)
        except psycopg2.DatabaseError as e:
            print(e)
        else:
            if sql.startswith("select"):
                for r in results:
                    print(r)
            else:
                print("Query executed successfully.")

        sql = input(input_string)


if __name__ == "__main__":
    main()
