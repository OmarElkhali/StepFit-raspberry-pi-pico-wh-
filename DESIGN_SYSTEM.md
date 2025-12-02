# 🎨 Design System - StepFit Pro

## Vue d'ensemble

StepFit Pro utilise un design system moderne et professionnel basé sur Material Design 3, optimisé pour une application commerciale de suivi d'activité physique.

---

## 🎨 Palette de Couleurs

### Couleurs Principales

```dart
kPrimaryColor: #6C63FF      // Violet moderne - Actions principales
kSecondaryColor: #4CAF50    // Vert - Succès et validation
kAccentColor: #FF6B6B       // Rouge accent - Points d'attention
```

### Couleurs de Background

```dart
// Mode Clair
kScaffoldBackgroundColor: #F5F7FA  // Gris très clair
kCardBackgroundColor: #FFFFFF      // Blanc pur

// Mode Sombre
kDarkBackgroundColor: #1A1A2E      // Bleu foncé professionnel
kDarkCardColor: #16213E            // Bleu marine
```

### Couleurs Fonctionnelles

```dart
kSuccessColor: #4CAF50    // Vert - Opérations réussies
kWarningColor: #FF9800    // Orange - Avertissements
kErrorColor: #E53935      // Rouge - Erreurs
kInfoColor: #2196F3       // Bleu - Informations
```

### Couleurs de Texte

```dart
// Mode Clair
kTextPrimaryColor: #2C3E50    // Bleu foncé - Texte principal
kTextSecondaryColor: #7F8C8D  // Gris - Texte secondaire

// Mode Sombre
kTextLightColor: #FFFFFF      // Blanc - Texte sur fond sombre
```

### Couleurs des Activités

```dart
kStepsColor: #6C63FF       // Violet - Pas
kDistanceColor: #4CAF50    // Vert - Distance
kCaloriesColor: #FF6B6B    // Rouge - Calories
kSpeedColor: #2196F3       // Bleu - Vitesse
```

---

## 📐 Espacements & Dimensions

### Espacements Standard

```dart
Small: 8px
Medium: 16px
Large: 24px
XLarge: 32px
```

### Border Radius

```dart
Buttons: 16px
Cards: 16px
Input Fields: 16px
Dialogs: 20px
```

### Élévations (Shadows)

```dart
Card: elevation 2 (light) / 4 (dark)
Button: elevation 2 (light) / 4 (dark)
FAB: elevation 4 (light) / 6 (dark)
BottomNav: elevation 8
```

---

## 🔤 Typographie

### Hiérarchie de Texte

```dart
Display Large:   32px, Bold, -0.5 letter spacing
Display Medium:  28px, Bold, -0.5 letter spacing
Display Small:   24px, SemiBold
Headline Medium: 20px, SemiBold, 0.5 letter spacing
Headline Small:  18px, SemiBold, 0.5 letter spacing
Title Large:     16px, SemiBold, 0.5 letter spacing
Body Large:      16px, Regular, 0.5 letter spacing
Body Medium:     14px, Regular, 0.25 letter spacing
Label Large:     14px, SemiBold, 0.5 letter spacing
```

---

## 🔘 Composants

### Buttons

#### Elevated Button
- Padding: 32px horizontal, 16px vertical
- Border Radius: 16px
- Font: 16px, SemiBold, 0.5 letter spacing
- Background: kPrimaryColor
- Text: White

#### Text Button
- Padding: 24px horizontal, 12px vertical
- Font: 14px, SemiBold, 0.5 letter spacing
- Color: kPrimaryColor

#### Outlined Button
- Padding: 32px horizontal, 16px vertical
- Border: 2px, kPrimaryColor
- Border Radius: 16px
- Font: 16px, SemiBold, 0.5 letter spacing

### Cards

- Border Radius: 16px
- Elevation: 2 (light) / 4 (dark)
- Margin: 16px horizontal, 8px vertical
- Shadow: kShadowColor (10% black)

### Input Fields

- Border Radius: 16px
- Padding: 20px horizontal, 16px vertical
- Border Width: 1.5px (normal), 2px (focused)
- Background: kCardBackgroundColor / kDarkCardColor

### AppBar

- Elevation: 0 (transparent)
- Center Title: true
- Title: 20px, SemiBold, 0.5 letter spacing
- Icons: 24px

