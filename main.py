from src import Main, Login


def main():
    login = Login()

    cpf, pswd = login.info()
    user_id = login.auth(cpf, pswd)

    while user_id is None:
        print("\nLogin inválido\n")
        cpf, pswd = login.info()
        user_id = login.auth(cpf, pswd)

    main_app = Main()
    while True:
        main_app.display_menu()


if __name__ == "__main__":
    main()
