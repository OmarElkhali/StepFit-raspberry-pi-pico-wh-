import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';

/// Thème professionnel moderne pour l'application
class MainTheme {
  /// Thème clair - Design moderne et épuré
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Couleurs principales
      primaryColor: AppColors.kPrimaryColor,
      scaffoldBackgroundColor: AppColors.kScaffoldBackgroundColor,

      // ColorScheme moderne
      colorScheme: ColorScheme.light(
        primary: AppColors.kPrimaryColor,
        secondary: AppColors.kSecondaryColor,
        error: AppColors.kErrorColor,
        background: AppColors.kScaffoldBackgroundColor,
        surface: AppColors.kCardBackgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onBackground: AppColors.kTextPrimaryColor,
        onSurface: AppColors.kTextPrimaryColor,
      ),

      // AppBar moderne
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.kTextPrimaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: const TextStyle(
          color: AppColors.kTextPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.kTextPrimaryColor,
          size: 24,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: AppColors.kShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.kCardBackgroundColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kCardBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kBorderColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kBorderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kPrimaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kErrorColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kErrorColor,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.kTextSecondaryColor,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: AppColors.kTextSecondaryColor.withOpacity(0.6),
          fontSize: 14,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.kPrimaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(
            color: AppColors.kPrimaryColor,
            width: 2,
          ),
          foregroundColor: AppColors.kPrimaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.kCardBackgroundColor,
        selectedItemColor: AppColors.kPrimaryColor,
        unselectedItemColor: AppColors.kTextSecondaryColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.kDividerColor,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.kTextPrimaryColor,
        size: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: 0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: 0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kTextSecondaryColor,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimaryColor,
          letterSpacing: 0.5,
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.kPrimaryColor;
          }
          return AppColors.kTextSecondaryColor;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.kPrimaryColor.withOpacity(0.5);
          }
          return AppColors.kBorderColor;
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.kPrimaryColor,
        inactiveTrackColor: AppColors.kBorderColor,
        thumbColor: AppColors.kPrimaryColor,
        overlayColor: AppColors.kPrimaryColor.withOpacity(0.2),
        valueIndicatorColor: AppColors.kPrimaryColor,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.kPrimaryColor,
      ),

      // Autres propriétés
      splashColor: AppColors.kPrimaryColor.withOpacity(0.1),
      highlightColor: AppColors.kPrimaryColor.withOpacity(0.05),
      hoverColor: AppColors.kPrimaryColor.withOpacity(0.05),
    );
  }

  /// Thème sombre - Design moderne et professionnel
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Couleurs principales
      primaryColor: AppColors.kPrimaryColor,
      scaffoldBackgroundColor: AppColors.kDarkBackgroundColor,

      // ColorScheme moderne
      colorScheme: ColorScheme.dark(
        primary: AppColors.kPrimaryColor,
        secondary: AppColors.kSecondaryColor,
        error: AppColors.kErrorColor,
        background: AppColors.kDarkBackgroundColor,
        surface: AppColors.kDarkCardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onBackground: AppColors.kTextLightColor,
        onSurface: AppColors.kTextLightColor,
      ),

      // AppBar moderne
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.kTextLightColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: const TextStyle(
          color: AppColors.kTextLightColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.kTextLightColor,
          size: 24,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.kDarkCardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kDarkCardColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.kTextSecondaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.kTextSecondaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kPrimaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kErrorColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.kErrorColor,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: AppColors.kTextLightColor.withOpacity(0.7),
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: AppColors.kTextLightColor.withOpacity(0.4),
          fontSize: 14,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.kPrimaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(
            color: AppColors.kPrimaryColor,
            width: 2,
          ),
          foregroundColor: AppColors.kPrimaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.kDarkCardColor,
        selectedItemColor: AppColors.kPrimaryColor,
        unselectedItemColor: AppColors.kTextLightColor.withOpacity(0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.kTextLightColor.withOpacity(0.1),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.kTextLightColor,
        size: 24,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextLightColor,
          letterSpacing: -0.5,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.kTextLightColor,
          letterSpacing: -0.5,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextLightColor,
          letterSpacing: 0,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextLightColor,
          letterSpacing: 0.5,
        ),
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextLightColor,
          letterSpacing: 0.5,
        ),
        titleLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextLightColor,
          letterSpacing: 0.5,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.kTextLightColor,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kTextLightColor.withOpacity(0.7),
          letterSpacing: 0.25,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextLightColor,
          letterSpacing: 0.5,
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.kPrimaryColor;
          }
          return AppColors.kTextSecondaryColor;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.kPrimaryColor.withOpacity(0.5);
          }
          return AppColors.kTextSecondaryColor.withOpacity(0.3);
        }),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.kPrimaryColor,
        inactiveTrackColor: AppColors.kTextSecondaryColor.withOpacity(0.3),
        thumbColor: AppColors.kPrimaryColor,
        overlayColor: AppColors.kPrimaryColor.withOpacity(0.2),
        valueIndicatorColor: AppColors.kPrimaryColor,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.kPrimaryColor,
      ),

      // Autres propriétés
      splashColor: AppColors.kPrimaryColor.withOpacity(0.1),
      highlightColor: AppColors.kPrimaryColor.withOpacity(0.05),
      hoverColor: AppColors.kPrimaryColor.withOpacity(0.05),
    );
  }
}
