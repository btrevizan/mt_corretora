from .app import App
from .menu import Menu
from getpass import getpass


class Login(App):

    def __init__(self):
        super(Login, self).__init__()

    def info(self):
        cpf = input("CPF (apenas números): ")
        password = getpass("Senha: ")

        return cpf, password

    def auth(self, cpf, password):
        results = self.db.fetch("SELECT * FROM users WHERE cpf = %s AND password = %s", (cpf, password))

        for user in results:
            return user[0]

        return None