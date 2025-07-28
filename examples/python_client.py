import psycopg2

# if you disable ssl, but Cloud SQL enforces SSL,
# then you will get an error when connecting
try:
    conn = psycopg2.connect(
        host="35.203.59.36",        # UPDATE ME
        user="myuser",              # UPDATE ME 
        password="gfq#7x+r8Fl9",    # UPDATE ME
        dbname="mydb01",            # UPDATE ME
        connect_timeout=10,
        sslmode="require"           # DISABLE = "disable", ENABLE = "require" (why isn't it "enable"? LOL)
    )
    print("Connection established successfully!")
    conn.close()
except psycopg2.OperationalError as e:
    print(f"Connection failed: {e}")
