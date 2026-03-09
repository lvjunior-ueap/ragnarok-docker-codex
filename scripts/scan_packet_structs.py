import re

defined_packets = set()

with open("../rathena/src/map/packets_struct.hpp", "r") as f:
    text = f.read()

    packets = re.findall(r'PACKET_[A-Z0-9_]+', text)

    for p in packets:
        defined_packets.add(p)

print("Packets definidos em packets_struct.hpp:\n")

for p in sorted(defined_packets):
    print(p)