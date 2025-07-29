import pymysql
from pymysql import Error

host="127.0.0.1"        # UPDATE ME
user="myuser"           # UPDATE ME
passwd="Bxq9$1Rxn?&j"   # UPDATE ME
database="mydb01"       # UPDATE ME

try:
    connection = pymysql.connect(
        host=host,
        user=user,
        passwd=passwd,
        database=database,
        cursorclass=pymysql.cursors.DictCursor  # Use DictCursor to fetch rows as dictionaries
    )
    print(f"Connection to MySQL DB '{database}' successful!")
    connection.close()
except Error as e:
    print(f"Error connecting to MySQL DB: {e}")
