#!/usr/bin/env python3

import os
import random


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
MOB_DB=env["MOB_DB_PATH"]

DB=f"{ROOT}/{MOB_DB}"

PASSIVE=int(env.get("AI_PASSIVE","0x01"),16)
AGGRESSIVE=int(env.get("AI_AGGRESSIVE","0x81"),16)

seed=int(os.environ.get("WORLD_SEED_NUMERIC",0))
random.seed(seed)

print("Randomizing monster AI...")

with open(DB) as f:
    lines=f.readlines()

new=[]

for line in lines:

    if line.startswith("//") or line.strip()=="":
        new.append(line)
        continue

    c=line.split(",")

    if random.random()<0.5:
        c[26]=str(PASSIVE)
    else:
        c[26]=str(AGGRESSIVE)

    new.append(",".join(c))

with open(DB,"w") as f:
    f.writelines(new)

print("AI randomized.")
