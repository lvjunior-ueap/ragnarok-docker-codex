import subprocess

used = subprocess.check_output(
    ["python", "scan_packets.py"],
    encoding="cp1252"
).split()

defined = subprocess.check_output(
    ["python", "scan_packet_structs.py"],
    encoding="cp1252"
).split()

used_set = set(used)
defined_set = set(defined)

missing = used_set - defined_set

print("\nPackets possivelmente incompatíveis:\n")

for p in sorted(missing):
    print(p)