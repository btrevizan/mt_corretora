from src import Database
import psycopg2


def queries():
    sql1 = "SELECT pessoa.nome, AVG(saldo) FROM trader JOIN rl_tradercliente as tc ON tc.co_trader = trader.co_trader JOIN cliente ON cliente.co_cliente = tc.co_cliente JOIN pessoa ON trader.cpf = pessoa.cpf GROUP BY pessoa.nome;"
    sql2 = "SELECT P.nome Trader, 150000+SUM(valor) Remuneracao FROM trader T  INNER JOIN Pessoa P USING(cpf) NATURAL JOIN rl_traderbonus NATURAL JOIN bonus GROUP BY P.nome ORDER BY Remuneracao DESC;"
    sql3 = "SELECT P.Nome, COUNT(*) Atendimentos FROM Funcionario F INNER JOIN Pessoa P USING(cpf) INNER JOIN RL_Chat Ch USING(co_funcionario) GROUP BY P.Nome, F.co_funcionario ORDER BY Atendimentos DESC;"
    sql4 = ""
    sql5 = ""
    sql6 = ""

    return [sql1, sql2, sql3, sql4, sql5, sql6]


def main():
    print("MT Corretora (Database)")
    print("A qualquer momento, você pode pressinar as seguintes opções para executar os comandos pré-definidos:")
    print("1 - O nome do trader e o valor médio de seus clientes.")
    print("2 - O nome do trader e o total de remuneração por ano (salario + bonus). O salário de um trader é de 150 mil por ano.")
    print("3 - O nome do funcionário de suporte com mais atendimentos.")
    print("4 - ")
    print("5 - ")
    print("6 - ")
    print("Digite 'exit' para sair.")

    db = Database()
    predefined_queries = queries()
    input_string = "mt-corretora> "

    sql = input(input_string)
    while sql != 'exit':
        # Clear input
        if sql.isdigit():
            i = int(sql) - 1
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
