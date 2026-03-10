#!/bin/bash

set -e

echo "=== Configurando IPs do rAthena ==="

CONF_DIR="/datastoresetup/usr-bin-rathena/conf"

cd $CONF_DIR

echo "RO_IP=${RO_IP}"

# char-server → IP que o cliente usa
sed -i "s/^char_ip:.*/char_ip: ${RO_IP}/" char_athena.conf

# map-server → IP que o cliente usa
sed -i "s/^map_ip:.*/map_ip: ${RO_IP}/" map_athena.conf

# map-server → comunicação interna com char-server
sed -i "s/^char_ip:.*/char_ip: ragnarok-server/" map_athena.conf

# char-server → comunicação interna com login-server
sed -i "s/^login_ip:.*/login_ip: ragnarok-server/" char_athena.conf

# bind em todas interfaces (Docker)
sed -i "s/^bind_ip:.*/bind_ip: 0.0.0.0/" char_athena.conf || true
sed -i "s/^bind_ip:.*/bind_ip: 0.0.0.0/" map_athena.conf || true

echo "=== Configuração aplicada ==="

grep ip char_athena.conf
grep ip map_athena.conf

echo "=== Iniciando rAthena ==="

cd /

sh launch-athena.sh

echo "=== rAthena iniciado ==="

# manter container vivo mostrando logs
tail -f /datastore/usr-bin-rathena/log/map-server.log
