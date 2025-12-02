import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/pico_bluetooth_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'dart:async';
import 'dart:math' as math;

class SensorMonitorPage extends StatefulWidget {
  final PicoBluetoothService bluetoothService;

  const SensorMonitorPage({Key? key, required this.bluetoothService})
      : super(key: key);

  @override
  State<SensorMonitorPage> createState() => _SensorMonitorPageState();
}

class _SensorMonitorPageState extends State<SensorMonitorPage>
    with SingleTickerProviderStateMixin {
  late PicoBluetoothService _picoService;

  StreamSubscription? _accelSubscription;
  StreamSubscription? _gyroSubscription;
  StreamSubscription? _tempSubscription;
  StreamSubscription? _connectionSubscription;

  late AnimationController _animationController;

  Map<String, double> _accel = {'x': 0, 'y': 0, 'z': 0};
  Map<String, double> _gyro = {'x': 0, 'y': 0, 'z': 0};
  double _temperature = 0.0;
  bool _isConnected = false;

  List<double> _accelXHistory = [];
  List<double> _accelYHistory = [];
  List<double> _accelZHistory = [];
  final int _historyLength = 50;

  @override
  void initState() {
    super.initState();
    _picoService = widget.bluetoothService;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _isConnected = _picoService.isConnected;
    _listenToSensors();
  }

  void _listenToSensors() {
    _accelSubscription = _picoService.accelStream.listen((accel) {
      if (mounted) {
        setState(() {
          _accel = accel;
          _accelXHistory.add(accel['x']!);
          _accelYHistory.add(accel['y']!);
          _accelZHistory.add(accel['z']!);

          if (_accelXHistory.length > _historyLength) {
            _accelXHistory.removeAt(0);
            _accelYHistory.removeAt(0);
            _accelZHistory.removeAt(0);
          }
        });
      }
    });

    _gyroSubscription = _picoService.gyroStream.listen((gyro) {
      if (mounted) {
        setState(() {
          _gyro = gyro;
        });
      }
    });

    _tempSubscription = _picoService.temperatureStream.listen((temp) {
      if (mounted) {
        setState(() {
          _temperature = temp;
        });
      }
    });

    _connectionSubscription = _picoService.connectionStream.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _tempSubscription?.cancel();
    _connectionSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kDarkBackgroundColor : AppColors.kWhiteOff,
      appBar: AppBar(
        title: const Text('Moniteur de Capteurs'),
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isConnected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isConnected ? Icons.wifi : Icons.wifi_off,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isConnected ? 'Connecté' : 'Déconnecté',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Température
            _buildTemperatureCard(),
            const SizedBox(height: 16),

            // Accéléromètre
            _buildAccelerometerCard(),
            const SizedBox(height: 16),

            // Graphique historique
            _buildAccelHistoryCard(),
            const SizedBox(height: 16),

            // Gyroscope
            _buildGyroscopeCard(),
            const SizedBox(height: 16),

            // Visualisation 3D
            _build3DVisualization(),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.orange[300]!, Colors.deepOrange[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.thermostat, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Température du Capteur',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${_temperature.toStringAsFixed(1)}°C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _temperature > 45
                  ? '⚠️ Température élevée'
                  : _temperature > 35
                      ? '✓ Température normale'
                      : '❄️ Température basse',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccelerometerCard() {
    final magnitude = math.sqrt(_accel['x']! * _accel['x']! +
        _accel['y']! * _accel['y']! +
        _accel['z']! * _accel['z']!);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Accéléromètre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildAxisBar('X', _accel['x']!, Colors.red),
            const SizedBox(height: 12),
            _buildAxisBar('Y', _accel['y']!, Colors.green),
            const SizedBox(height: 12),
            _buildAxisBar('Z', _accel['z']!, Colors.blue),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Magnitude',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                  Text(
                    '${magnitude.toStringAsFixed(2)} g',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisBar(String axis, double value, Color color) {
    final percentage = ((value + 2) / 4).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Axe $axis',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${value.toStringAsFixed(2)} g',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccelHistoryCard() {
    if (_accelXHistory.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Text(
              'En attente de données...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Colors.purple[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Historique Accélération',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: CustomPaint(
                painter: AccelGraphPainter(
                  xData: _accelXHistory,
                  yData: _accelYHistory,
                  zData: _accelZHistory,
                ),
                size: Size.infinite,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('X', Colors.red),
                _buildLegendItem('Y', Colors.green),
                _buildLegendItem('Z', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Axe $label',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildGyroscopeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.rotate_right, color: Colors.teal[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Gyroscope (Rotation)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildGyroRow('Roll (X)', _gyro['x']!, Icons.rotate_90_degrees_ccw),
            const SizedBox(height: 12),
            _buildGyroRow('Pitch (Y)', _gyro['y']!, Icons.swap_vert),
            const SizedBox(height: 12),
            _buildGyroRow('Yaw (Z)', _gyro['z']!, Icons.threesixty),
          ],
        ),
      ),
    );
  }

  Widget _buildGyroRow(String label, double value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal[900],
              ),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)}°/s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DVisualization() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.view_in_ar, color: Colors.indigo[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Visualisation 3D',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: Device3DPainter(
                      accel: _accel,
                      gyro: _gyro,
                      animation: _animationController.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Painter pour le graphique d'historique
class AccelGraphPainter extends CustomPainter {
  final List<double> xData;
  final List<double> yData;
  final List<double> zData;

  AccelGraphPainter({
    required this.xData,
    required this.yData,
    required this.zData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (xData.isEmpty) return;

    final xPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final yPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final zPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Grille horizontale
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Ligne zéro
    final zeroY = size.height / 2;
    canvas.drawLine(
      Offset(0, zeroY),
      Offset(size.width, zeroY),
      Paint()
        ..color = Colors.black38
        ..strokeWidth = 1.5,
    );

    void drawLine(List<double> data, Paint paint) {
      final path = Path();
      for (int i = 0; i < data.length; i++) {
        final x = size.width * i / (data.length - 1);
        final y = size.height / 2 - (data[i] * size.height / 4);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    drawLine(xData, xPaint);
    drawLine(yData, yPaint);
    drawLine(zData, zPaint);
  }

  @override
  bool shouldRepaint(AccelGraphPainter oldDelegate) => true;
}

// Painter pour la visualisation 3D
class Device3DPainter extends CustomPainter {
  final Map<String, double> accel;
  final Map<String, double> gyro;
  final double animation;

  Device3DPainter({
    required this.accel,
    required this.gyro,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Rotation basée sur l'accéléromètre
    final tiltX = accel['x']! * 0.3;
    final tiltY = accel['y']! * 0.3;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Dessiner le dispositif (rectangle 3D simulé)
    final devicePaint = Paint()
      ..color = Colors.indigo[700]!
      ..style = PaintingStyle.fill;

    final deviceWidth = size.width * 0.4;
    final deviceHeight = size.height * 0.6;

    // Rectangle principal avec effet 3D
    final rect = Rect.fromCenter(
      center: Offset(tiltX * 20, tiltY * 20),
      width: deviceWidth,
      height: deviceHeight,
    );

    // Ombre
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.translate(5, 5),
        const Radius.circular(12),
      ),
      Paint()..color = Colors.black26,
    );

    // Dispositif
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      devicePaint,
    );

    // Indicateur d'orientation
    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final arrowPath = Path()
      ..moveTo(tiltX * 20, tiltY * 20 - deviceHeight * 0.3)
      ..lineTo(tiltX * 20 - 15, tiltY * 20 - deviceHeight * 0.2)
      ..moveTo(tiltX * 20, tiltY * 20 - deviceHeight * 0.3)
      ..lineTo(tiltX * 20 + 15, tiltY * 20 - deviceHeight * 0.2);

    canvas.drawPath(arrowPath, arrowPaint);

    // Indicateurs de rotation (gyroscope)
    if (gyro['z']!.abs() > 5) {
      final anglePaint = Paint()
        ..color = Colors.amber
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final radius = deviceWidth * 0.6;
      canvas.drawCircle(Offset(tiltX * 20, tiltY * 20), radius, anglePaint);
    }

    canvas.restore();

    // Valeurs textuelles
    final textStyle = TextStyle(
      color: Colors.grey[800],
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text:
            'Inclinaison: X=${tiltX.toStringAsFixed(1)} Y=${tiltY.toStringAsFixed(1)}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(10, size.height - 30),
    );
  }

  @override
  bool shouldRepaint(Device3DPainter oldDelegate) => true;
}
