# 🚀 Guide de Déploiement Rapide - Bluetooth

## ✅ Étapes Complétées

1. ✓ Firmware Bluetooth créé (`main_bluetooth.py`)
2. ✓ Service Flutter créé (`pico_bluetooth_service.dart`)
3. ✓ Page de scan créée (`bluetooth_scan_page.dart`)
4. ✓ Dépendances ajoutées (`flutter_blue_plus`, `permission_handler`)
5. ✓ Permissions Android configurées

## 📦 Prochaines Étapes

### 1. Installer les Dépendances

```bash
flutter pub get
```

### 2. Déployer le Firmware Bluetooth sur Pico W

```powershell
# Copier le nouveau firmware
ampy --port COM3 put raspberry_pi_pico\main_bluetooth.py main.py

# Redémarrer le Pico W
$port = new-Object System.IO.Ports.SerialPort COM3,115200,None,8,one
$port.Open()
$port.Write([char]0x04)
Start-Sleep -Seconds 8
$output = $port.ReadExisting()
$port.Close()
Write-Output $output
```

### 3. Vérifier le Firmware

Vous devriez voir dans la sortie série:

```
MPY: soft reboot
[INFO] Initialisation des capteurs...
[INFO] MPU6050 initialisé avec succès
[BLE] Dispositif 'PicoW-Steps' initialisé
[BLE] Service UUID: 6E400001-B5A3-F393-E0A9-E50E24DCCA9E
[BLE] En attente de connexion...
[BLE] Advertising démarré...
[INFO] Démarrage de la boucle principale...
```

✅ Si vous voyez ce message, le firmware Bluetooth fonctionne !

### 4. Créer une Page de Test Simple

Créez `lib/test_bluetooth_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/data/services/pico_bluetooth_service.dart';
import 'features/iot/presentation/pages/bluetooth_scan_page.dart';

class TestBluetoothPage extends StatefulWidget {
  const TestBluetoothPage({Key? key}) : super(key: key);

  @override
  State<TestBluetoothPage> createState() => _TestBluetoothPageState();
}

class _TestBluetoothPageState extends State<TestBluetoothPage> {
  PicoBluetoothService? _bluetoothService;
  
  int _steps = 0;
  double _speed = 0.0;
  double _distance = 0.0;
  double _temp = 0.0;
  bool _isConnected = false;

  void _listenToData() {
    if (_bluetoothService == null) return;

    _bluetoothService!.stepsStream.listen((steps) {
      setState(() => _steps = steps);
    });

    _bluetoothService!.speedStream.listen((speed) {
      setState(() => _speed = speed);
    });

    _bluetoothService!.distanceStream.listen((distance) {
      setState(() => _distance = distance);
    });

    _bluetoothService!.temperatureStream.listen((temp) {
      setState(() => _temp = temp);
    });

    _bluetoothService!.connectionStream.listen((connected) {
      setState(() => _isConnected = connected);
    });
  }

  Future<void> _openScanner() async {
    final service = await Navigator.push<PicoBluetoothService>(
      context,
      MaterialPageRoute(builder: (context) => const BluetoothScanPage()),
    );

    if (service != null && service.isConnected) {
      setState(() => _bluetoothService = service);
      _listenToData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Connecté au Pico W !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Bluetooth'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              _isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
              color: _isConnected ? Colors.green : Colors.white,
            ),
            onPressed: _openScanner,
          ),
        ],
      ),
      body: Center(
        child: _isConnected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pas
                  _buildDataCard(
                    'Pas',
                    '$_steps',
                    Icons.directions_walk,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  
                  // Vitesse
                  _buildDataCard(
                    'Vitesse',
                    '${_speed.toStringAsFixed(2)} m/s',
                    Icons.speed,
                    Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  
                  // Distance
                  _buildDataCard(
                    'Distance',
                    '${(_distance / 1000).toStringAsFixed(2)} km',
                    Icons.straighten,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  
                  // Température
                  _buildDataCard(
                    'Température',
                    '${_temp.toStringAsFixed(1)}°C',
                    Icons.thermostat,
                    Colors.red,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bluetooth_disabled,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Non connecté',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openScanner,
                    icon: const Icon(Icons.search),
                    label: const Text('Scanner Bluetooth'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDataCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bluetoothService?.dispose();
    super.dispose();
  }
}
```

