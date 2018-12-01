import psycopg2


class Database:

    def __init__(self):
        try:
            # Open connection
            self._conn = psycopg2.connect(host='localhost', database='mt_corretora', user='app', password='fbd123')

            # Create cursor
            self._cursor = self._conn.cursor()
        except psycopg2.DatabaseError:
            print("Database connection error. Please, check your database configuration.")
            exit(1)

    def execute(self, sql, *values):
        self._cursor.execute(sql, *values)
        self._conn.commit()
        return self._fetch_it()

    def _fetch_it(self):
        row = self._cursor.fetchone()

        while row:
            yield row
            row = self._cursor.fetchone()

    def __del__(self):
        try:
            self._cursor.close()  # close communication
            self._conn.close()    # close connection
        except (AttributeError, psycopg2.DatabaseError):
            pass