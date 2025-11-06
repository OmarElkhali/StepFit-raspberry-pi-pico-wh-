import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Unused
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

/// Enhanced Home Page with IoT features
class EnhancedHomePage extends StatelessWidget {
  const EnhancedHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Connection Status Card
              const DeviceStatusCard(),
              const SizedBox(height: 20),

              // Main Steps Gauge
              const StepsGaugeCard(),
              const SizedBox(height: 20),

              // Quick Stats Row
              const QuickStatsRow(),
              const SizedBox(height: 20),

              // Real-time Chart
              const RealTimeStepsChart(),
              const SizedBox(height: 20),

              // Daily Goal Progress
              const DailyGoalCard(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Device Connection Status Indicator
class DeviceStatusCard extends StatelessWidget {
  const DeviceStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual device status from BLoC
    final isConnected = true;
    final deviceName = "Pico W - 01";
    final batteryLevel = 87.0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Connection indicator
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConnected ? Colors.green : Colors.red,
                boxShadow: [
                  if (isConnected)
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Device info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    isConnected ? 'Connected' : 'Disconnected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isConnected ? Colors.green : Colors.red,
                        ),
                  ),
                ],
              ),
            ),

            // Battery indicator
            Row(
              children: [
                Icon(
                  _getBatteryIcon(batteryLevel),
                  color: _getBatteryColor(batteryLevel),
                ),
                const SizedBox(width: 4),
                Text(
                  '${batteryLevel.toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getBatteryIcon(double level) {
    if (level > 80) return Icons.battery_full;
    if (level > 50) return Icons.battery_5_bar;
    if (level > 30) return Icons.battery_3_bar;
    if (level > 10) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  Color _getBatteryColor(double level) {
    if (level > 30) return Colors.green;
    if (level > 10) return Colors.orange;
    return Colors.red;
  }
}

/// Enhanced Steps Gauge with Animation
class StepsGaugeCard extends StatelessWidget {
  const StepsGaugeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Get from BLoC
    final currentSteps = 7834;
    final dailyGoal = 10000;
    final percentage = (currentSteps / dailyGoal * 100).clamp(0, 100);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Syncfusion Radial Gauge
            SizedBox(
              height: 280,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: dailyGoal.toDouble(),
                    showLabels: false,
                    showTicks: false,
                    startAngle: 270,
                    endAngle: 270,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.15,
                      cornerStyle: CornerStyle.bothCurve,
                      color: Color(0xFFE0E0E0),
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: currentSteps.toDouble(),
                        cornerStyle: CornerStyle.bothCurve,
                        width: 0.15,
                        sizeUnit: GaugeSizeUnit.factor,
                        gradient: const SweepGradient(
                          colors: <Color>[
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                          stops: <double>[0.25, 0.75],
                        ),
                      ),
                      MarkerPointer(
                        value: currentSteps.toDouble(),
                        markerType: MarkerType.circle,
                        color: const Color(0xFF2575FC),
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentSteps.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2575FC),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'STEPS',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    letterSpacing: 2,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${percentage.toInt()}% of goal',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.1,
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
}

/// Quick Statistics Row
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Get from BLoC
    final distance = 5.2; // km
    final calories = 320;
    final cadence = 115; // steps/min

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.straighten,
            label: 'Distance',
            value: '${distance.toStringAsFixed(1)} km',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            label: 'Calories',
            value: '$calories kcal',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.speed,
            label: 'Cadence',
            value: '$cadence spm',
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Real-time Steps Chart
class RealTimeStepsChart extends StatelessWidget {
  const RealTimeStepsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Get real data from BLoC
    final data = _generateSampleData();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const hours = [
                            '6AM',
                            '9AM',
                            '12PM',
                            '3PM',
                            '6PM',
                            '9PM'
                          ];
                          if (value.toInt() % 3 == 0 &&
                              value.toInt() ~/ 3 < hours.length) {
                            return Text(
                              hours[value.toInt() ~/ 3],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: const Color(0xFF2575FC),
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2575FC).withOpacity(0.3),
                            const Color(0xFF2575FC).withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
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

  List<FlSpot> _generateSampleData() {
    return List.generate(18, (index) {
      return FlSpot(
          index.toDouble(), (index * 50 + (index % 3) * 100).toDouble());
    });
  }
}

/// Daily Goal Progress Card
class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Get from BLoC
    final currentSteps = 7834;
    final dailyGoal = 10000;
    final remaining = dailyGoal - currentSteps;

    return Card(
      elevation: 2,
      color: const Color(0xFF6A11CB),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Daily Goal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$remaining steps to go!',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: currentSteps / dailyGoal,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
