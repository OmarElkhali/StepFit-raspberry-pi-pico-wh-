import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'package:flutter_steps_tracker/core/data/services/pico_bluetooth_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';

/// Page pour scanner et se connecter aux dispositifs Bluetooth BLE
class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({Key? key}) : super(key: key);

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  final PicoBluetoothService _bluetoothService = PicoBluetoothService();

  Map<String, ScanResult> _scanResults = {};
  bool _isScanning = false;
  bool _isConnecting = false;
  String _statusMessage = '';
  StreamSubscription? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  Future<void> _checkBluetoothState() async {
    try {
      // Vérifier si le Bluetooth est supporté
      bool isSupported = await FlutterBluePlus.isSupported;
      if (!isSupported) {
        setState(() {
          _statusMessage =
              '❌ Bluetooth non supporté\n⚠️ Les émulateurs Android ne supportent pas le Bluetooth BLE\n📱 Utilisez un appareil physique pour tester';
        });
        // Afficher un dialog explicatif
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), () {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor:
                    isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
                title: Text(
                  '⚠️ Émulateur détecté',
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
                content: Text(
                  'Les émulateurs Android ne supportent pas le Bluetooth BLE.\n\n'
                  'Pour tester la connexion au Raspberry Pi Pico WH:\n'
                  '1. Utilisez un appareil Android physique\n'
                  '2. Installez l\'APK (voir QUICK_START.md)\n'
                  '3. Activez le Bluetooth sur votre téléphone\n\n'
                  'L\'interface fonctionne, mais vous ne pourrez pas voir les appareils Bluetooth.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Compris',
                      style: TextStyle(color: AppColors.kPrimaryColor),
                    ),
                  ),
                ],
              ),
            );
          });
        }
        return;
      }

      // Vérifier les permissions
      bool hasPermissions = await _bluetoothService.checkPermissions();
      if (!hasPermissions) {
        setState(() {
          _statusMessage =
              '⚠️ Permissions Bluetooth requises\nAppuyez sur Scanner pour les accorder';
        });
        return;
      }

      setState(() {
        _statusMessage = '✓ Bluetooth prêt - Appuyez sur Scanner';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erreur: $e';
      });
    }
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _scanResults.clear();
      _statusMessage = '🔍 Scan en cours...';
    });

    try {
      // Écouter directement les résultats de scan avec toutes les infos
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );

      _scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          setState(() {
            for (var result in results) {
              String deviceId = result.device.remoteId.toString();
              String deviceName = result.device.platformName;
              if (deviceName.isEmpty) {
                deviceName = result.advertisementData.advName;
              }

              _scanResults[deviceId] = result;
              print(
                  '[SCAN] Trouvé: $deviceName - $deviceId - RSSI: ${result.rssi}');
            }
            _statusMessage =
                '✓ ${_scanResults.length} appareil(s) Bluetooth trouvé(s)';
          });
        },
        onError: (error) {
          setState(() {
            _statusMessage = '❌ Erreur de scan: $error';
            _isScanning = false;
          });
        },
        onDone: () {
          setState(() {
            _isScanning = false;
            if (_scanResults.isEmpty) {
              _statusMessage = '⚠️ Aucun dispositif trouvé';
            }
          });
        },
      );
    } catch (e) {
      setState(() {
        _isScanning = false;
        _statusMessage = '❌ Erreur: $e';
      });
    }
  }

  Future<void> _stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSubscription?.cancel();
    setState(() {
      _isScanning = false;
      _statusMessage = 'Scan arrêté';
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
      _statusMessage = '🔗 Connexion à ${device.platformName}...';
    });

    try {
      bool connected = await _bluetoothService.connect(device: device);

      if (connected) {
        setState(() {
          _statusMessage = '✓ Connecté avec succès !';
        });

        // Retourner à la page précédente avec le service connecté
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context, _bluetoothService);
        }
      } else {
        setState(() {
          _statusMessage = '❌ Échec de connexion';
          _isConnecting = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erreur: $e';
        _isConnecting = false;
      });
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kDarkBackgroundColor : AppColors.kWhiteColor,
      appBar: AppBar(
        title: const Text('Scanner Bluetooth',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isScanning)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _stopScan,
              tooltip: 'Arrêter le scan',
            ),
        ],
      ),
      body: Column(
        children: [
          // État et bouton de scan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.kBlackLight, AppColors.kDarkBackgroundColor]
                    : [
                        AppColors.kPrimaryColor.withOpacity(0.1),
                        AppColors.kWhiteColor
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Icône Bluetooth
                Icon(
                  _isScanning ? Icons.bluetooth_searching : Icons.bluetooth,
                  size: 60,
                  color: AppColors.kPrimaryColor,
                ),
                const SizedBox(height: 12),

                // Message de statut
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.kDarkCardColor
                        : AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Bouton de scan
                ElevatedButton.icon(
                  onPressed: _isScanning || _isConnecting ? null : _startScan,
                  icon:
                      Icon(_isScanning ? Icons.hourglass_empty : Icons.search),
                  label: Text(_isScanning ? 'Scan en cours...' : 'Scanner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.kPrimaryColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Indicateur de chargement si scan en cours
          if (_isScanning)
            LinearProgressIndicator(
              backgroundColor:
                  isDark ? AppColors.kBlackMedium : AppColors.kWhiteOff,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.kPrimaryColor),
            ),

          // Liste des dispositifs trouvés
          Expanded(
            child: _scanResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_disabled,
                          size: 80,
                          color: isDark ? Colors.white24 : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun dispositif trouvé',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Appuyez sur "Scanner" pour chercher',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white38 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _scanResults.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final scanResult = _scanResults.values.elementAt(index);
                      final device = scanResult.device;
                      final deviceName = device.platformName.isEmpty
                          ? (scanResult.advertisementData.advName.isEmpty
                              ? 'Dispositif inconnu'
                              : scanResult.advertisementData.advName)
                          : device.platformName;
                      return Card(
                        elevation: 2,
                        color: isDark
                            ? AppColors.kDarkCardColor
                            : AppColors.kWhiteColor,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimaryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.watch,
                              color: AppColors.kPrimaryColor,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            deviceName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                device.remoteId.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Signal: ${scanResult.rssi} dBm',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: scanResult.rssi > -70
                                      ? Colors.green
                                      : AppColors.kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: _isConnecting
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () => _connectToDevice(device),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Connecter'),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Note d'information
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.kPrimaryColor.withOpacity(0.15)
              : AppColors.kPrimaryColor.withOpacity(0.1),
          border: Border(
            top: BorderSide(color: AppColors.kPrimaryColor.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.kPrimaryColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Recherche le dispositif "PicoW-Steps"',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
