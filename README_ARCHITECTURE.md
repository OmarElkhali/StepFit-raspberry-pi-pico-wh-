# 🚶 Flutter Steps Tracker - Architecture IoT Complète

## 📋 Vue d'ensemble

Application Flutter connectée à un Raspberry Pi Pico W pour le suivi en temps réel des pas et de la vitesse via capteur MPU6050.

## 🏗️ Architecture du Projet

```
Flutter-Steps-Tracker/
├── lib/                                    # Code Flutter (Application mobile)
│   ├── core/
│   │   └── data/
│   │       └── services/
│   │           ├── pico_websocket_service.dart  # ✨ Service WebSocket pour Pico W
│   │           └── user_preferences_service.dart
│   ├── features/
│   │   ├── iot/
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │           └── improved_home_page.dart  # ✨ Page avec connexion au Pico W
│   │   └── intro/
│   │       └── presentation/
│   │           └── pages/
│   │               └── onboarding_form_page.dart
│   └── generated/
│       └── l10n.dart                       # Traductions (EN, FR, AR)
│
└── raspberry_pi_pico/                      # ✨ Code MicroPython (Matériel IoT)
    ├── README.md                           # Documentation du matériel
    ├── main.py                             # Programme principal
    ├── mpu6050.py                          # Pilote capteur MPU6050
    ├── step_detector.py                    # Algorithme de détection de pas
    └── simple_ws.py                        # Serveur WebSocket léger
```

## 🔌 Configuration Matérielle

### Raspberry Pi Pico W
- **Microcontrôleur** : RP2040 avec Wi-Fi intégré
- **Connexion** : WebSocket sur port 80
- **Adresse IP actuelle** : `192.168.3.51`

### Capteur MPU6050 (Accéléromètre + Gyroscope)
| Capteur | Pico W |
|---------|--------|
| VCC     | 3.3V   |
| GND     | GND    |
| SDA     | GPIO 0 |
| SCL     | GPIO 1 |

## 🌐 Communication WebSocket

### Connexion depuis l'application Flutter

```dart
final picoService = PicoWebSocketService();
await picoService.connect(); // Se connecte à ws://192.168.3.51:80/ws
```

### Format des données envoyées par le Pico W

```json
{
  "steps": 123,
  "speed": 1.4,
  "mode": "real"
}
```

- **steps** : Nombre total de pas détectés
- **speed** : Vitesse actuelle en m/s
- **mode** : `"real"` (capteur) ou `"demo"` (simulation)

### Fréquence
- Données envoyées **toutes les 0.5 secondes**
- Détection de pas en temps réel (délai anti-rebond: 300ms)

## 🚀 Installation et Démarrage

### 1. Configuration du Raspberry Pi Pico W

```bash
# Installer ampy pour uploader les fichiers
pip install adafruit-ampy

# Uploader tous les fichiers Python vers le Pico W
cd raspberry_pi_pico
ampy --port COM3 put main.py
ampy --port COM3 put mpu6050.py
ampy --port COM3 put step_detector.py
ampy --port COM3 put simple_ws.py

# Redémarrer le Pico W
ampy --port COM3 reset
```

### 2. Modifier les paramètres Wi-Fi

Éditez `raspberry_pi_pico/main.py` :

```python
SSID = "Wifi_4G"        # Votre réseau Wi-Fi
PASSWORD = "20044002"    # Votre mot de passe
```

Puis uploadez à nouveau :
```bash
ampy --port COM3 put raspberry_pi_pico/main.py main.py
ampy --port COM3 reset
```

### 3. Vérifier l'adresse IP du Pico W

```bash
# Ouvrir le moniteur série
$port = new-Object System.IO.Ports.SerialPort COM3,115200,None,8,one
$port.Open()
$port.ReadExisting()
$port.Close()
```

Vous verrez :
```
[INFO] Connected! IP: 192.168.3.51
[INFO] WebSocket Server: ws://192.168.3.51:80/ws
```

### 4. Configurer l'application Flutter

Si l'IP a changé, modifiez `lib/core/data/services/pico_websocket_service.dart` :

