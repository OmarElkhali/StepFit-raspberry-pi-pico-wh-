import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/simple_models.dart';

/// Service mock pour simuler les données du Pico W
/// Permet de tester l'interface graphique sans hardware
class MockPicoService {
  final Random _random = Random();
  Timer? _simulationTimer;
  SharedPreferences? _prefs;

  // Streams pour l'UI
  final StreamController<int> _stepsController =
      StreamController<int>.broadcast();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  final StreamController<Map<String, dynamic>> _telemetryController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<int> get stepsStream => _stepsController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<Map<String, dynamic>> get telemetryStream =>
      _telemetryController.stream;

  int _currentSteps = 0;
  bool _isConnected = false;
  bool _isInitialized = false;

  /// Initialise le service mock
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;

    // Créer un profil utilisateur par défaut si nécessaire
    final profileJson = _prefs!.getString('user_profile');
    if (profileJson == null) {
      final defaultProfile = UserProfile(
        userId: 'mock_user_001',
        name: 'Test User',
        weight: 70.0,
        height: 170.0,
        age: 30,
        gender: 'M',
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      await _prefs!
          .setString('user_profile', jsonEncode(defaultProfile.toJson()));
    }

    print('✅ MockPicoService initialized');
  }

  /// Simule la connexion au Pico W
  Future<bool> connect() async {
    await initialize();
    await Future.delayed(const Duration(seconds: 2)); // Simule la connexion
    _isConnected = true;
    _connectionController.add(true);

    // Démarrer la simulation de données
    _startSimulation();

    print('📡 Mock Pico W connected');
    return true;
  }

  /// Déconnecte le service mock
  Future<void> disconnect() async {
    _stopSimulation();
    _isConnected = false;
    _connectionController.add(false);
    print('📴 Mock Pico W disconnected');
  }

  /// Démarre la simulation de données
  void _startSimulation() {
    _stopSimulation(); // Arrêter toute simulation existante

    // Réinitialiser les pas
    _currentSteps = _random.nextInt(5000);
    _stepsController.add(_currentSteps);

    // Simuler des pas toutes les 2-5 secondes
    _simulationTimer = Timer.periodic(
      Duration(seconds: 2 + _random.nextInt(3)),
      (timer) async {
        if (_isConnected) {
          // Incrémenter les pas (0-10 pas par update)
          final newSteps = _random.nextInt(11);
          _currentSteps += newSteps;
          _stepsController.add(_currentSteps);

          // Créer des données de télémétrie simulées
          final telemetry = {
            'steps': _currentSteps,
            'cadence': 100 + _random.nextInt(40), // 100-140 steps/min
            'accel_x': (_random.nextDouble() - 0.5) * 2, // -1.0 à 1.0 g
            'accel_y': (_random.nextDouble() - 0.5) * 2,
            'accel_z':
                1.0 + (_random.nextDouble() - 0.5) * 0.2, // ~1.0g vertical
            'timestamp': DateTime.now().toIso8601String(),
            'battery': 85 + _random.nextInt(15), // 85-100%
          };
          _telemetryController.add(telemetry);

          // Sauvegarder les stats journalières
          await _saveDailyStats(_currentSteps);
        }
      },
    );
  }

  /// Arrête la simulation
  void _stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  /// Sauvegarde les statistiques journalières
  Future<void> _saveDailyStats(int steps) async {
    if (_prefs == null) return;

    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final profile = await getUserProfile();

    // Calculer les statistiques
    final distance = DailyStats.calculateDistance(steps);
    final calories = DailyStats.calculateCalories(steps, profile.weight);

    final stats = DailyStats(
      date: today,
      steps: steps,
      distance: distance,
      calories: calories,
      activeMinutes: (steps / 100).round(), // ~100 steps/min
      deviceId: 'mock_pico_001',
    );

    await _prefs!.setString('stats_$dateKey', jsonEncode(stats.toJson()));
  }

  /// Récupère le profil utilisateur
  Future<UserProfile> getUserProfile() async {
    if (_prefs == null) await initialize();

    final profileJson = _prefs!.getString('user_profile');
    if (profileJson != null) {
      return UserProfile.fromJson(jsonDecode(profileJson));
    }

    return UserProfile(
      userId: 'mock_user_001',
      name: 'Test User',
      weight: 70.0,
      height: 170.0,
      age: 30,
      gender: 'M',
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Récupère les statistiques pour une période
  Future<List<DailyStats>> getStatsRange(DateTime start, DateTime end) async {
    if (_prefs == null) await initialize();

    final List<DailyStats> stats = [];

    for (var i = 0; i <= end.difference(start).inDays; i++) {
      final date = start.add(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final statJson = _prefs!.getString('stats_$dateKey');

      if (statJson != null) {
        stats.add(DailyStats.fromJson(jsonDecode(statJson)));
      }
    }

    return stats;
  }

  /// Récupère les statistiques d'aujourd'hui
  Future<DailyStats?> getTodayStats() async {
    if (_prefs == null) await initialize();

    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final statJson = _prefs!.getString('stats_$dateKey');

    if (statJson != null) {
      return DailyStats.fromJson(jsonDecode(statJson));
    }
    return null;
  }

  /// Génère des données de test pour les 7 derniers jours
  Future<void> generateTestData() async {
    if (_prefs == null) await initialize();

    final today = DateTime.now();
    final profile = await getUserProfile();

    for (var i = 7; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Générer des pas aléatoires (5000-12000)
      final steps = 5000 + _random.nextInt(7000);
      final distance = DailyStats.calculateDistance(steps);
      final calories = DailyStats.calculateCalories(steps, profile.weight);

      final stats = DailyStats(
        date: date,
        steps: steps,
        distance: distance,
        calories: calories,
        activeMinutes: (steps / 100).round(),
        deviceId: 'mock_pico_001',
      );

      await _prefs!.setString('stats_$dateKey', jsonEncode(stats.toJson()));
    }

    print('✅ Generated test data for last 7 days');
  }

  /// Nettoie les ressources
  void dispose() {
    _stopSimulation();
    _stepsController.close();
    _connectionController.close();
    _telemetryController.close();
  }

  // Getters
  bool get isConnected => _isConnected;
  int get currentSteps => _currentSteps;
}
