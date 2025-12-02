import 'package:flutter_steps_tracker/core/data/services/database_service.dart';
import 'dart:async';

class StatsTracker {
  static final StatsTracker _instance = StatsTracker._internal();
  factory StatsTracker() => _instance;
  StatsTracker._internal();

  final DatabaseService _db = DatabaseService();

  // Données de la session actuelle
  int _sessionSteps = 0;
  double _sessionDistance = 0.0;
  int _sessionCalories = 0;
  DateTime? _sessionStart;
  String _currentActivityType = 'Marche';

  // Données du jour
  int _todaySteps = 0;
  double _todayDistance = 0.0;
  int _todayCalories = 0;

  Timer? _autoSaveTimer;

  // Getters
  int get sessionSteps => _sessionSteps;
  double get sessionDistance => _sessionDistance;
  int get sessionCalories => _sessionCalories;
  int get todaySteps => _todaySteps;
  double get todayDistance => _todayDistance;
  int get todayCalories => _todayCalories;

  /// Initialise le tracker avec les données du jour
  Future<void> initialize() async {
    final today = _getTodayString();
    final stats = await _db.getDailyStats(today);

    if (stats != null) {
      _todaySteps = stats.steps;
      _todayDistance = stats.distance;
      _todayCalories = stats.calories;
    }

    // Sauvegarde automatique toutes les 5 minutes
    _autoSaveTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      saveTodayStats();
    });
  }

  /// Démarre une nouvelle session d'activité
  void startSession() {
    _sessionStart = DateTime.now();
    _sessionSteps = 0;
    _sessionDistance = 0.0;
    _sessionCalories = 0;
  }

  /// Arrête et sauvegarde la session actuelle
  Future<void> endSession() async {
    if (_sessionStart == null) return;

    final duration = DateTime.now().difference(_sessionStart!).inSeconds;

    if (_sessionSteps > 0) {
      final session = ActivitySession(
        date: DateTime.now().toString(),
        steps: _sessionSteps,
        distance: _sessionDistance,
        calories: _sessionCalories,
        durationSeconds: duration,
        activityType: _currentActivityType,
      );

      await _db.saveActivitySession(session);
    }

    _sessionStart = null;
    _sessionSteps = 0;
    _sessionDistance = 0.0;
    _sessionCalories = 0;
  }

  /// Met à jour les données depuis le Bluetooth
  void updateFromBluetooth({
    required int steps,
    required double distance,
    required int calories,
    String? activityType,
  }) {
    // Calculer la différence depuis la dernière mise à jour
    final stepsDiff = steps - _todaySteps;
    final distanceDiff = distance - _todayDistance;
    final caloriesDiff = calories - _todayCalories;

    // Mettre à jour les totaux du jour
    _todaySteps = steps;
    _todayDistance = distance;
    _todayCalories = calories;

    // Mettre à jour la session si active
    if (_sessionStart != null && stepsDiff > 0) {
      _sessionSteps += stepsDiff;
      _sessionDistance += distanceDiff;
      _sessionCalories += caloriesDiff;
    }

    if (activityType != null) {
      _currentActivityType = activityType;
    }
  }

  /// Sauvegarde les statistiques du jour
  Future<void> saveTodayStats() async {
    final today = _getTodayString();

    final stats = DailyStats(
      date: today,
      steps: _todaySteps,
      distance: _todayDistance,
      calories: _todayCalories,
    );

    await _db.saveDailyStats(stats);
  }

  /// Réinitialise les compteurs au début d'un nouveau jour
  Future<void> checkAndResetDay() async {
    final today = _getTodayString();
    final stats = await _db.getDailyStats(today);

    if (stats == null) {
      // Nouveau jour détecté
      _todaySteps = 0;
      _todayDistance = 0.0;
      _todayCalories = 0;
    }
  }

  /// Obtient la date du jour au format yyyy-MM-dd
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Récupère les statistiques de la semaine en cours
  Future<List<DailyStats>> getWeeklyStats() async {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final startString =
        '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
    final endString =
        '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';

    return await _db.getStatsInRange(startString, endString);
  }

  /// Récupère les statistiques du mois en cours
  Future<List<DailyStats>> getMonthlyStats() async {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final endOfMonth = DateTime(today.year, today.month + 1, 0);

    final startString =
        '${startOfMonth.year}-${startOfMonth.month.toString().padLeft(2, '0')}-${startOfMonth.day.toString().padLeft(2, '0')}';
    final endString =
        '${endOfMonth.year}-${endOfMonth.month.toString().padLeft(2, '0')}-${endOfMonth.day.toString().padLeft(2, '0')}';

    return await _db.getStatsInRange(startString, endString);
  }

  /// Récupère les records
  Future<Map<String, dynamic>> getRecords() async {
    final stepsRecord = await _db.getStepsRecord();
    final distanceRecord = await _db.getDistanceRecord();
    final caloriesRecord = await _db.getCaloriesRecord();

    return {
      'steps': stepsRecord,
      'distance': distanceRecord,
      'calories': caloriesRecord,
    };
  }

  /// Récupère les statistiques lifetime
  Future<Map<String, dynamic>> getLifetimeStats() async {
    final totalSteps = await _db.getTotalSteps();
    final totalDistance = await _db.getTotalDistance();
    final totalCalories = await _db.getTotalCalories();
    final allStats = await _db.getAllStats();

    final activeDays = allStats.where((s) => s.steps > 0).length;
    final avgSteps = activeDays > 0 ? (totalSteps / activeDays).round() : 0;

    return {
      'totalSteps': totalSteps,
      'totalDistance': totalDistance,
      'totalCalories': totalCalories,
      'activeDays': activeDays,
      'avgSteps': avgSteps,
    };
  }

  /// Nettoie les anciennes données (garde 90 jours par défaut)
  Future<void> cleanOldData({int daysToKeep = 90}) async {
    await _db.cleanOldData(daysToKeep);
  }

  /// Libère les ressources
  void dispose() {
    _autoSaveTimer?.cancel();
    saveTodayStats(); // Sauvegarde finale
  }
}
