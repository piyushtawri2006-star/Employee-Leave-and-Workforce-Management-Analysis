import mysql.connector

try:
    conn = mysql.connector.connect(
        host="127.0.0.1",
        user="root",
        password="root",
        database="workforce_db"
    )

    print("DATABASE CONNECTION SUCCESSFUL!")

    conn.close()

except Exception as e:
    print("DATABASE CONNECTION FAILED!")
    print(e)