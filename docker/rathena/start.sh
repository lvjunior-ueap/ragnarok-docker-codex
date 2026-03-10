#!/bin/bash

echo "Configurando conexão com banco..."

mkdir -p /opt/rathena/conf/import

cat <<EOF > /opt/rathena/conf/import/inter_conf.txt
login_server_ip: ${RATHENA_DB_HOST}
login_server_port: ${RATHENA_DB_PORT}
login_server_id: ${RATHENA_DB_USER}
login_server_pw: ${RATHENA_DB_PASS}
login_server_db: ${RATHENA_DB_NAME}
EOF

echo "Aguardando MariaDB iniciar..."

sleep 10

cd /opt/rathena

echo "Iniciando servidores rAthena..."

./login-server &
./char-server &
./map-server &

wait