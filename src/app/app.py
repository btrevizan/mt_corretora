from ..db import Database


class App:

    def __init__(self):
        self.db = Database()
        self.menu = None

    def display_menu(self, cls=True):
        self.menu.display(cls)
