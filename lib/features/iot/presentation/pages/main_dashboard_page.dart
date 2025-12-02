import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_steps_tracker/core/data/services/pico_bluetooth_service.dart';
import 'package:flutter_steps_tracker/core/data/services/achievement_service.dart';
import 'package:flutter_steps_tracker/core/data/services/stats_tracker.dart';
import 'package:flutter_steps_tracker/core/data/services/notification_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:flutter_steps_tracker/utilities/locale/cubit/utility_cubit.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/improved_history_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/enhanced_profile_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/sensor_monitor_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/bluetooth_scan_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/achievements_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/statistics_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/widgets/animated_speed_indicator.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/widgets/achievement_notification.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/// Page d'accueil avec connexion Bluetooth au Raspberry Pi Pico WH
class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({Key? key}) : super(key: key);

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  PicoBluetoothService? _bluetoothService;
  final AchievementService _achievementService = AchievementService();
  final StatsTracker _statsTracker = StatsTracker();
  final NotificationService _notificationService = NotificationService();

  // Subscriptions
  StreamSubscription? _stepsSubscription;
  StreamSubscription? _speedSubscription;
  StreamSubscription? _distanceSubscription;
  StreamSubscription? _caloriesSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _cadenceSubscription;
  StreamSubscription? _activitySubscription;

  // Données en temps réel
  int currentSteps = 0;
  int goalSteps = 10000;
  double currentSpeed = 0.0; // m/s
  double distance = 0.0; // km
  int calories = 0;
  double cadence = 0.0; // pas/min
  String activityType = 'Immobile';
  bool isConnected = false;
  String userName = 'Utilisateur';
  String? lastDeviceId;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _achievementService.initialize();
    _statsTracker.initialize();
    _loadUserPreferences();
    _tryAutoReconnect();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Utilisateur';
      goalSteps = prefs.getInt('goal_steps') ?? 10000;
      lastDeviceId = prefs.getString('last_device_id');
    });
  }

  Future<void> _tryAutoReconnect() async {
    if (lastDeviceId != null) {
      // TODO: Implémenter la reconnexion automatique
      print('[BLE] Tentative de reconnexion à: $lastDeviceId');
    }
  }

  void _listenToBluetoothData() {
    if (_bluetoothService == null) return;

    _stepsSubscription = _bluetoothService!.stepsStream.listen((steps) {
      setState(() => currentSteps = steps);
      _checkAchievements();
      _updateStatsTracker();
    });

    _speedSubscription = _bluetoothService!.speedStream.listen((speed) {
      setState(() => currentSpeed = speed);
    });

    _distanceSubscription = _bluetoothService!.distanceStream.listen((dist) {
      setState(() => distance = dist / 1000); // m → km
      _checkAchievements();
      _updateStatsTracker();
    });

    _caloriesSubscription = _bluetoothService!.caloriesStream.listen((cal) {
      setState(() => calories = cal.round());
      _checkAchievements();
      _updateStatsTracker();
    });

    _cadenceSubscription = _bluetoothService!.cadenceStream.listen((cad) {
      setState(() => cadence = cad);
    });

    _activitySubscription =
        _bluetoothService!.activityStream.listen((activity) {
      setState(() => activityType = activity);
    });

    _connectionSubscription =
        _bluetoothService!.connectionStream.listen((connected) {
      setState(() => isConnected = connected);

      if (!connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('⚠️ Pico WH déconnecté'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Reconnecter',
              textColor: Colors.white,
              onPressed: _openBluetoothScanner,
            ),
          ),
        );
      }
    });
  }

  void _checkAchievements() {
    final newlyUnlocked = _achievementService.checkAchievements(
      steps: currentSteps,
      distance: distance,
      calories: calories,
    );

    for (var achievement in newlyUnlocked) {
      AchievementOverlay.show(context, achievement);
      // Send notification
      _notificationService.showAchievementNotification(achievement);
    }

    final completedChallenges = _achievementService.updateChallenges(
      steps: currentSteps,
      distance: distance,
      calories: calories,
    );

    for (var challenge in completedChallenges) {
      // Send notification for completed challenges
      _notificationService.showChallengeCompletedNotification(challenge);
    }
  }

  void _updateStatsTracker() {
    _statsTracker.updateFromBluetooth(
      steps: currentSteps,
      distance: distance,
      calories: calories,
      activityType: activityType,
    );
  }

  Future<void> _openBluetoothScanner() async {
    final service = await Navigator.push<PicoBluetoothService>(
      context,
      MaterialPageRoute(builder: (context) => const BluetoothScanPage()),
    );

    if (service != null && service.isConnected) {
      setState(() => _bluetoothService = service);
      _listenToBluetoothData();

      // Sauvegarder pour reconnexion auto
      // TODO: Implémenter sauvegarde de l'ID du dispositif
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('last_device_id', deviceId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Connecté au Pico WH'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = currentSteps / goalSteps;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar personnalisé
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.kPrimaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, $userName',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isConnected ? '🔵 Pico WH Connecté' : '⚪ Non connecté',
                      style: TextStyle(
                        fontSize: 12,
                        color: isConnected ? Colors.white : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                // Toggle Dark Mode
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    context.read<UtilityCubit>().switchTheme();
                  },
                  tooltip: isDark ? 'Mode clair' : 'Mode sombre',
                ),

                // Bouton scan Bluetooth
                IconButton(
                  icon: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Icon(
                        isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth,
                        color: isConnected
                            ? Colors.white
                            : Colors.white.withOpacity(
                                0.5 + _pulseController.value * 0.5),
                      );
                    },
                  ),
                  onPressed: _openBluetoothScanner,
                  tooltip: 'Scanner Bluetooth',
                ),

                // Bouton achievements
                IconButton(
                  icon: const Icon(Icons.emoji_events, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AchievementsPage()),
                  ),
                  tooltip: 'Achievements',
                ),

                // Bouton capteurs
                IconButton(
                  icon: const Icon(Icons.sensors, color: Colors.white),
                  onPressed: () {
                    if (_bluetoothService != null && isConnected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SensorMonitorPage(
                            bluetoothService: _bluetoothService!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Connectez d\'abord le Pico WH'),
                          backgroundColor: AppColors.kPrimaryColor,
                        ),
                      );
                    }
                  },
                  tooltip: 'Moniteur de capteurs',
                ),

                // Bouton profil
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EnhancedProfilePage()),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Carte principale - Compteur de pas
                    _buildStepsCard(progress),
                    const SizedBox(height: 16),

                    // Widget animé de vitesse
                    _buildAnimatedSpeedWidget(),
                    const SizedBox(height: 16),

                    // Cartes métriques
                    Row(
                      children: [
                        Expanded(
                            child: _buildMetricCard(
                          'Distance',
                          '${distance.toStringAsFixed(2)} km',
                          Icons.straighten,
                          Colors.green,
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildMetricCard(
                          'Cadence',
                          '${cadence.toInt()} p/m',
                          Icons.favorite,
                          Colors.pink,
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _buildMetricCard(
                          'Calories',
                          '$calories kcal',
                          Icons.local_fire_department,
                          Colors.deepOrange,
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildMetricCard(
                          'Objectif',
                          '${(progress * 100).toStringAsFixed(0)}%',
                          Icons.flag,
                          Colors.purple,
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section Défis Quotidiens
                    _buildDailyChallengesSection(),
                    const SizedBox(height: 16),

                    // Bouton statistiques
                    _buildActionButton(
                      'Statistiques détaillées',
                      Icons.bar_chart,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StatisticsPage()),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Bouton historique
                    _buildActionButton(
                      'Voir l\'historique',
                      Icons.history,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImprovedHistoryPage()),
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

  Widget _buildStepsCard(double progress) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:
              isDarkMode ? AppColors.kBlackGradient : AppColors.kOrangeGradient,
        ),
        child: Column(
          children: [
            // Jauge circulaire
            SizedBox(
              height: 280,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: goalSteps.toDouble(),
                    showLabels: false,
                    showTicks: false,
                    startAngle: 270,
                    endAngle: 270,
                    radiusFactor: 0.8,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.15,
                      color: isDarkMode ? Colors.white24 : Colors.black12,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: currentSteps.toDouble(),
                        width: 0.15,
                        color:
                            isDarkMode ? AppColors.kPrimaryColor : Colors.white,
                        sizeUnit: GaugeSizeUnit.factor,
                        enableAnimation: true,
                        animationDuration: 1000,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentSteps.toString(),
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'pas',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Objectif: $goalSteps',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.1,
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress > 1.0 ? 1.0 : progress,
                minHeight: 8,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDarkMode ? AppColors.kPrimaryColor : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSpeedWidget() {
    return AnimatedSpeedIndicator(
      speed: currentSpeed,
      activityType: activityType,
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDarkMode ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.kPrimaryColor, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallengesSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDarkMode ? AppColors.kBlackLight : AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: AppColors.kPrimaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Défis du Jour',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AchievementsPage()),
                  ),
                  child: Text(
                    'Voir tout',
                    style: TextStyle(color: AppColors.kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._achievementService.dailyChallenges.take(2).map((challenge) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.kBlackMedium
                        : AppColors.kWhiteOff,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDarkMode ? Colors.white12 : AppColors.kBorderColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            challenge.icon,
                            color: challenge.isCompleted
                                ? Colors.green
                                : AppColors.kPrimaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              challenge.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          if (challenge.isCompleted)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${challenge.reward}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.kPrimaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: challenge.progressPercentage,
                          minHeight: 6,
                          backgroundColor:
                              isDarkMode ? Colors.white12 : Colors.black12,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            challenge.isCompleted
                                ? Colors.green
                                : AppColors.kPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${challenge.progress}/${challenge.target}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.kPrimaryColor),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stepsSubscription?.cancel();
    _speedSubscription?.cancel();
    _distanceSubscription?.cancel();
    _caloriesSubscription?.cancel();
    _cadenceSubscription?.cancel();
    _activitySubscription?.cancel();
    _connectionSubscription?.cancel();
    _bluetoothService?.dispose();
    _statsTracker.dispose(); // Sauvegarde automatique des données
    super.dispose();
  }
}
