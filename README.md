# MT Corretora

## Installing Dependencies
Just run:
```bash
$ sudo pip3 install -r requirements
```

## Setting the database
In your *PostgresSQL*:
- Create a database called *mt_corretora*
- Create a user with `name='app'` e `password='fbd123'`
- Grant permission to select, insert, update and delete all table on database
- Execute the `db/structure_data.sql` in your newly created database

## Running
Just execute:
```bash
$ python3 main.py
```