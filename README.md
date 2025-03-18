docker build -t sql-connector .

docker run -e SQL_SERVER="your_server_address" \
           -e SQL_DATABASE="your_database_name" \
           -e SQL_USER="your_username" \
           -e SQL_PASSWORD="your_password" \
           sql-connector


Run Ubuntu: docker run --rm -it ubuntu:20.04 bash


Install ODBC 17 driver on Ubuntu 20.04
```bash 
apt update && apt install -y curl gnupg2 apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
apt-get install software-properties-common
apt update
add-apt-repository "$(curl -fsSL https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
apt update
ACCEPT_EULA=Y apt install -y msodbcsql17 unixodbc
```

check ODBC Version
odbcinst -q -d