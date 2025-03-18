FROM ubuntu:20.04

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and ODBC driver
RUN apt update && apt install -y curl gnupg2 apt-transport-https software-properties-common wget build-essential && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    add-apt-repository "$(curl -fsSL https://packages.microsoft.com/config/ubuntu/20.04/prod.list)" && \
    apt update && \
    ACCEPT_EULA=Y apt install -y msodbcsql17 unixodbc unixodbc-dev && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Install Python and pip
RUN apt update && apt install -y python3 python3-pip && pip3 install --no-cache-dir pyodbc

# Upgrade OpenSSL
RUN wget https://www.openssl.org/source/openssl-1.1.1p.tar.gz -O openssl-1.1.1p.tar.gz && \
    tar -zxvf openssl-1.1.1p.tar.gz && \
    cd openssl-1.1.1p && \
    ./config && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    openssl version

# Set environment variables for ODBC
ENV ODBCINI=/etc/odbc.ini
ENV ODBCSYSINI=/etc

# Set working directory
WORKDIR /app

# Copy SQL Server connection script
COPY db_connect.py db_connect.py

# Command to run the script
CMD ["python3", "db_connect.py"]