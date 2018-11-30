import os


class Menu:

    def __init__(self, options, actions, title=""):
        self.options = options + ['Voltar']
        self.actions = actions + ['0']
        self.title = title

    @staticmethod
    def clear():
        os.system('clear')

    def display(self, cls=True):
        if cls:
            self.clear()

        if self.title:
            print("================== {} ==================".format(self.title))

        for i, label in enumerate(self.options):
            print("{} - {}".format(i, label))

        return self._handle()

    def _handle(self):
        op = input("Escolha uma opção e pressione Enter: ")

        try:
            op = int(op)
        except ValueError:
            return self._invalid_option()

        return eval(self.actions[op]) if op in range(len(self.actions)) else self._invalid_option()

    def _invalid_option(self):
        self.clear()
        print("\nOpção inválida.")
        self._handle()


class MainMenu(Menu):

    def __init__(self, options, actions):
        super(MainMenu, self).__init__(options, actions, "Menu")

        self.option = self.options[:-1] + ['Sair']
        self.actions = self.actions[:-1] + ['exit(0)']
