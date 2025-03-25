import pyodbc
import os
import time

# Load environment variables
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

# Connection string (without SSL)
# This requires openssl-1.1.1p
conn_str = (
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={DB_HOST},{DB_PORT};"
    f"DATABASE={DB_NAME};"
    f"UID={DB_USER};"
    f"PWD={DB_PASSWORD};"
    # f"Encrypt=no;"  # Disable encryption
    # f"TrustServerCertificate=yes;" # Keep this for self-signed certs if needed, otherwise remove.
)

# Wait for SQL Server to be available
print(f"Waiting for SQL Server at {DB_HOST}:{DB_PORT}...")
time.sleep(5)

# Try connecting
try:
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    cursor.execute("SELECT GETDATE();")
    result = cursor.fetchone()
    print(f"Connected successfully! Server Date: {result[0]}")
    conn.close()
except Exception as e:
    print(f"Failed to connect: {e}")