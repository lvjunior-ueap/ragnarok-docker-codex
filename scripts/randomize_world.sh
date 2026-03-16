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

#################################
# RANDOMIZERS
#################################

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

#################################
# NEW FEATURES
#################################

if [ "$ENABLE_RANDOM_AFFIXES" = true ]; then
    echo "Randomizing equipment affixes..."
    python3 tools/randomize_affixes.py
fi

if [ "$ENABLE_ALLOW_ALL_DROPS" = true ]; then
    echo "Allowing all items to be dropped..."
    python3 tools/allow_all_drops.py
fi

if [ "$ENABLE_MAGNIFIER_LIGHTER" = true ]; then
    echo "Fixing Magnifier weight..."
    python3 tools/magnifier_zero_weight.py
fi

#################################
# MOB BUFFS
#################################

if [ "$ENABLE_RANDOM_MOB_BUFFS" = true ]; then
    echo "Generating mob buff skills..."
    python3 tools/generate_mob_buffs.py
fi

if [ "$ENABLE_RANDOM_MOB_NAMES" = true ]; then
    echo "Randomizing monster names..."
    python3 tools/randomize_mob_names.py
fi



echo "World generation complete."
