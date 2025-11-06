/// Modèles simplifiés pour le test de l'interface graphique
/// Ces modèles n'utilisent pas Hive pour éviter les dépendances complexes

class DailyStats {
  final DateTime date;
  final int steps;
  final double distance; // en km
  final double calories;
  final int activeMinutes;
  final String deviceId;

  DailyStats({
    required this.date,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.activeMinutes,
    required this.deviceId,
  });

  /// Calcule la distance parcourue en km
  /// strideLength en mètres (typiquement 0.7-0.8m)
  static double calculateDistance(int steps, {double strideLength = 0.75}) {
    return (steps * strideLength) / 1000.0; // Convert to km
  }

  /// Calcule les calories brûlées
  /// weight en kg
  static double calculateCalories(int steps, double weight) {
    // Formule approximative: 0.04 calories par pas par kg
    return steps * 0.04 * (weight / 70.0);
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'steps': steps,
        'distance': distance,
        'calories': calories,
        'activeMinutes': activeMinutes,
        'deviceId': deviceId,
      };

  factory DailyStats.fromJson(Map<String, dynamic> json) => DailyStats(
        date: DateTime.parse(json['date']),
        steps: json['steps'],
        distance: json['distance'],
        calories: json['calories'],
        activeMinutes: json['activeMinutes'],
        deviceId: json['deviceId'],
      );
}

class UserProfile {
  final String userId;
  final String name;
  final double weight; // kg
  final double height; // cm
  final int age;
  final String gender; // 'M' or 'F'
  final DateTime createdAt;
  final DateTime lastUpdated;

  UserProfile({
    required this.userId,
    required this.name,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
        'createdAt': createdAt.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['userId'],
        name: json['name'],
        weight: json['weight'],
        height: json['height'],
        age: json['age'],
        gender: json['gender'],
        createdAt: DateTime.parse(json['createdAt']),
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );
}
