import re

packetver_blocks = []

with open("../rathena/src/map/clif_packetdb.hpp", "r", errors="ignore") as f:
    text = f.read()

blocks = re.findall(r'#if PACKETVER >= (\d+)(.*?)#endif', text, re.S)

for version, block in blocks:
    packets = re.findall(r'HEADER_[A-Z0-9_]+', block)

    if packets:
        packetver_blocks.append((version, packets))

print("Packets introduzidos por PACKETVER:\n")

for version, packets in packetver_blocks:
    print(f"\nPACKETVER >= {version}")
    for p in packets:
        print(" ", p)