### 5. Modifier `main.dart` pour Tester

Dans `lib/main.dart`, modifiez temporairement le widget de démarrage:

```dart
import 'test_bluetooth_page.dart';

// Dans MaterialApp
home: const TestBluetoothPage(),  // Au lieu de LandingPage
```

### 6. Lancer l'Application

```bash
# Sur émulateur Android ou appareil physique
flutter run

# Ou sur Chrome pour tester l'UI (sans vraie connexion BLE)
flutter run -d chrome
```

## 🔍 Test Complet

### Étape par Étape

1. **Démarrer le Pico W** avec le firmware Bluetooth
2. **Lancer l'app Flutter** sur un appareil Android réel (BLE ne fonctionne pas sur émulateur)
3. **Cliquer sur l'icône Bluetooth** dans l'AppBar
4. **Cliquer sur "Scanner"** pour chercher le Pico W
5. **Attendre 5-10 secondes** - "PicoW-Steps" devrait apparaître
6. **Cliquer sur "Connecter"**
7. **Vérifier les données** - les pas/vitesse/distance/température devraient s'afficher

### Dépannage

#### Pico W n'apparaît pas

```powershell
# Vérifier le firmware
ampy --port COM3 ls

# Redéployer si besoin
ampy --port COM3 put raspberry_pi_pico\main_bluetooth.py main.py
```

#### Permissions refusées

- Activer la **Localisation** sur Android (requis pour BLE)
- Accepter les permissions dans l'app
- Vérifier dans Paramètres > Applications > Tracker > Permissions

#### Connexion échoue

- Se rapprocher du Pico W (< 5m pour test)
- Redémarrer le Pico W
- Redémarrer l'app Flutter

## 📱 Différences avec WebSocket

### Avant (WebSocket)
```dart
final service = PicoWebSocketService();
await service.connect('192.168.3.51');  // IP requise
```

### Maintenant (Bluetooth)
```dart
final service = PicoBluetoothService();
await service.connect();  // Scan automatique !
```

### Streams (IDENTIQUES)
```dart
service.stepsStream.listen((steps) { ... });
service.speedStream.listen((speed) { ... });
service.accelStream.listen((accel) { ... });
// etc.
```

## ✅ Résultat Attendu

Si tout fonctionne:

1. ✓ Pico W diffuse "PicoW-Steps" en Bluetooth
2. ✓ Flutter scanne et trouve le dispositif
3. ✓ Connexion établie en 2-3 secondes
4. ✓ Données affichées en temps réel (500ms)
5. ✓ Température mise à jour toutes les 5 secondes
6. ✓ Déconnexion propre quand on quitte l'app

## 🎯 Prochaines Étapes

Une fois le test réussi:

1. Adapter `improved_home_page.dart` pour utiliser Bluetooth
2. Adapter `sensor_monitor_page.dart` pour utiliser Bluetooth
3. Ajouter un bouton de connexion visible
4. Sauvegarder le dernier dispositif connecté
5. Reconnexion automatique au démarrage

---

**Commande rapide de test complet:**

```powershell
# 1. Déployer firmware
ampy --port COM3 put raspberry_pi_pico\main_bluetooth.py main.py

# 2. Redémarrer Pico W
$port = new-Object System.IO.Ports.SerialPort COM3,115200,None,8,one; $port.Open(); $port.Write([char]0x04); Start-Sleep 8; $port.ReadExisting(); $port.Close()

# 3. Installer dépendances
flutter pub get

# 4. Lancer app
flutter run
```

🎉 **Votre tracker de pas fonctionne maintenant sans Wi-Fi !**
