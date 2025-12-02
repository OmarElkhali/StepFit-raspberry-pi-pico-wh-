import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DailyStats {
  final int? id;
  final String date; // Format: yyyy-MM-dd
  final int steps;
  final double distance; // km
  final int calories;
  final double avgSpeed; // m/s
  final int activeMinutes;

  DailyStats({
    this.id,
    required this.date,
    required this.steps,
    required this.distance,
    required this.calories,
    this.avgSpeed = 0.0,
    this.activeMinutes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'avgSpeed': avgSpeed,
      'activeMinutes': activeMinutes,
    };
  }

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    return DailyStats(
      id: map['id'],
      date: map['date'],
      steps: map['steps'],
      distance: map['distance'],
      calories: map['calories'],
      avgSpeed: map['avgSpeed'] ?? 0.0,
      activeMinutes: map['activeMinutes'] ?? 0,
    );
  }
}

class ActivitySession {
  final int? id;
  final String date; // Format: yyyy-MM-dd HH:mm:ss
  final int steps;
  final double distance;
  final int calories;
  final int durationSeconds;
  final String activityType; // Marche, Course, etc.

  ActivitySession({
    this.id,
    required this.date,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.durationSeconds,
    required this.activityType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'durationSeconds': durationSeconds,
      'activityType': activityType,
    };
  }

  factory ActivitySession.fromMap(Map<String, dynamic> map) {
    return ActivitySession(
      id: map['id'],
      date: map['date'],
      steps: map['steps'],
      distance: map['distance'],
      calories: map['calories'],
      durationSeconds: map['durationSeconds'],
      activityType: map['activityType'],
    );
  }
}

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'steps_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table des statistiques quotidiennes
    await db.execute('''
      CREATE TABLE daily_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        steps INTEGER NOT NULL,
        distance REAL NOT NULL,
        calories INTEGER NOT NULL,
        avgSpeed REAL DEFAULT 0.0,
        activeMinutes INTEGER DEFAULT 0
      )
    ''');

    // Table des sessions d'activité
    await db.execute('''
      CREATE TABLE activity_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        distance REAL NOT NULL,
        calories INTEGER NOT NULL,
        durationSeconds INTEGER NOT NULL,
        activityType TEXT NOT NULL
      )
    ''');

    // Index pour améliorer les performances
    await db.execute('CREATE INDEX idx_daily_stats_date ON daily_stats(date)');
    await db.execute(
        'CREATE INDEX idx_activity_sessions_date ON activity_sessions(date)');
  }

  // ==================== DAILY STATS ====================

  /// Sauvegarde ou met à jour les statistiques quotidiennes
  Future<int> saveDailyStats(DailyStats stats) async {
    final db = await database;

    // Vérifier si une entrée existe déjà pour cette date
    final existing = await db.query(
      'daily_stats',
      where: 'date = ?',
      whereArgs: [stats.date],
    );

    if (existing.isNotEmpty) {
      // Mettre à jour
      return await db.update(
        'daily_stats',
        stats.toMap(),
        where: 'date = ?',
        whereArgs: [stats.date],
      );
    } else {
      // Insérer
      return await db.insert('daily_stats', stats.toMap());
    }
  }

  /// Récupère les statistiques d'une date spécifique
  Future<DailyStats?> getDailyStats(String date) async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (maps.isEmpty) return null;
    return DailyStats.fromMap(maps.first);
  }

  /// Récupère les statistiques des N derniers jours
  Future<List<DailyStats>> getRecentStats(int days) async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      orderBy: 'date DESC',
      limit: days,
    );

    return List.generate(maps.length, (i) => DailyStats.fromMap(maps[i]));
  }

  /// Récupère les statistiques d'une période
  Future<List<DailyStats>> getStatsInRange(
      String startDate, String endDate) async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date ASC',
    );

    return List.generate(maps.length, (i) => DailyStats.fromMap(maps[i]));
  }

  /// Récupère toutes les statistiques
  Future<List<DailyStats>> getAllStats() async {
    final db = await database;
    final maps = await db.query('daily_stats', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => DailyStats.fromMap(maps[i]));
  }

  // ==================== ACTIVITY SESSIONS ====================

  /// Sauvegarde une session d'activité
  Future<int> saveActivitySession(ActivitySession session) async {
    final db = await database;
    return await db.insert('activity_sessions', session.toMap());
  }

  /// Récupère toutes les sessions d'activité
  Future<List<ActivitySession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query('activity_sessions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => ActivitySession.fromMap(maps[i]));
  }

  /// Récupère les sessions d'une date spécifique
  Future<List<ActivitySession>> getSessionsByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'activity_sessions',
      where: 'date LIKE ?',
      whereArgs: ['$date%'],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) => ActivitySession.fromMap(maps[i]));
  }

  // ==================== STATISTIQUES GLOBALES ====================

  /// Calcule le total de pas de tous les temps
  Future<int> getTotalSteps() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(steps) as total FROM daily_stats');
    return result.first['total'] as int? ?? 0;
  }

  /// Calcule la distance totale de tous les temps
  Future<double> getTotalDistance() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(distance) as total FROM daily_stats');
    return result.first['total'] as double? ?? 0.0;
  }

  /// Calcule les calories totales brûlées
  Future<int> getTotalCalories() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(calories) as total FROM daily_stats');
    return result.first['total'] as int? ?? 0;
  }

  /// Récupère le record de pas en un jour
  Future<DailyStats?> getStepsRecord() async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      orderBy: 'steps DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return DailyStats.fromMap(maps.first);
  }

  /// Récupère le record de distance en un jour
  Future<DailyStats?> getDistanceRecord() async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      orderBy: 'distance DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return DailyStats.fromMap(maps.first);
  }

  /// Récupère le record de calories en un jour
  Future<DailyStats?> getCaloriesRecord() async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      orderBy: 'calories DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return DailyStats.fromMap(maps.first);
  }

  /// Calcule la série actuelle de jours avec objectif atteint
  Future<int> getCurrentStreak(int goalSteps) async {
    final db = await database;
    final maps = await db.query(
      'daily_stats',
      where: 'steps >= ?',
      whereArgs: [goalSteps],
      orderBy: 'date DESC',
    );

    if (maps.isEmpty) return 0;

    int streak = 0;
    DateTime now = DateTime.now();

    for (var map in maps) {
      final date = DateTime.parse(map['date'] as String);
      final expectedDate = now.subtract(Duration(days: streak));

      if (date.year == expectedDate.year &&
          date.month == expectedDate.month &&
          date.day == expectedDate.day) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // ==================== MAINTENANCE ====================

  /// Supprime les données plus anciennes que N jours (pour limiter la taille de la DB)
  Future<int> cleanOldData(int daysToKeep) async {
    final db = await database;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    final cutoffString =
        '${cutoffDate.year}-${cutoffDate.month.toString().padLeft(2, '0')}-${cutoffDate.day.toString().padLeft(2, '0')}';

    // Supprimer les anciennes statistiques quotidiennes
    final dailyDeleted = await db.delete(
      'daily_stats',
      where: 'date < ?',
      whereArgs: [cutoffString],
    );

    // Supprimer les anciennes sessions
    final sessionsDeleted = await db.delete(
      'activity_sessions',
      where: 'date < ?',
      whereArgs: [cutoffString],
    );

    return dailyDeleted + sessionsDeleted;
  }

  /// Ferme la base de données
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
