# 📱 StepFit Pro - Application Commerciale

## Vue d'ensemble

**StepFit Pro** est une application mobile professionnelle de suivi d'activité physique utilisant un capteur MPU6500 connecté via Bluetooth à un Raspberry Pi Pico WH.

---

## ✨ Fonctionnalités Principales

### 🚶 Suivi d'Activité en Temps Réel
- **Compteur de pas** avec algorithme de détection avancé
- **Distance parcourue** calculée en kilomètres
- **Calories brûlées** basées sur l'activité
- **Vitesse instantanée** en temps réel
- **Cadence** (pas par minute)
- **Type d'activité** automatique (Immobile, Marche, Course, Sprint)

### 📊 Statistiques Avancées
- **Graphiques interactifs** (barres, lignes, aires)
- **Vue quotidienne, hebdomadaire, mensuelle**
- **Records personnels** automatiques
- **Historique complet** avec statistiques à vie
- **Analyse de tendances** et progression

### 🏆 Système de Récompenses
- **13 succès déblocables** avec conditions progressives
- **3 défis quotidiens** renouvelés chaque jour
- **Système de points** et badges
- **Notifications animées** à chaque succès
- **Suivi de séries** (streak tracking)

### 🔔 Notifications Intelligentes
- **Rappels quotidiens** personnalisables
- **Notifications de succès** en temps réel
- **Alertes d'objectifs** atteints
- **Rappels d'inactivité** après 2h
- **Notifications de défis** complétés
- **Jalons importants** (1000, 5000, 10000 pas...)

### 👤 Profil Personnalisé
- **Photo de profil** avec upload
- **Objectifs personnalisables**:
  - Pas quotidiens (1000 - 20000)
  - Distance (1 - 20 km)
  - Calories (100 - 1000)
- **Informations personnelles**: Poids, Taille, Âge
- **Calculs automatiques**: IMC, Métabolisme basal
- **Statistiques à vie** toujours visibles

### 📤 Export de Données
- **Export CSV** pour Excel/Google Sheets
- **Export PDF** avec rapport complet:
  - Résumé des statistiques à vie
  - Records personnels
  - Tableau détaillé des données
- **Partage facile** via applications
- **Sélection de période** personnalisable
- **Historique des exports**
- **Nettoyage automatique** des anciens fichiers

### 🎨 Interface Moderne
- **Design Material 3** professionnel
- **Mode sombre** optimisé
- **Glassmorphism** sur les cards importantes
- **Animations fluides** et naturelles
- **Effets 3D** sur les widgets
- **Particules flottantes** décoratives
- **Dégradés modernes**

### 📱 Connectivité Bluetooth
- **Scan automatique** des appareils
- **Reconnexion automatique**
- **Indicateur de connexion** en temps réel
- **Gestion des déconnexions**
- **Compatible Raspberry Pi Pico WH**

### 💾 Sauvegarde Locale
- **Base de données SQLite** intégrée
- **Synchronisation automatique** toutes les 5 minutes
- **Statistiques quotidiennes** sauvegardées
- **Sessions d'activité** enregistrées
- **Pas de connexion internet requise**

---

## 🛠️ Architecture Technique

### Technologies Utilisées

#### Frontend
- **Flutter 3.13.2** / Dart 3.1.0
- **Material Design 3**
- **BLoC Pattern** pour la gestion d'état
- **Provider** pour l'injection de dépendances

#### Packages Principaux
```yaml
# Bluetooth
flutter_blue_plus: ^1.32.12

# Base de données
sqflite: ^2.3.2

# Graphiques
fl_chart: ^0.63.0

# Notifications
flutter_local_notifications: ^17.0.0
timezone: ^0.9.2

# Export
pdf: ^3.10.7
share_plus: ^7.2.2

# UI
syncfusion_flutter_gauges: ^20.1.59
```

#### Hardware
- **Raspberry Pi Pico WH 2022**
- **Capteur MPU6500** (accéléromètre + gyroscope)
- **Bluetooth Low Energy (BLE)**
- **Service UART Nordic**

### Architecture du Code

```
lib/
├── core/
│   ├── config/          # Configuration
│   ├── data/
│   │   ├── models/      # Modèles de données
│   │   └── services/    # Services (BLE, Database, Stats...)
│   └── domain/          # Logique métier
├── features/
│   ├── iot/             # Fonctionnalités principales
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/   # Écrans
│   │       └── widgets/ # Composants UI
│   └── intro/           # Splash screen
├── utilities/
│   ├── constants/       # Couleurs, assets
│   ├── locale/          # Thème, localisation
│   └── routes/          # Navigation
└── main.dart            # Point d'entrée
```

---

## 📊 Métriques & Performance

