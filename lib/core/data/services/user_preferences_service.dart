import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _keyFirstName = 'user_first_name';
  static const String _keyLastName = 'user_last_name';
  static const String _keyWeight = 'user_weight';
  static const String _keyHeight = 'user_height';
  static const String _keyAge = 'user_age';
  static const String _keyGender = 'user_gender';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';

  // Sauvegarder les informations utilisateur
  static Future<void> saveUserInfo({
    required String firstName,
    required String lastName,
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, firstName);
    await prefs.setString(_keyLastName, lastName);
    await prefs.setDouble(_keyWeight, weight);
    await prefs.setDouble(_keyHeight, height);
    await prefs.setInt(_keyAge, age);
    await prefs.setString(_keyGender, gender);
    await prefs.setBool(_keyHasCompletedOnboarding, true);
  }

  // Vérifier si l'utilisateur a complété l'onboarding
  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasCompletedOnboarding) ?? false;
  }

  // Récupérer le prénom
  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName);
  }

  // Récupérer le nom
  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastName);
  }

  // Récupérer le poids
  static Future<double?> getWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyWeight);
  }

  // Récupérer la taille
  static Future<double?> getHeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyHeight);
  }

  // Récupérer l'âge
  static Future<int?> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAge);
  }

  // Récupérer le genre
  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGender);
  }

  // Récupérer toutes les informations
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final hasCompleted = await hasCompletedOnboarding();
    if (!hasCompleted) return null;

    return {
      'firstName': await getFirstName(),
      'lastName': await getLastName(),
      'weight': await getWeight(),
      'height': await getHeight(),
      'age': await getAge(),
      'gender': await getGender(),
    };
  }

  // Effacer toutes les données utilisateur
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyWeight);
    await prefs.remove(_keyHeight);
    await prefs.remove(_keyAge);
    await prefs.remove(_keyGender);
    await prefs.remove(_keyHasCompletedOnboarding);
  }
}
