"""
Test Bluetooth BLE Simple - Raspberry Pi Pico WH
Ce script teste uniquement le Bluetooth pour vérifier qu'il fonctionne
"""

import bluetooth
import time
import struct
from micropython import const

# Configuration
_IRQ_CENTRAL_CONNECT = const(1)
_IRQ_CENTRAL_DISCONNECT = const(2)
_IRQ_GATTS_WRITE = const(3)

# UUID du service UART Nordic
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


class SimpleBLE:
    def __init__(self, name="PicoW-Test"):
        print("\n" + "="*50)
        print("TEST BLUETOOTH BLE - RASPBERRY PI PICO WH")
        print("="*50)
        
        self._name = name
        self._ble = bluetooth.BLE()
        self._connected = False
        self._conn_handle = None
        self._tx_handle = None
        self._rx_handle = None
        
        # 1. Activer le Bluetooth
        print("\n[1/5] Activation du Bluetooth...")
        try:
            self._ble.active(True)
            print("✓ Bluetooth activé")
        except Exception as e:
            print(f"✗ Erreur activation: {e}")
            return
        
        # 2. Enregistrer le callback
        print("\n[2/5] Enregistrement du callback...")
        try:
            self._ble.irq(self._irq)
            print("✓ Callback enregistré")
        except Exception as e:
            print(f"✗ Erreur callback: {e}")
            return
        
        # 3. Enregistrer le service UART
        print("\n[3/5] Enregistrement du service UART...")
        try:
            ((self._tx_handle, self._rx_handle),) = self._ble.gatts_register_services((_UART_SERVICE,))
            print(f"✓ Service UART enregistré")
            print(f"  - TX Handle: {self._tx_handle}")
            print(f"  - RX Handle: {self._rx_handle}")
        except Exception as e:
            print(f"✗ Erreur service: {e}")
            return
        
        # 4. Configurer l'advertising
        print("\n[4/5] Configuration de l'advertising...")
        try:
            self._advertise()
            print("✓ Advertising configuré")
        except Exception as e:
            print(f"✗ Erreur advertising: {e}")
            return
        
        print("\n[5/5] Démarrage de l'advertising...")
        print(f"✓ Le Pico WH diffuse maintenant sous le nom: '{self._name}'")
        print("\n" + "="*50)
        print("STATUT: PRÊT POUR CONNEXION")
        print("="*50)
        print("\nRecherchez cet appareil sur votre téléphone:")
        print(f"  📱 Nom: {self._name}")
        print(f"  🔵 Service UUID: 6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
        print("\n")
    
    def _irq(self, event, data):
        """Callback pour les événements BLE"""
        if event == _IRQ_CENTRAL_CONNECT:
            conn_handle, _, _ = data
            self._connected = True
            self._conn_handle = conn_handle
            print("\n🎉 CONNEXION ÉTABLIE!")
            print(f"   Handle: {conn_handle}")
            
        elif event == _IRQ_CENTRAL_DISCONNECT:
            conn_handle, _, _ = data
            self._connected = False
            self._conn_handle = None
            print("\n❌ DÉCONNECTÉ")
            print(f"   Handle: {conn_handle}")
            # Redémarrer l'advertising
            self._advertise()
            print("   Advertising redémarré")
            
        elif event == _IRQ_GATTS_WRITE:
            conn_handle, value_handle = data
            value = self._ble.gatts_read(value_handle)
            print(f"\n📨 Données reçues: {value}")
    
    def _advertise(self, interval_us=500000):
        """Configurer et démarrer l'advertising"""
        # Créer le payload d'advertising
        name = self._name.encode()
        payload = bytearray()
        
        # Flags
        payload.extend(struct.pack("BB", 2, 0x01))
        payload.append(0x06)  # General discoverable, BR/EDR not supported
        
        # Nom complet
        payload.extend(struct.pack("BB", len(name) + 1, 0x09))
        payload.extend(name)
        
        # UUID 128 bits du service UART
        payload.extend(struct.pack("BB", 17, 0x07))
        payload.extend(bytes.fromhex('9ECCA5024D0AE3A9F3A3B5016E400001'))
        
        self._ble.gap_advertise(interval_us, adv_data=payload)
    
    def send(self, data):
        """Envoyer des données via BLE"""
        if self._connected and self._conn_handle is not None:
            try:
                # Utiliser le vrai conn_handle, pas 0
                self._ble.gatts_notify(self._conn_handle, self._tx_handle, data.encode() if isinstance(data, str) else data)
                print("Envoye: ", data)
                return True
            except Exception as e:
                print("Erreur envoi: ", e)
                return False
        return False
    
    @property
    def is_connected(self):
        return self._connected


# ========== PROGRAMME PRINCIPAL ==========
def main():
    # Créer l'instance BLE
    ble = SimpleBLE(name="PicoW-Test")
    
    # Compteur pour envoyer des messages de test
    counter = 0
    
    print("\n⏳ En attente de connexion...")
    print("   (Le LED de votre Pico devrait clignoter si présent)")
    
    while True:
        try:
            # Afficher un point toutes les 2 secondes pour montrer que ça tourne
            if counter % 4 == 0:
                if ble.is_connected:
                    print(f"\n✓ Connecté - Envoi message #{counter // 4}")
                    message = f"Test #{counter // 4}\n"
                    ble.send(message.encode())
                else:
                    print(".", end="", flush=True)
            
            counter += 1
            time.sleep(0.5)
            
        except KeyboardInterrupt:
            print("\n\n🛑 Arrêt du test")
            break
        except Exception as e:
            print(f"\n❌ Erreur: {e}")
            time.sleep(1)


if __name__ == "__main__":
    main()
