from src import Database
import psycopg2


def main():
    print("A bunch of information...")
    db = Database()

    sql = input(">> ")
    while sql != 'exit':
        # Execute sql
        try:
            # Call execute
            pass
        except psycopg2.DatabaseError as e:
            print(e)
        else:
            # Print results
            pass

        sql = input(">> ")


if __name__ == "__main__":
    main()
