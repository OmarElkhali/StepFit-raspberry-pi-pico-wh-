"""
Test BLE - Nom court PICO
"""
import bluetooth
import time

print("\n=== TEST BLE - NOM COURT ===\n")

ble = bluetooth.BLE()
ble.active(True)
print("Bluetooth: ON")

# Nom TRES court
name = b"PICO"

# Payload minimal
payload = bytearray()
payload.append(0x02)  # Flags length
payload.append(0x01)  # Flags type
payload.append(0x06)  # Flags value

payload.append(len(name) + 1)  # Name length
payload.append(0x09)  # Name type
payload.extend(name)  # Name

print("Payload:", len(payload), "octets")
print("Hex:", payload.hex())
print("Nom:", name.decode())

ble.gap_advertise(100000, adv_data=payload)

print("\nDIFFUSION: 'PICO'")
print("Scan sur nRF Connect !\n")

while True:
    time.sleep(10)
    print("Toujours actif...")
