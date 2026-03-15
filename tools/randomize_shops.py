#!/usr/bin/env python3

import os
import random
import re


def load_env():
    env={}
    with open(".env.rando") as f:
        for line in f:
            if "=" in line and not line.startswith("#"):
                k,v=line.strip().split("=",1)
                env[k]=v
    return env


env=load_env()

ROOT=env["RATHENA_ROOT"]
SHOP_FILE=f"{ROOT}/{env['SHOP_FILE']}"

ITEM_MIN=int(env.get("SHOP_ITEM_MIN",1101))
ITEM_MAX=int(env.get("SHOP_ITEM_MAX",2000))

seed=int(os.environ.get("WORLD_SEED_NUMERIC",0))
random.seed(seed)

print("Randomizing weapon shops...")

with open(SHOP_FILE) as f:
    data=f.read()

def repl(match):

    price=match.group(2)

    item=random.randint(ITEM_MIN,ITEM_MAX)

    return f"{item}:{price}"

data=re.sub(r"(\d+):(\d+)",repl,data)

with open(SHOP_FILE,"w") as f:
    f.write(data)

print("Shops randomized.")
