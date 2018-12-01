from src import Database


def main():
    print("A bunch of information...")
    db = Database()

    sql = input(">> ")
    while sql != 'exit':
        # Execute sql
        # Print results

        sql = input(">> ")


if __name__ == "__main__":
    main()
