#!/bin/bash

set -a
source .env.rando
set +a

echo "================================"
echo "Ragnarok World Randomizer"
echo "Seed: $WORLD_SEED"
echo "================================"

NUMERIC_SEED=$(python3 tools/world_seed.py "$WORLD_SEED")

export WORLD_SEED_NUMERIC=$NUMERIC_SEED

echo "Numeric seed: $WORLD_SEED_NUMERIC"

echo "Stopping server..."

docker exec ragnarok-server sh -c "cd /usr/bin/rathena && sh ./athena-start stop" || true

if [ "$ENABLE_RANDOM_DROPS" = true ]; then
    echo "Randomizing drops..."
    python3 tools/randomize_drops.py
fi

if [ "$ENABLE_RANDOM_STATS" = true ]; then
    echo "Randomizing stats..."
    python3 tools/randomize_stats.py
fi

if [ "$ENABLE_RANDOM_AI" = true ]; then
    echo "Randomizing AI..."
    python3 tools/randomize_ai.py
fi

if [ "$ENABLE_RANDOM_SHOPS" = true ]; then
    echo "Randomizing shops..."
    python3 tools/randomize_shops.py
fi

if [ "$ENABLE_RANDOM_SPAWNS" = true ]; then
    echo "Randomizing spawns..."
    python3 tools/randomize_spawns.py
fi

echo "World generation complete."
