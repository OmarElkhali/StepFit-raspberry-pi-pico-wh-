"""
Raspberry Pi Pico W - Bluetooth BLE Pedometer
Envoie les données du capteur MPU6050 via Bluetooth Low Energy (BLE)
Utilise le service UART BLE pour la communication
"""

import bluetooth
import struct
import time
import math
from machine import Pin, I2C
from micropython import const
import json

from mpu6050 import MPU6050
from step_detector import StepDetector

# ---------- Configuration BLE UART ----------
_IRQ_CENTRAL_CONNECT = const(1)
_IRQ_CENTRAL_DISCONNECT = const(2)
_IRQ_GATTS_WRITE = const(3)

# UUID du service UART Nordic (standard)
_UART_UUID = bluetooth.UUID("6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
_UART_TX = (
    bluetooth.UUID("6E400003-B5A3-F393-E0A9-E50E24DCCA9E"),
    bluetooth.FLAG_READ | bluetooth.FLAG_NOTIFY,
)
_UART_RX = (
    bluetooth.UUID("6E400002-B5A3-F393-E0A9-E50E24DCCA9E"),
    bluetooth.FLAG_WRITE | bluetooth.FLAG_WRITE_NO_RESPONSE,
)
_UART_SERVICE = (
    _UART_UUID,
    (_UART_TX, _UART_RX),
)

# Configuration Advertising
_ADV_APPEARANCE_GENERIC_COMPUTER = const(128)
_ADV_TYPE_FLAGS = const(0x01)
_ADV_TYPE_NAME = const(0x09)
_ADV_TYPE_UUID16_COMPLETE = const(0x3)
_ADV_TYPE_UUID128_COMPLETE = const(0x7)
_ADV_TYPE_APPEARANCE = const(0x19)


class BLEPedometer:
    def __init__(self, name="PicoW-Steps"):
        self._ble = bluetooth.BLE()
        self._ble.active(True)
        self._ble.irq(self._irq)
        
        # Enregistrer le service UART
        ((self._handle_tx, self._handle_rx),) = self._ble.gatts_register_services((_UART_SERVICE,))
        
        self._connections = set()
        self._write_callback = None
        
        # Créer un payload minimal (comme test_ble_ultra_simple.py)
        # Flags + Nom seulement, pas de UUID pour garder <31 bytes
        payload = bytearray()
        payload.append(0x02)  # Longueur flags
        payload.append(0x01)  # Type: Flags
        payload.append(0x06)  # Flags: General Discoverable + BR/EDR not supported
        
        name_bytes = name.encode('utf-8')
        payload.append(len(name_bytes) + 1)  # Longueur nom
        payload.append(0x09)  # Type: Complete Local Name
        payload.extend(name_bytes)  # Nom
        
        self._payload = bytes(payload)
        
        self._advertise()
        
        print(f"[BLE] Dispositif '{name}' initialisé")
        print(f"[BLE] Payload: {len(self._payload)} octets")
        print("[BLE] Service UUID:", _UART_UUID)
        print("[BLE] En attente de connexion...")

    def _irq(self, event, data):
        # Gestion des événements BLE
        if event == _IRQ_CENTRAL_CONNECT:
            conn_handle, _, _ = data
            print(f"[BLE] Client connecté: {conn_handle}")
            self._connections.add(conn_handle)
            
        elif event == _IRQ_CENTRAL_DISCONNECT:
            conn_handle, _, _ = data
            print(f"[BLE] Client déconnecté: {conn_handle}")
            self._connections.remove(conn_handle)
            # Recommencer l'advertising
            self._advertise()
            
        elif event == _IRQ_GATTS_WRITE:
            conn_handle, value_handle = data
            value = self._ble.gatts_read(value_handle)
            if value_handle == self._handle_rx and self._write_callback:
                self._write_callback(value)

    def send(self, data):
        """Envoyer des données à tous les clients connectés"""
        for conn_handle in self._connections:
            try:
                # BLE MTU typique: 20 bytes par notification
                # Si données > 20 bytes, découper en chunks
                data_bytes = data.encode('utf-8') if isinstance(data, str) else data
                
                # Envoyer par chunks de 20 bytes
                chunk_size = 20
                for i in range(0, len(data_bytes), chunk_size):
                    chunk = data_bytes[i:i+chunk_size]
                    self._ble.gatts_notify(conn_handle, self._handle_tx, chunk)
                    time.sleep_ms(10)  # Petit délai entre chunks
                    
            except Exception as e:
                print(f"[BLE] Erreur envoi: {e}")

    def is_connected(self):
        """Vérifie si au moins un client est connecté"""
        return len(self._connections) > 0

    def _advertise(self, interval_us=500000):
        """Commencer l'advertising BLE"""
        print("[BLE] Advertising démarré...")
        self._ble.gap_advertise(interval_us, adv_data=self._payload)

    @staticmethod
    def _advertising_payload(name=None, services=None, appearance=0):
        """Créer le payload d'advertising"""
        payload = bytearray()

        def _append(adv_type, value):
            nonlocal payload
            payload += struct.pack("BB", len(value) + 1, adv_type) + value

        # Flags
        _append(_ADV_TYPE_FLAGS, struct.pack("B", 0x06))

        # Nom du dispositif
        if name:
            _append(_ADV_TYPE_NAME, name.encode())

        # Services
        if services:
            for uuid in services:
                b = bytes(uuid)
                if len(b) == 2:
                    _append(_ADV_TYPE_UUID16_COMPLETE, b)
                elif len(b) == 16:
                    _append(_ADV_TYPE_UUID128_COMPLETE, b)

        # Appearance
        if appearance:
            _append(_ADV_TYPE_APPEARANCE, struct.pack("<h", appearance))

        return payload


# ---------- Initialisation Capteurs ----------
print("[INFO] Initialisation des capteurs...")
i2c = I2C(0, scl=Pin(1), sda=Pin(0))
mpu = MPU6050(i2c)
step_detector = StepDetector(step_length=0.7)
print("[INFO] MPU6050 initialisé avec succès")

# ---------- Initialisation BLE ----------
ble_pedometer = BLEPedometer(name="PicoW-Steps")

# ---------- Boucle Principale ----------
print("[INFO] Démarrage de la boucle principale...")
counter = 0
temp_counter = 0
last_send_time = time.ticks_ms()
send_interval = 500  # Envoyer toutes les 500ms

temp = 0.0  # Température initiale

while True:
    try:
        # Lire les données du capteur MPU6050
        accel = mpu.get_accel_data()
        gyro = mpu.get_gyro_data()
        
        # Calculer la magnitude de l'accélération
        magnitude = math.sqrt(accel['x']**2 + accel['y']**2 + accel['z']**2)
        
        # Détecter les pas
        step_detector.update(magnitude)
        
        # Lire la température toutes les 5 secondes (100 itérations × 50ms)
        temp_counter += 1
        if temp_counter >= 100:
            temp = mpu.get_temp()
            temp_counter = 0
        
        # Calculer les métriques avec l'algorithme simple
        distance = step_detector.step_count * step_detector.step_length
        calories = step_detector.step_count * 0.04
        speed = step_detector.get_speed()
        cadence = 0.0
        activity_type = "Marche"
        
        # Envoyer les données via BLE toutes les 500ms
        current_time = time.ticks_ms()
        if time.ticks_diff(current_time, last_send_time) >= send_interval:
            if ble_pedometer.is_connected():
                # Créer le message JSON avec plus de détails
                message = json.dumps({
                    "steps": step_detector.step_count,
                    "speed": round(speed, 2),
                    "distance": round(distance, 2),
                    "calories": round(calories, 1),
                    "cadence": round(cadence, 1),
                    "activity": activity_type,
                    "temp": round(temp, 1),
                    "accel": {
                        "x": round(accel['x'], 2),
                        "y": round(accel['y'], 2),
                        "z": round(accel['z'], 2)
                    },
                    "gyro": {
                        "x": round(gyro['x'], 2),
                        "y": round(gyro['y'], 2),
                        "z": round(gyro['z'], 2)
                    }
                })
                
                # Ajouter délimiteur pour faciliter le parsing côté Flutter
                ble_pedometer.send(message + "\n")
                
                # Debug: afficher toutes les 10 secondes
                counter += 1
                if counter >= 20:  # 20 × 500ms = 10s
                    print(f"[DATA] Steps: {step_detector.step_count}, Speed: {speed:.2f} m/s, Temp: {temp:.1f}°C")
                    counter = 0
            
            last_send_time = current_time
        
        # Attendre 50ms avant la prochaine lecture
        time.sleep_ms(50)
        
    except KeyboardInterrupt:
        print("\n[INFO] Arrêt du programme")
        break
    except Exception as e:
        print(f"[ERROR] Exception: {e}")
        time.sleep(1)

print("[INFO] Programme terminé")
