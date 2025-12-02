# Raspberry Pi Pico W - Code Source

Ce dossier contient le code MicroPython pour le Raspberry Pi Pico W.

## Configuration matérielle

- **Raspberry Pi Pico W** : Microcontrôleur avec Wi-Fi intégré
- **MPU6050** : Capteur accéléromètre/gyroscope (I2C)
  - SDA -> GPIO 0
  - SCL -> GPIO 1
  - VCC -> 3.3V
  - GND -> GND

## Configuration Wi-Fi

Modifiez les paramètres dans `main.py` :
```python
SSID = "Wifi_4G"
PASSWORD = "20044002"
```

## Installation sur le Pico W

1. Connectez le Pico W via USB
2. Installez les fichiers avec ampy :
```bash
ampy --port COM3 put main.py
ampy --port COM3 put mpu6050.py
ampy --port COM3 put step_detector.py
ampy --port COM3 put simple_ws.py
```

3. Redémarrez le Pico W :
```bash
ampy --port COM3 reset
```

## WebSocket API

Le Pico W expose un serveur WebSocket sur `ws://[IP_PICO]:80/ws`

### Format des messages envoyés :
```json
{
  "steps": 123,
  "speed": 1.4
}
```

- `steps` : Nombre total de pas détectés
- `speed` : Vitesse actuelle en m/s

### Fréquence d'envoi :
- Données envoyées toutes les 0.5 secondes aux clients connectés
