import psycopg2

host="35.203.59.36"         # UPDATE ME
user="myuser"               # UPDATE ME 
password="gfq#7x+r8Fl9"     # UPDATE ME
dbname="mydb01"             # UPDATE ME
sslmode="require"           # DISABLE = "disable", ENABLE = "require" (why isn't it "enable"? LOL)

# if you disable ssl, but Cloud SQL enforces SSL,
# then you will get an error when connecting
try:
    conn = psycopg2.connect(
        host=host,
        user=user,
        password=password,
        dbname=dbname,
        connect_timeout=10,
        sslmode=sslmode
    )
    print(f"Connection to '{dbname}' established successfully!")
    conn.close()
except psycopg2.OperationalError as e:
    print(f"Connection failed: {e}")
