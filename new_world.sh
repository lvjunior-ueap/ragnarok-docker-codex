#!/bin/bash

set -e

SEED="$1"

if [ -z "$SEED" ]; then
    echo "Uso:"
    echo "  ./new_world.sh <seed>"
    exit 1
fi

echo "================================="
echo "Gerando novo mundo Ragnarok"
echo "Seed: $SEED"
echo "================================="

#################################
# parar servidor
#################################

echo
echo "Parando servidor..."

docker compose down || true

#################################
# limpar world atual
#################################

echo
echo "Limpando mundo atual..."

rm -rf data/db
rm -rf data/npc
rm -rf data/conf

#################################
# copiar base limpa
#################################

echo
echo "Copiando base limpa..."

cp -r data_base/db data/
cp -r data_base/npc data/
cp -r data_base/conf data/

#################################
# configurar seed
#################################

echo
echo "Configurando seed..."

sed -i "s/^WORLD_SEED=.*/WORLD_SEED=$SEED/" .env.rando

#################################
# randomizar mundo
#################################

echo
echo "Executando randomizer..."

bash scripts/randomize_world.sh

#################################
# subir servidor
#################################

echo
echo "Subindo servidor..."

docker compose up -d

echo
echo "================================="
echo "Mundo criado!"
echo "Seed: $SEED"
echo "================================="
