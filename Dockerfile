FROM ubuntu:22.04

# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and ODBC driver
RUN apt update && apt install -y curl gnupg2 apt-transport-https software-properties-common wget build-essential && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    add-apt-repository "$(curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/prod.list)" && \
    apt update && \
    ACCEPT_EULA=Y apt install -y msodbcsql17 unixodbc unixodbc-dev && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Install Python and pip
RUN apt update && apt install -y python3 python3-pip && pip3 install --no-cache-dir pyodbc

RUN ln -s /usr/bin/python3 /usr/bin/python

# Upgrade OpenSSL
RUN wget https://www.openssl.org/source/openssl-1.1.1p.tar.gz -O openssl-1.1.1p.tar.gz && \
    tar -zxvf openssl-1.1.1p.tar.gz && \
    cd openssl-1.1.1p && \
    ./config && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    openssl version

# Install weasyprint dependencies
RUN apt-get update && apt-get install -y libcairo2 libgdk-pixbuf2.0-0 libpango-1.0-0 libpangoft2-1.0-0

# Set environment variables for ODBC
ENV ODBCINI=/etc/odbc.ini
ENV ODBCSYSINI=/etc

# Set working directory
WORKDIR /app

COPY ./db_connect.py /app

EXPOSE 8000 8085

CMD ["python3", "db_connect.py"]
