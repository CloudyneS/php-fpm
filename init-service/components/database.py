from .helpers import equals_false, equals_empty, colored

"""
Inputs:
    DB_CONNECTION_STRING: Connection string for connecting to database
    DB_CHECK_LOGIN: False, or username of user to check login for
    DB_CHECK_LOGIN_PASSWORD: Password of user to check login for
    DB_CHECK_LOGIN_ONFAIL: What to do if login check fails (FAIL/IGNORE)
    DB_CHECK_DATABASE_EXISTS: False, or name of database to check for
    DB_CHECK_DATABASE_EXISTS_ONFAIL: What to do if database check fails (FAIL/IGNORE/TRYCREATE)
    DB_CHECK_TABLES_EXIST: False, or comma-separated list of tables to check for
    DB_CHECK_TABLES_EXIST_ONFAIL: What to do if table check fails (FAIL/IGNORE/TRYCREATE/IMPORT)    
    DB_INSERT_TYPE: Where to get the insert file from (PATH/URL)
    DB_INSERT_FILE: The path/URL to the file to import
    DB_INSERT_FILE_ONFAIL: What to do if import fails (FAIL/IGNORE)

"""
class Database:
    def __init__(self, config):
        self.config = config
   
    def run(self):
        print(colored("HEADER", "Running Database initialization..."))

class MySQL(Database):
    pass

class Postgres(Database):
    pass

class SQLite(Database):
    pass

