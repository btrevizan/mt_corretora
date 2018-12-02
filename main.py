from src import Database
import psycopg2


def queries():
    sql1 = ""
    sql2 = ""
    sql3 = ""
    sql4 = ""
    sql5 = ""
    sql6 = ""

    return [sql1, sql2, sql3, sql4, sql5, sql6]


def main():
    print("MT Corretora (Database)")
    print("A qualquer momento, você pode pressinar as seguintes opções para executar os comandos pré-definidos:")
    print("1 - ")
    print("2 - ")
    print("3 - ")
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
            i = int(sql)
            sql = predefined_queries[i]

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
