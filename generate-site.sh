#!/bin/bash

echo "================================="
echo "Gerando database web do Ragnarok"
echo "================================="

RATHENA=/usr/bin/rathena
WEBROOT=/var/www/html

cd $RATHENA || exit 1

echo "Aguardando map-server iniciar..."

# espera log aparecer
while [ ! -f log/map-server.log ]; do
    sleep 1
done

sleep 3

echo "Map-server detectado."

echo "Gerando database..."

python3 tools/webdb/generate.py

echo "Copiando arquivos para web..."

mkdir -p $WEBROOT

cp -r tools/webdb/output/* $WEBROOT/

echo "================================="
echo "Database web atualizada"
echo "================================="
