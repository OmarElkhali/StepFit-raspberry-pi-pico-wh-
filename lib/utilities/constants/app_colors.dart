import 'package:flutter/material.dart';

/// Palette de couleurs professionnelle - NOIR, BLANC, ORANGE
class AppColors {
  // ============================================
  // COULEURS PRINCIPALES - NOIR, BLANC, ORANGE
  // ============================================

  // Orange - Couleur principale
  static const kPrimaryColor = Color(0xFFFF6B00); // Orange vif
  static const kPrimaryLight = Color(0xFFFF8A33); // Orange clair
  static const kPrimaryDark = Color(0xFFE55A00); // Orange foncé

  // Noir
  static const kBlackColor = Color(0xFF000000); // Noir pur
  static const kBlackLight = Color(0xFF1A1A1A); // Noir léger
  static const kBlackMedium = Color(0xFF2D2D2D); // Noir moyen

  // Blanc
  static const kWhiteColor = Color(0xFFFFFFFF); // Blanc pur
  static const kWhiteOff = Color(0xFFF5F5F5); // Blanc cassé
  static const kWhiteDark = Color(0xFFE0E0E0); // Blanc grisé

  // ============================================
  // BACKGROUNDS
  // ============================================

  // Mode Clair
  static const kScaffoldBackgroundColor = Color(0xFFFFFFFF); // Blanc
  static const kCardBackgroundColor = Color(0xFFF8F8F8); // Blanc cassé

  // Mode Sombre
  static const kDarkBackgroundColor = Color(0xFF121212); // Noir profond
  static const kDarkCardColor = Color(0xFF1E1E1E); // Noir carte
  static const kDarkSurfaceColor = Color(0xFF2A2A2A); // Noir surface

  // ============================================
  // DÉGRADÉS - NOIR, BLANC, ORANGE
  // ============================================

  // Dégradé Orange Principal
  static const kPrimaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFFFF8A33)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dégradé Orange Intense
  static const kOrangeGradient = LinearGradient(
    colors: [Color(0xFFE55A00), Color(0xFFFF6B00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dégradé Noir
  static const kBlackGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dégradé Noir Profond
  static const kBlackDeepGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dégradé Blanc
  static const kWhiteGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dégradé Orange vers Noir (pour headers)
  static const kOrangeToBlackGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFF1A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dégradé Noir vers Orange
  static const kBlackToOrangeGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFFFF6B00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // COULEURS DE TEXTE
  // ============================================

  // Mode Clair
  static const kTextPrimaryColor = Color(0xFF1A1A1A); // Noir
  static const kTextSecondaryColor = Color(0xFF666666); // Gris foncé

  // Mode Sombre
  static const kTextLightColor = Color(0xFFFFFFFF); // Blanc
  static const kTextLightSecondary = Color(0xFFB0B0B0); // Gris clair

  // ============================================
  // COULEURS FONCTIONNELLES
  // ============================================

  static const kSuccessColor = Color(0xFF4CAF50); // Vert
  static const kWarningColor = Color(0xFFFF6B00); // Orange (même que primary)
  static const kErrorColor = Color(0xFFE53935); // Rouge
  static const kInfoColor = Color(0xFF2196F3); // Bleu

  // Dégradés fonctionnels
  static const kSuccessGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const kWarningGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFFE55A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const kErrorGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // COULEURS DES MÉTRIQUES
  // ============================================

  static const kStepsColor = Color(0xFFFF6B00); // Orange - Pas
  static const kDistanceColor = Color(0xFF4CAF50); // Vert - Distance
  static const kCaloriesColor = Color(0xFFE53935); // Rouge - Calories
  static const kSpeedColor = Color(0xFF2196F3); // Bleu - Vitesse
  static const kCadenceColor = Color(0xFFFF8A33); // Orange clair - Cadence

  // ============================================
  // COULEURS DES GRAPHIQUES
  // ============================================

  static const kChart1Color = Color(0xFFFF6B00); // Orange
  static const kChart2Color = Color(0xFF4CAF50); // Vert
  static const kChart3Color = Color(0xFF2196F3); // Bleu
  static const kChart4Color = Color(0xFFE53935); // Rouge
  static const kChart5Color = Color(0xFFFF8A33); // Orange clair

  // ============================================
  // OMBRES ET BORDURES
  // ============================================

  static const kShadowColor = Color(0x29000000); // Noir 16%
  static const kShadowLight = Color(0x14000000); // Noir 8%
  static const kBorderColor = Color(0xFFE0E0E0); // Gris clair
  static const kBorderDarkColor = Color(0xFF3A3A3A); // Gris foncé
  static const kDividerColor = Color(0xFFBDBDBD); // Gris moyen

  // ============================================
  // COMPATIBILITÉ ANCIENNES RÉFÉRENCES
  // ============================================

  static const kSecondaryColor = Color(0xFF4CAF50);
  static const kAccentColor = Color(0xFFFF6B00);
  static const kGreyColor = Color(0xFF9E9E9E);
  static const kRedAccentColor = Color(0xFFE53935);
  static const kLightOrange = Color(0xFFFFE0B2);
  static const kDarkOrange = Color(0xFFE55A00);
  static const kTextDarkColor = Color(0xFF1A1A1A);
}
