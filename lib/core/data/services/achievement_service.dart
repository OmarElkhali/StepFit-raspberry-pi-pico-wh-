import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Modèle pour un achievement (badge)
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int requirement;
  final String type; // 'steps', 'distance', 'calories', 'streak'
  bool isUnlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.requirement,
    required this.type,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(
      Map<String, dynamic> json, Achievement template) {
    return Achievement(
      id: template.id,
      title: template.title,
      description: template.description,
      icon: template.icon,
      color: template.color,
      requirement: template.requirement,
      type: template.type,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }
}

/// Modèle pour un défi quotidien
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int target;
  final String type;
  final int reward; // Points de récompense
  int progress;
  bool isCompleted;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.type,
    required this.reward,
    this.progress = 0,
    this.isCompleted = false,
  });

  double get progressPercentage => (progress / target).clamp(0.0, 1.0);
}

/// Service de gestion des achievements et défis
class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  final List<Achievement> _achievements = [
    // Achievements de pas
    Achievement(
      id: 'first_steps',
      title: 'Premiers Pas',
      description: 'Faites vos 100 premiers pas',
      icon: Icons.directions_walk,
      color: Colors.blue,
      requirement: 100,
      type: 'steps',
    ),
    Achievement(
      id: 'walker',
      title: 'Marcheur',
      description: 'Atteignez 1000 pas',
      icon: Icons.directions_walk,
      color: Colors.green,
      requirement: 1000,
      type: 'steps',
    ),
    Achievement(
      id: 'athlete',
      title: 'Athlète',
      description: 'Atteignez 5000 pas en un jour',
      icon: Icons.directions_run,
      color: Colors.orange,
      requirement: 5000,
      type: 'steps',
    ),
    Achievement(
      id: 'marathon',
      title: 'Marathonien',
      description: 'Atteignez 10000 pas en un jour',
      icon: Icons.emoji_events,
      color: Colors.amber,
      requirement: 10000,
      type: 'steps',
    ),
    Achievement(
      id: 'ultra_runner',
      title: 'Ultra Runner',
      description: 'Atteignez 20000 pas en un jour',
      icon: Icons.military_tech,
      color: Colors.purple,
      requirement: 20000,
      type: 'steps',
    ),

    // Achievements de distance
    Achievement(
      id: 'first_km',
      title: 'Premier Kilomètre',
      description: 'Parcourez 1 km',
      icon: Icons.straighten,
      color: Colors.cyan,
      requirement: 1,
      type: 'distance',
    ),
    Achievement(
      id: 'five_km',
      title: '5K Champion',
      description: 'Parcourez 5 km en un jour',
      icon: Icons.landscape,
      color: Colors.teal,
      requirement: 5,
      type: 'distance',
    ),
    Achievement(
      id: 'ten_km',
      title: '10K Master',
      description: 'Parcourez 10 km en un jour',
      icon: Icons.terrain,
      color: Colors.indigo,
      requirement: 10,
      type: 'distance',
    ),

    // Achievements de calories
    Achievement(
      id: 'calorie_burner',
      title: 'Brûleur de Calories',
      description: 'Brûlez 100 calories',
      icon: Icons.local_fire_department,
      color: Colors.deepOrange,
      requirement: 100,
      type: 'calories',
    ),
    Achievement(
      id: 'fire_starter',
      title: 'Pyromane',
      description: 'Brûlez 500 calories en un jour',
      icon: Icons.whatshot,
      color: Colors.red,
      requirement: 500,
      type: 'calories',
    ),

    // Achievements de streak
    Achievement(
      id: 'consistent',
      title: 'Régulier',
      description: 'Atteignez votre objectif 3 jours de suite',
      icon: Icons.calendar_today,
      color: Colors.pink,
      requirement: 3,
      type: 'streak',
    ),
    Achievement(
      id: 'dedicated',
      title: 'Dévoué',
      description: 'Atteignez votre objectif 7 jours de suite',
      icon: Icons.event_available,
      color: Colors.deepPurple,
      requirement: 7,
      type: 'streak',
    ),
    Achievement(
      id: 'unstoppable',
      title: 'Inarrêtable',
      description: 'Atteignez votre objectif 30 jours de suite',
      icon: Icons.stars,
      color: Colors.yellow[700]!,
      requirement: 30,
      type: 'streak',
    ),
  ];

  List<DailyChallenge> _dailyChallenges = [];
  int _currentStreak = 0;
  int _totalPoints = 0;
  DateTime? _lastActivityDate;

  List<Achievement> get achievements => _achievements;
  List<DailyChallenge> get dailyChallenges => _dailyChallenges;
  int get currentStreak => _currentStreak;
  int get totalPoints => _totalPoints;
  int get unlockedCount => _achievements.where((a) => a.isUnlocked).length;

  /// Initialiser depuis les préférences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Charger les achievements
    final achievementsJson = prefs.getString('achievements');
    if (achievementsJson != null) {
      final Map<String, dynamic> data = json.decode(achievementsJson);
      for (var achievement in _achievements) {
        if (data.containsKey(achievement.id)) {
          final savedData = data[achievement.id];
          achievement.isUnlocked = savedData['isUnlocked'] ?? false;
          if (savedData['unlockedAt'] != null) {
            achievement.unlockedAt = DateTime.parse(savedData['unlockedAt']);
          }
        }
      }
    }

    // Charger le streak
    _currentStreak = prefs.getInt('current_streak') ?? 0;
    _totalPoints = prefs.getInt('total_points') ?? 0;

    final lastActivityStr = prefs.getString('last_activity_date');
    if (lastActivityStr != null) {
      _lastActivityDate = DateTime.parse(lastActivityStr);
    }

    // Générer les défis quotidiens
    _generateDailyChallenges();
  }

  /// Sauvegarder dans les préférences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    // Sauvegarder les achievements
    final Map<String, dynamic> achievementsData = {};
    for (var achievement in _achievements) {
      achievementsData[achievement.id] = achievement.toJson();
    }
    await prefs.setString('achievements', json.encode(achievementsData));

    // Sauvegarder le streak
    await prefs.setInt('current_streak', _currentStreak);
    await prefs.setInt('total_points', _totalPoints);

    if (_lastActivityDate != null) {
      await prefs.setString(
          'last_activity_date', _lastActivityDate!.toIso8601String());
    }
  }

  /// Vérifier et débloquer les achievements
  List<Achievement> checkAchievements({
    required int steps,
    required double distance,
    required int calories,
  }) {
    final List<Achievement> newlyUnlocked = [];

    for (var achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.type) {
        case 'steps':
          shouldUnlock = steps >= achievement.requirement;
          break;
        case 'distance':
          shouldUnlock = (distance / 1000) >= achievement.requirement;
          break;
        case 'calories':
          shouldUnlock = calories >= achievement.requirement;
          break;
        case 'streak':
          shouldUnlock = _currentStreak >= achievement.requirement;
          break;
      }

      if (shouldUnlock) {
        achievement.isUnlocked = true;
        achievement.unlockedAt = DateTime.now();
        newlyUnlocked.add(achievement);
        _totalPoints += 100; // Points bonus pour chaque achievement
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      save();
    }

    return newlyUnlocked;
  }

  /// Mettre à jour le streak
  void updateStreak(bool goalReached) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastActivityDate != null) {
      final lastDay = DateTime(
        _lastActivityDate!.year,
        _lastActivityDate!.month,
        _lastActivityDate!.day,
      );

      final daysDifference = today.difference(lastDay).inDays;

      if (daysDifference == 0) {
        // Même jour, ne rien faire
        return;
      } else if (daysDifference == 1) {
        // Jour suivant
        if (goalReached) {
          _currentStreak++;
        } else {
          _currentStreak = 0;
        }
      } else {
        // Plus d'un jour de différence, reset
        _currentStreak = goalReached ? 1 : 0;
      }
    } else {
      _currentStreak = goalReached ? 1 : 0;
    }

    _lastActivityDate = now;
    save();
  }

  /// Générer les défis quotidiens
  void _generateDailyChallenges() {
    _dailyChallenges = [
      DailyChallenge(
        id: 'daily_steps',
        title: 'Marcheur Quotidien',
        description: 'Faites 5000 pas aujourd\'hui',
        icon: Icons.directions_walk,
        target: 5000,
        type: 'steps',
        reward: 50,
      ),
      DailyChallenge(
        id: 'daily_distance',
        title: 'Explorateur',
        description: 'Parcourez 3 km aujourd\'hui',
        icon: Icons.explore,
        target: 3,
        type: 'distance',
        reward: 30,
      ),
      DailyChallenge(
        id: 'daily_calories',
        title: 'Brûleur',
        description: 'Brûlez 200 calories aujourd\'hui',
        icon: Icons.local_fire_department,
        target: 200,
        type: 'calories',
        reward: 40,
      ),
    ];
  }

  /// Mettre à jour la progression des défis
  List<DailyChallenge> updateChallenges({
    required int steps,
    required double distance,
    required int calories,
  }) {
    final List<DailyChallenge> completedChallenges = [];

    for (var challenge in _dailyChallenges) {
      if (challenge.isCompleted) continue;

      switch (challenge.type) {
        case 'steps':
          challenge.progress = steps;
          break;
        case 'distance':
          challenge.progress = (distance / 1000).round();
          break;
        case 'calories':
          challenge.progress = calories;
          break;
      }

      if (challenge.progress >= challenge.target && !challenge.isCompleted) {
        challenge.isCompleted = true;
        _totalPoints += challenge.reward;
        completedChallenges.add(challenge);
      }
    }

    if (completedChallenges.isNotEmpty) {
      save();
    }

    return completedChallenges;
  }
}
