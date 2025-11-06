import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_steps_tracker/features/iot/data/services/mock_pico_service.dart';
import 'package:flutter_steps_tracker/features/iot/data/models/simple_models.dart';

/// Page de test pour l'interface graphique du Step Tracker IoT
class TestDashboardPage extends StatefulWidget {
  const TestDashboardPage({Key? key}) : super(key: key);

  @override
  State<TestDashboardPage> createState() => _TestDashboardPageState();
}

class _TestDashboardPageState extends State<TestDashboardPage> {
  final MockPicoService _picoService = MockPicoService();
  int _currentSteps = 0;
  bool _isConnected = false;
  Map<String, dynamic> _telemetry = {};
  final List<int> _stepsHistory = [];
  DailyStats? _todayStats;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _picoService.initialize();

    // Générer des données de test
    await _picoService.generateTestData();

    // Écouter les streams
    _picoService.stepsStream.listen((steps) {
      if (mounted) {
        setState(() {
          _currentSteps = steps;
          _stepsHistory.add(steps);
          if (_stepsHistory.length > 20) {
            _stepsHistory.removeAt(0);
          }
        });
      }
    });

    _picoService.connectionStream.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });
      }
    });

    _picoService.telemetryStream.listen((telemetry) {
      if (mounted) {
        setState(() {
          _telemetry = telemetry;
        });
      }
    });

    // Charger les stats d'aujourd'hui
    _loadTodayStats();
  }

  Future<void> _loadTodayStats() async {
    final stats = await _picoService.getTodayStats();
    if (mounted) {
      setState(() {
        _todayStats = stats;
      });
    }
  }

  Future<void> _toggleConnection() async {
    if (_isConnected) {
      await _picoService.disconnect();
    } else {
      await _picoService.connect();
    }
  }

  @override
  void dispose() {
    _picoService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Step Tracker - Test UI'),
        actions: [
          IconButton(
            icon: Icon(_isConnected
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled),
            onPressed: _toggleConnection,
            tooltip: _isConnected ? 'Disconnect' : 'Connect',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Steps Gauge
            _buildStepsGauge(),
            const SizedBox(height: 16),

            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 16),

            // Real-time Chart
            _buildRealTimeChart(),
            const SizedBox(height: 16),

            // Telemetry Data
            _buildTelemetryCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleConnection,
        child: Icon(_isConnected ? Icons.stop : Icons.play_arrow),
        tooltip: _isConnected ? 'Stop Simulation' : 'Start Simulation',
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _isConnected ? Icons.check_circle : Icons.error,
              color: _isConnected ? Colors.green : Colors.red,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isConnected ? 'Pico W Connecté' : 'Pico W Déconnecté',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    _isConnected ? 'Simulation active' : 'Appuyez pour simuler',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (_telemetry['battery'] != null)
              Column(
                children: [
                  Icon(Icons.battery_full, color: Colors.green),
                  Text('${_telemetry['battery']}%'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsGauge() {
    const double goalSteps = 10000;
    final double percentage = (_currentSteps / goalSteps) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pas Aujourd\'hui',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: goalSteps,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: _currentSteps.toDouble(),
                        color: Colors.blue,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: _currentSteps.toDouble()),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentSteps.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}% de l\'objectif',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final distance = _todayStats?.distance ?? 0.0;
    final calories = _todayStats?.calories ?? 0.0;
    final cadence = _telemetry['cadence'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Distance',
            '${distance.toStringAsFixed(2)} km',
            Icons.directions_walk,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Calories',
            '${calories.toStringAsFixed(0)} kcal',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Cadence',
            '$cadence/min',
            Icons.speed,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTimeChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution en Temps Réel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _stepsHistory.asMap().entries.map((entry) {
                        return FlSpot(
                            entry.key.toDouble(), entry.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Données du Capteur',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildTelemetryRow('Accél X', _telemetry['accel_x'], 'g'),
            _buildTelemetryRow('Accél Y', _telemetry['accel_y'], 'g'),
            _buildTelemetryRow('Accél Z', _telemetry['accel_z'], 'g'),
            if (_telemetry['timestamp'] != null) ...[
              const Divider(),
              Text(
                'Dernière mise à jour: ${_formatTimestamp(_telemetry['timestamp'])}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryRow(String label, dynamic value, String unit) {
    final displayValue =
        value != null ? '${(value as double).toStringAsFixed(3)} $unit' : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            displayValue,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return DateFormat('HH:mm:ss').format(dt);
    } catch (e) {
      return timestamp;
    }
  }
}
