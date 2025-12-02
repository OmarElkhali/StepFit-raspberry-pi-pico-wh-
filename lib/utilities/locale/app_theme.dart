import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit pour gérer le thème (Light/Dark mode)
class ThemeCubit {
  static final ThemeCubit _instance = ThemeCubit._internal();
  factory ThemeCubit() => _instance;
  ThemeCubit._internal();

  final _themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  ValueNotifier<ThemeMode> get themeNotifier => _themeNotifier;

  ThemeMode get currentTheme => _themeNotifier.value;

  /// Initialiser le thème depuis les préférences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Basculer entre Light et Dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    _themeNotifier.value = newMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
  }

  /// Définir un thème spécifique
  Future<void> setTheme(ThemeMode mode) async {
    _themeNotifier.value = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
  }

  void dispose() {
    _themeNotifier.dispose();
  }
}

/// Thème Light personnalisé
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF6200EE),
      primaryContainer: Color(0xFFBB86FC),
      secondary: Color(0xFF03DAC6),
      secondaryContainer: Color(0xFF018786),
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF6200EE),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6200EE),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6200EE),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFBB86FC),
      primaryContainer: Color(0xFF6200EE),
      secondary: Color(0xFF03DAC6),
      secondaryContainer: Color(0xFF018786),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF1E1E1E),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFBB86FC),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFBB86FC),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFBB86FC),
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFBB86FC),
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
