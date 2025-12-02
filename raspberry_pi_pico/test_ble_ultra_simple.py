"""
Test BLE Ultra Simple - JUSTE LE NOM
"""
import bluetooth
import time

print("\n=== BLUETOOTH BLE TEST ULTRA SIMPLE ===\n")

# Activer BLE
ble = bluetooth.BLE()
ble.active(True)
print("1. Bluetooth: ACTIF")

# Nom à diffuser
device_name = "PicoW-Steps"
name_bytes = device_name.encode()

# Créer advertising payload MINIMAL
# Format: Longueur | Type | Données
payload = bytearray()

# 1. Flags (obligatoire)
payload.append(0x02)  # Longueur: 2 octets
payload.append(0x01)  # Type: Flags
payload.append(0x06)  # Valeur: General Discoverable, BR/EDR not supported

# 2. Nom complet
payload.append(len(name_bytes) + 1)  # Longueur: taille du nom + 1
payload.append(0x09)  # Type: Complete Local Name
payload.extend(name_bytes)  # Le nom

print("2. Payload cree:")
print("   Longueur:", len(payload), "octets (max 31)")
print("   Hex:", payload.hex())
print("   Nom:", device_name)

# Vérifier la taille
if len(payload) > 31:
    print("\n   ERREUR: Payload trop long!")
else:
    print("   OK: Taille valide")

# Démarrer advertising avec intervalle de 100ms
print("\n3. Demarrage advertising...")
ble.gap_advertise(100000, adv_data=payload)  # 100ms = 100000 microsecond

print("\n=== DIFFUSION ACTIVE ===")
print("Nom diffuse:", device_name)
print("Cherchez sur nRF Connect !\n")

# Boucle pour garder le script actif
count = 0
try:
    while True:
        time.sleep(5)
        count += 5
        print(".", end="")
        if count % 30 == 0:
            print(f" {count}s")
except KeyboardInterrupt:
    print("\n\nArret.")
    ble.gap_advertise(None)  # Stop advertising
