"""
Test Bluetooth BLE Minimal - Ne fait QUE diffuser le nom
"""

import bluetooth
import time
import struct

# UUID du service UART
_UART_UUID = bluetooth.UUID("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
_UART_TX = (
    bluetooth.UUID("6E400003-B5A3-F393-E0A9-E50E24DCCA9E"),
    bluetooth.FLAG_READ | bluetooth.FLAG_NOTIFY,
)
_UART_RX = (
    bluetooth.UUID("6E400002-B5A3-F393-E0A9-E50E24DCCA9E"),
    bluetooth.FLAG_WRITE,
)
_UART_SERVICE = (_UART_UUID, (_UART_TX, _UART_RX),)

print("\n" + "="*50)
print("BLUETOOTH BLE - DIFFUSION CONTINUE")
print("="*50)

# Activer BLE
ble = bluetooth.BLE()
ble.active(True)
print("Bluetooth: ON")

# Enregistrer service
((tx_handle, rx_handle),) = ble.gatts_register_services((_UART_SERVICE,))
print("Service UART: OK")
print("TX Handle:", tx_handle)
print("RX Handle:", rx_handle)

# Créer advertising payload
name = b"PicoW-Steps"  # NOM EXACT !
payload = bytearray()

# Flags
payload.append(2)  # Longueur
payload.append(0x01)  # Type: Flags
payload.append(0x06)  # General discoverable

# Nom
payload.append(len(name) + 1)
payload.append(0x09)  # Type: Complete Local Name
payload.extend(name)

# UUID 128-bit
payload.append(17)
payload.append(0x07)
payload.extend(bytes.fromhex('9ECCA5024D0AE3A9F3A3B5016E400001'))

print("\nPayload d'advertising:")
print(payload.hex())
print("\nNom diffuse:", name.decode())
print("UUID Service: 6E400001-B5A3-F393-E0A9-E50E24DCCA9E")

# Démarrer advertising
ble.gap_advertise(500000, adv_data=payload)

print("\n" + "="*50)
print("DIFFUSION ACTIVE")
print("Cherchez 'PicoW-Steps' sur votre telephone !")
print("="*50)

# Boucle infinie
counter = 0
while True:
    time.sleep(2)
    counter += 1
    if counter % 5 == 0:
        print("Toujours en diffusion... (", counter, "secondes)")
