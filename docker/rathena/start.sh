#!/bin/bash

echo "Configurando conexão com banco..."

mkdir -p /opt/rathena/conf/import

cat <<EOF > /opt/rathena/conf/import/inter_conf.txt
login_server_ip: db
login_server_port: 3306
login_server_id: ${MYSQL_USER}
login_server_pw: ${MYSQL_PASSWORD}
login_server_db: ${MYSQL_DATABASE}
EOF

echo "Aguardando MariaDB iniciar..."

until mysql -h db -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1"; do
  echo "MariaDB ainda não respondeu..."
  sleep 2
done


cd /opt/rathena

echo "Iniciando servidores rAthena..."

./login-server &
./char-server &
./map-server &

wait
