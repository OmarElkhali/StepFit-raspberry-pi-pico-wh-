import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service Bluetooth pour communiquer avec le Raspberry Pi Pico W
/// Utilise le service UART Nordic standard
class PicoBluetoothService {
  // UUID du service UART Nordic (standard BLE UART)
  static final Guid _uartServiceUuid =
      Guid("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
  static final Guid _uartTxCharacteristicUuid =
      Guid("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");
  static final Guid _uartRxCharacteristicUuid =
      Guid("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");

  // Nom du dispositif Pico W
  static const String _deviceName = "PicoW-Steps";

  // Device et caractéristiques BLE
  BluetoothDevice? _device;
  BluetoothCharacteristic? _txCharacteristic;
  BluetoothCharacteristic? _rxCharacteristic;

  // StreamControllers pour les données
  final _stepsController = StreamController<int>.broadcast();
  final _speedController = StreamController<double>.broadcast();
  final _distanceController = StreamController<double>.broadcast();
  final _caloriesController = StreamController<double>.broadcast();
  final _temperatureController = StreamController<double>.broadcast();
  final _accelController = StreamController<Map<String, double>>.broadcast();
  final _gyroController = StreamController<Map<String, double>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  final _rawDataController = StreamController<Map<String, dynamic>>.broadcast();
  final _cadenceController = StreamController<double>.broadcast();
  final _activityController = StreamController<String>.broadcast();

  // Buffer pour les messages fragmentés
  String _messageBuffer = '';

  // Getters pour les streams
  Stream<int> get stepsStream => _stepsController.stream;
  Stream<double> get speedStream => _speedController.stream;
  Stream<double> get distanceStream => _distanceController.stream;
  Stream<double> get caloriesStream => _caloriesController.stream;
  Stream<double> get temperatureStream => _temperatureController.stream;
  Stream<Map<String, double>> get accelStream => _accelController.stream;
  Stream<Map<String, double>> get gyroStream => _gyroController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<Map<String, dynamic>> get rawDataStream => _rawDataController.stream;
  Stream<double> get cadenceStream => _cadenceController.stream;
  Stream<String> get activityStream => _activityController.stream;

  // État de connexion
  bool get isConnected => _device?.isConnected ?? false;

  /// Vérifier et demander les permissions Bluetooth
  Future<bool> checkPermissions() async {
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      return true;
    }

    // Demander les permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  /// Scanner les dispositifs BLE
  Stream<BluetoothDevice> scanForDevices(
      {Duration timeout = const Duration(seconds: 10),
      bool filterByName = false}) async* {
    // Vérifier si Bluetooth est disponible
    if (!await FlutterBluePlus.isSupported) {
      throw Exception('Bluetooth non supporté sur ce dispositif');
    }

    // Vérifier les permissions
    if (!await checkPermissions()) {
      throw Exception('Permissions Bluetooth refusées');
    }

    // Démarrer le scan
    await FlutterBluePlus.startScan(
      timeout: timeout,
      androidUsesFineLocation: true,
    );

    // Stream des résultats de scan
    await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
      for (ScanResult result in results) {
        // Récupérer le nom depuis platformName OU advertisementData
        String deviceName = result.device.platformName;
        if (deviceName.isEmpty && result.advertisementData.advName.isNotEmpty) {
          deviceName = result.advertisementData.advName;
        }

        // Afficher TOUS les appareils ou filtrer par nom
        if (!filterByName ||
            deviceName.toLowerCase().contains('pico') ||
            deviceName == _deviceName) {
          print(
              '[BLE] Trouvé: $deviceName (${result.device.remoteId}) - RSSI: ${result.rssi}');
          yield result.device;
        }
      }
    }

    // Arrêter le scan
    await FlutterBluePlus.stopScan();
  }

  /// Se connecter au Pico W par nom ou adresse
  Future<bool> connect({BluetoothDevice? device}) async {
    try {
      // Si un dispositif est déjà fourni, l'utiliser
      if (device != null) {
        _device = device;
      }

      // Sinon, scanner pour le trouver
      if (_device == null) {
        await for (BluetoothDevice foundDevice in scanForDevices()) {
          _device = foundDevice;
          break; // Prendre le premier trouvé
        }
      }

      if (_device == null) {
        throw Exception('Dispositif PicoW-Steps non trouvé');
      }

      print('[BLE] Connexion à ${_device!.platformName}...');

      // Se connecter au dispositif
      await _device!.connect(timeout: const Duration(seconds: 15));

      // Découvrir les services
      List<BluetoothService> services = await _device!.discoverServices();

      // Trouver le service UART
      BluetoothService? uartService;
      for (var service in services) {
        if (service.uuid == _uartServiceUuid) {
          uartService = service;
          break;
        }
      }

      if (uartService == null) {
        throw Exception('Service UART non trouvé');
      }

      // Trouver les caractéristiques TX et RX
      for (var characteristic in uartService.characteristics) {
        if (characteristic.uuid == _uartTxCharacteristicUuid) {
          _txCharacteristic = characteristic;
        } else if (characteristic.uuid == _uartRxCharacteristicUuid) {
          _rxCharacteristic = characteristic;
        }
      }

      if (_txCharacteristic == null) {
        throw Exception('Caractéristique TX non trouvée');
      }

      // S'abonner aux notifications TX (données du Pico W)
      await _txCharacteristic!.setNotifyValue(true);
      _txCharacteristic!.lastValueStream.listen(_onDataReceived);

      // Écouter les déconnexions
      _device!.connectionState.listen((state) {
        bool connected = state == BluetoothConnectionState.connected;
        _connectionController.add(connected);

        if (!connected) {
          print('[BLE] Déconnecté');
        }
      });

      _connectionController.add(true);
      print('[BLE] Connecté avec succès !');

      return true;
    } catch (e) {
      print('[BLE] Erreur de connexion: $e');
      _connectionController.add(false);
      return false;
    }
  }