```dart
static const String DEFAULT_HOST = '192.168.3.51';  // Nouvelle IP ici
```

### 5. Lancer l'application

```bash
flutter pub get
flutter run
```

## 🎯 Fonctionnalités

### Application Flutter
- ✅ Connexion WebSocket au Raspberry Pi Pico W
- ✅ Affichage en temps réel des pas et de la vitesse
- ✅ Calcul automatique de la distance et des calories
- ✅ Interface multilingue (EN, FR, AR)
- ✅ Mode sombre adaptatif
- ✅ Profil utilisateur personnalisable
- ✅ Calculateur IMC et calories
- ✅ Historique des activités

### Raspberry Pi Pico W
- ✅ Lecture du capteur MPU6050 (I2C)
- ✅ Détection intelligente des pas (seuil adaptatif)
- ✅ Calcul de la vitesse en temps réel
- ✅ Serveur WebSocket multi-clients
- ✅ Mode démo automatique si capteur absent
- ✅ Reconnexion automatique au Wi-Fi

## 📊 Algorithme de Détection de Pas

### Principe
1. **Lecture de l'accéléromètre** : Calcul de la magnitude 3D
2. **Lissage** : Filtre passe-bas pour réduire le bruit
3. **Seuil dynamique** : S'adapte à l'amplitude des mouvements
4. **Anti-rebond** : Ignore les détections < 300ms
5. **Calcul de vitesse** : Basé sur les 5 derniers pas

### Paramètres ajustables

```python
StepDetector(
    step_length=0.7,      # Longueur de pas en mètres
    window=20,            # Fenêtre de lissage
    debounce_ms=300       # Délai anti-rebond
)
```

## 🐛 Dépannage

### Le Pico W ne se connecte pas au Wi-Fi
1. Vérifiez le SSID et le mot de passe
2. Assurez-vous que le Wi-Fi est 2.4 GHz (le Pico W ne supporte pas le 5 GHz)
3. Vérifiez la portée du signal

### L'application Flutter ne reçoit pas de données
1. Vérifiez l'IP du Pico W dans le moniteur série
2. Assurez-vous que le téléphone et le Pico W sont sur le même réseau
3. Vérifiez les logs : `flutter run -v`

### Le capteur MPU6050 ne fonctionne pas
Le système passe automatiquement en **mode démo** et simule des pas pour tester la connectivité.

Pour utiliser le capteur réel :
1. Vérifiez les connexions I2C (SDA, SCL)
2. Vérifiez l'alimentation 3.3V
3. Testez avec `i2c.scan()` dans le REPL MicroPython

### Erreur "OSError: [Errno 5] EIO"
Le capteur MPU6050 n'est pas détecté. Causes possibles :
- Câblage incorrect
- Capteur défectueux
- Mauvaise adresse I2C (par défaut: 0x68)

## 📱 Captures d'écran

L'application affiche :
- Vitesse actuelle en temps réel
- Compteur de pas avec progression
- Distance parcourue (km)
- Calories brûlées
- Graphique d'activité hebdomadaire

## 🔧 Technologies Utilisées

### Frontend (Flutter)
- **Flutter 3.1.0** : Framework UI multiplateforme
- **web_socket_channel** : Client WebSocket
- **Syncfusion Gauges** : Jauge de vitesse
- **FL Chart** : Graphiques
- **Provider & BLoC** : Gestion d'état

### Backend (Raspberry Pi Pico W)
- **MicroPython** : Langage de programmation
- **WebSocket** : Communication temps réel
- **I2C** : Communication avec MPU6050
- **Wi-Fi** : Connectivité réseau

## 📝 License

Ce projet est sous licence MIT.

## 👥 Contribution

Pour contribuer au projet :
1. Fork le repository
2. Créez une branche feature
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## 🆘 Support

Pour toute question ou problème :
- Consultez les issues GitHub
- Vérifiez la documentation du Pico W
- Consultez les logs série du Pico W

---

**Développé avec ❤️ pour l'IoT et la santé connectée**
