from .app import App
from .menu import MainMenu


class Main(App):

    def __init__(self):
        super(Main, self).__init__()

        options = ["Meus Dados", "Meus Ativos", "Renda Fixa", "Renda Variável"]
        actions = ['MyData()', 'MyAssets()', 'FixedIncome()', 'VariableIncome()']

        self.menu = MainMenu(options, actions)

        self.display_menu()