  /// Réception des données BLE
  void _onDataReceived(List<int> data) {
    try {
      // Convertir les bytes en string
      String chunk = utf8.decode(data);
      print('[BLE] 📥 Reçu: "$chunk" (${data.length} bytes)');
      _messageBuffer += chunk;

      // Vérifier si on a un message complet (délimité par \n)
      if (_messageBuffer.contains('\n')) {
        List<String> messages = _messageBuffer.split('\n');

        // Le dernier élément peut être incomplet
        _messageBuffer = messages.last;

        // Traiter tous les messages complets
        for (int i = 0; i < messages.length - 1; i++) {
          String message = messages[i].trim();
          if (message.isNotEmpty) {
            print('[BLE] 📨 Message complet: "$message"');
            _parseMessage(message);
          }
        }
      }
    } catch (e) {
      print('[BLE] Erreur de réception: $e');
    }
  }

  /// Parser le message JSON
  void _parseMessage(String message) {
    try {
      print('[BLE] 🔍 Parsing: "$message"');
      final data = json.decode(message) as Map<String, dynamic>;

      // Émettre les données brutes
      _rawDataController.add(data);
      print('[BLE] ✅ Données parsées: $data');

      // Parser les champs individuels
      final steps = (data['steps'] as num?)?.toInt() ?? 0;
      final speed = (data['speed'] as num?)?.toDouble() ?? 0.0;
      final distance = (data['distance'] as num?)?.toDouble() ?? 0.0;
      final calories = (data['calories'] as num?)?.toDouble() ?? 0.0;
      final temp = (data['temp'] as num?)?.toDouble() ?? 0.0;

      // Parser accéléromètre
      final accelData = data['accel'] as Map<String, dynamic>?;
      final accel = {
        'x': (accelData?['x'] as num?)?.toDouble() ?? 0.0,
        'y': (accelData?['y'] as num?)?.toDouble() ?? 0.0,
        'z': (accelData?['z'] as num?)?.toDouble() ?? 0.0,
      };

      // Parser gyroscope
      final gyroData = data['gyro'] as Map<String, dynamic>?;
      final gyro = {
        'x': (gyroData?['x'] as num?)?.toDouble() ?? 0.0,
        'y': (gyroData?['y'] as num?)?.toDouble() ?? 0.0,
        'z': (gyroData?['z'] as num?)?.toDouble() ?? 0.0,
      };

      // Parser les nouveaux champs
      final cadence = (data['cadence'] as num?)?.toDouble() ?? 0.0;
      final activity = data['activity'] as String? ?? 'Immobile';

      // Émettre sur les streams
      _stepsController.add(steps);
      _speedController.add(speed);
      _distanceController.add(distance);
      _caloriesController.add(calories);
      if (temp > 0) _temperatureController.add(temp);
      _accelController.add(accel);
      _gyroController.add(gyro);
      _cadenceController.add(cadence);
      _activityController.add(activity);

      // Debug
      print(
          '[BLE] Steps: $steps, Speed: ${speed.toStringAsFixed(2)} m/s, Activity: $activity, Cadence: ${cadence.toInt()} pas/min');
    } catch (e) {
      print('[BLE] Erreur de parsing: $e');
      print('[BLE] Message: $message');
    }
  }

  /// Envoyer une commande au Pico W (si nécessaire)
  Future<void> sendCommand(String command) async {
    if (_rxCharacteristic != null && _device != null && _device!.isConnected) {
      try {
        List<int> data = utf8.encode(command);
        await _rxCharacteristic!.write(data);
        print('[BLE] Commande envoyée: $command');
      } catch (e) {
        print('[BLE] Erreur d\'envoi: $e');
      }
    }
  }

  /// Se déconnecter
  Future<void> disconnect() async {
    if (_device != null) {
      await _device!.disconnect();
      _device = null;
      _txCharacteristic = null;
      _rxCharacteristic = null;
      _messageBuffer = '';
      _connectionController.add(false);
      print('[BLE] Déconnecté');
    }
  }

  /// Nettoyer les ressources
  void dispose() {
    disconnect();
    _stepsController.close();
    _speedController.close();
    _distanceController.close();
    _caloriesController.close();
    _temperatureController.close();
    _accelController.close();
    _gyroController.close();
    _connectionController.close();
    _rawDataController.close();
  }
}