### Algorithmes
- **Détection de pas**: Seuil dynamique + validation temporelle
- **Calcul de vitesse**: Moyenne glissante sur 10 échantillons
- **Calories**: Formule MET (Metabolic Equivalent of Task)
- **Distance**: Longueur de foulée adaptative

### Performance
- **Fréquence de mise à jour**: 500ms (Bluetooth)
- **Sauvegarde auto**: 5 minutes
- **Latence UI**: < 16ms (60 FPS)
- **Taille APK**: ~26 MB (release)

---

## 🚀 Installation & Déploiement

### Prérequis
- Flutter 3.13.2 ou supérieur
- Android SDK 21+ (Android 5.0+)
- Raspberry Pi Pico WH avec firmware Bluetooth

### Build Debug
```bash
flutter build apk --debug
```

### Build Release (Production)
```bash
flutter build apk --release
```

### Installation
```bash
# Via ADB
adb install build/app/outputs/flutter-apk/app-release.apk

# Via Flutter
flutter install
```

---

## 🎯 Configuration

### Objectifs par Défaut
```dart
Steps: 10000 pas/jour
Distance: 5 km/jour
Calories: 300 kcal/jour
```

### Rappels
```dart
Heure par défaut: 19:00
Fréquence: Quotidienne
```

### Base de Données
```dart
Tables:
- daily_stats: Statistiques journalières
- activity_sessions: Sessions d'activité détaillées
```

---

## 📱 Captures d'Écran

### Écrans Principaux
1. **Splash Screen**: Logo animé avec particules
2. **Dashboard**: Vue d'ensemble avec jauges et stats
3. **Statistiques**: Graphiques détaillés sur 3 onglets
4. **Succès**: Liste des 13 succès + 3 défis
5. **Historique**: Données passées + stats à vie
6. **Profil**: Avatar, objectifs, infos personnelles
7. **Paramètres Notifications**: Configuration complète
8. **Export**: CSV/PDF avec sélection de période
9. **Bluetooth**: Scan et connexion
10. **Capteurs**: Monitoring MPU6500 en direct

---

## 🔐 Sécurité & Confidentialité

- ✅ **Aucune connexion internet requise**
- ✅ **Données stockées localement uniquement**
- ✅ **Pas de tracking tiers**
- ✅ **Pas de publicités**
- ✅ **Open source** (code disponible)

---

## 📈 Roadmap Future

### Version 2.1 (Planifiée)
- [ ] Synchronisation cloud optionnelle
- [ ] Partage social de performances
- [ ] Comparaison avec amis
- [ ] Plans d'entraînement personnalisés

### Version 2.2 (Planifiée)
- [ ] Intégration Google Fit
- [ ] Apple Health support
- [ ] Widgets home screen
- [ ] Wear OS support

### Version 3.0 (Vision)
- [ ] IA pour recommandations personnalisées
- [ ] Coaching virtuel
- [ ] Réalité augmentée pour la course
- [ ] Multi-capteurs (cardio, SpO2...)

---

## 🐛 Dépannage

### Bluetooth ne se connecte pas
1. Vérifier que le Pico WH est alimenté
2. Redémarrer le Bluetooth du téléphone
3. Vérifier les permissions Bluetooth
4. Relancer l'application

### Pas non détectés
1. Vérifier la calibration du MPU6500
2. Marcher avec le capteur en position verticale
3. Ajuster les seuils de sensibilité

### Notifications ne fonctionnent pas
1. Vérifier les permissions de notifications
2. Vérifier que l'application n'est pas optimisée (battery saver)
3. Activer les notifications dans les paramètres

---

## 📞 Support

### Contact
- **Email**: support@stepfitpro.com
- **GitHub**: [Flutter-Steps-Tracker](https://github.com/TarekAlabd/Flutter-Steps-Tracker)
- **Documentation**: Voir fichiers `/docs`

### Ressources
- [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) - Guide de design
- [TEST_UI_GUIDE.md](TEST_UI_GUIDE.md) - Guide de test UI
- [README.md](README.md) - Documentation technique

---

## 📄 Licence

**Propriétaire** - Usage commercial autorisé.

© 2025 StepFit Pro. Tous droits réservés.

---

## 👥 Crédits

### Développement
- **Architecture**: Clean Architecture + BLoC
- **UI/UX**: Material Design 3
- **Hardware**: Raspberry Pi Pico WH + MPU6500

### Packages Open Source
Merci aux mainteneurs de:
- flutter_blue_plus
- fl_chart
- sqflite
- flutter_local_notifications
- pdf, share_plus
- et tous les autres packages utilisés

---

**Version**: 2.0 Professional  
**Build**: Release  
**Dernière mise à jour**: Novembre 2025