---

## 📊 Graphiques

### Couleurs des Charts (fl_chart)

```dart
Chart1: #6C63FF  // Violet
Chart2: #4CAF50  // Vert
Chart3: #FF6B6B  // Rouge
Chart4: #2196F3  // Bleu
Chart5: #FF9800  // Orange
```

---

## 🌓 Mode Sombre

Le mode sombre est entièrement pris en charge avec:
- Contrastes optimisés pour la lisibilité
- Couleurs ajustées pour réduire la fatigue oculaire
- Ombres plus prononcées pour la profondeur
- Backgrounds sombres professionnels (#1A1A2E, #16213E)

---

## 🎯 Dégradés

### Dégradés Prédéfinis

```dart
kPrimaryGradient:  #6C63FF → #5A52D5
kSuccessGradient:  #4CAF50 → #45A049
kWarningGradient:  #FF9800 → #F57C00
kErrorGradient:    #E53935 → #D32F2F
```

Utilisation recommandée:
- Backgrounds de cards importantes
- Boutons d'action principaux
- Headers de sections
- Indicateurs de progression

---

## ✨ Animations

### Durées Standard

```dart
Fast: 150ms    // Micro-interactions
Normal: 300ms  // Transitions standard
Slow: 600ms    // Animations élaborées
```

### Courbes

```dart
easeInOut: Transitions fluides
elasticOut: Effets rebond
decelerate: Ralentissement naturel
```

---

## 📱 Responsive Design

### Breakpoints

```dart
Mobile: < 600px
Tablet: 600px - 1024px
Desktop: > 1024px
```

### Marges Responsives

```dart
Mobile: 16px
Tablet: 24px
Desktop: 32px
```

---

## 🎨 Glassmorphism

L'application utilise des effets de glassmorphism pour les cards importantes:

```dart
Background: Blanc/Noir avec opacité 10-20%
Backdrop Filter: Blur 10px
Border: 1px blanc/noir avec opacité 20%
Shadow: Subtile
```

---

## 🔍 Accessibilité

- **Contraste**: Minimum 4.5:1 pour le texte normal
- **Taille de texte**: Minimum 14px
- **Zones de touch**: Minimum 48x48px
- **Labels**: Tous les éléments interactifs ont des labels
- **Mode sombre**: Contrastes vérifiés

---

## 📦 Utilisation

### Importer les couleurs

```dart
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
```

### Importer le thème

```dart
import 'package:flutter_steps_tracker/utilities/locale/theme_data.dart';

// Dans MaterialApp
theme: MainTheme.lightTheme(context),
darkTheme: MainTheme.darkTheme(context),
```

### Utiliser les couleurs

```dart
// Couleur primaire
Container(color: AppColors.kPrimaryColor)

// Dégradé
Container(
  decoration: BoxDecoration(
    gradient: AppColors.kPrimaryGradient,
  ),
)

// Texte avec couleur du thème
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

---

## 🎯 Best Practices

1. **Toujours utiliser les couleurs définies** dans `AppColors`
2. **Utiliser les styles de texte** du `TextTheme`
3. **Respecter les espacements** standard (8, 16, 24, 32px)
4. **Border radius cohérents**: 16px pour la plupart des composants
5. **Tester en mode clair ET sombre**
6. **Minimum 48x48px** pour les zones tactiles
7. **Animations subtiles**: 300ms par défaut
8. **Elevation progressive**: Plus l'élément est important, plus l'élévation est grande

---

## 🔄 Changelog

### Version 2.0 (Actuel)
- ✅ Migration vers Material Design 3
- ✅ Nouveau système de couleurs professionnel
- ✅ Mode sombre optimisé
- ✅ Typographie améliorée
- ✅ Composants cohérents
- ✅ Dégradés modernes
- ✅ Accessibilité renforcée

### Version 1.0 (Original)
- Thème de base avec orange/blue
- Material Design 2

---

## 📞 Support

Pour toute question concernant le design system, consultez:
- `lib/utilities/constants/app_colors.dart` - Définitions des couleurs
- `lib/utilities/locale/theme_data.dart` - Configuration du thème
- `lib/features/iot/presentation/widgets/professional_widgets.dart` - Widgets personnalisés

---

**Dernière mise à jour**: Novembre 2025  
**Version**: 2.0 Professional
