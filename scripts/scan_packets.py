import os
import re

used_packets = set()

for root, dirs, files in os.walk("../rathena/src"):
    for file in files:
        if file.endswith(".cpp") or file.endswith(".hpp"):
            path = os.path.join(root, file)

            with open(path, "r", errors="ignore") as f:
                text = f.read()

                packets = re.findall(r'PACKET_[A-Z0-9_]+', text)

                for p in packets:
                    used_packets.add(p)

print("Packets encontrados no código:\n")

for p in sorted(used_packets):
    print(p)