# 🚀 Guide de Test de l'Interface Graphique

## Vue d'ensemble

Ce guide vous permet de **tester l'interface graphique sans le Raspberry Pi Pico W**. 
Un service mock simule les données du Pico en temps réel.

## ✅ Dépendances Installées

Les packages suivants sont maintenant installés :
- ✅ Flutter & Material Design
- ✅ Syncfusion Gauges (jauge circulaire)
- ✅ FL Chart (graphiques)
- ✅ Provider & BLoC (state management)
- ✅ SharedPreferences (stockage local)
- ✅ Intl (formatage des dates)

## 🎯 Lancer le Test

### Option 1 : Ligne de commande

```powershell
cd C:\Users\SetupGame\Desktop\IOT\Flutter-Steps-Tracker
flutter run -d windows --target=lib/main_test.dart
```

### Option 2 : VS Code

1. Ouvrez `lib/main_test.dart`
2. Appuyez sur `F5` ou cliquez sur "Run and Debug"
3. Sélectionnez votre appareil (Windows, Android, Chrome, etc.)

### Option 3 : Android Emulator

```powershell
flutter run -d emulator-5554 --target=lib/main_test.dart
```

## 🎨 Fonctionnalités de l'Interface

### 1. **Carte de Statut**
- 🔵 Indicateur de connexion (vert = connecté, rouge = déconnecté)
- 🔋 Niveau de batterie simulé (85-100%)
- 📡 État de la simulation

### 2. **Jauge de Pas**
- 🎯 Objectif : 10 000 pas
- 📊 Affichage en pourcentage
- 🌡️ Indicateur visuel avec aiguille
- 💙 Barre de progression bleue

### 3. **Statistiques Rapides**
- 🚶 **Distance** : Calculée en km (longueur de foulée = 0.75m)
- 🔥 **Calories** : Basées sur le poids (70 kg par défaut)
- ⚡ **Cadence** : Pas par minute (100-140 simulé)

### 4. **Graphique en Temps Réel**
- 📈 Affiche l'évolution des pas
- 🔄 Mise à jour toutes les 2-5 secondes
- 📊 Jusqu'à 20 points de données

### 5. **Données du Capteur**
- 📐 Accélération X, Y, Z (en g)
- ⏰ Timestamp de la dernière mise à jour
- 🎲 Données réalistes simulées

## 🎮 Utilisation

1. **Démarrer la simulation** :
   - Cliquez sur l'icône Bluetooth dans l'AppBar
   - OU cliquez sur le bouton flottant (Play)

2. **Observer les données** :
   - Les pas augmentent automatiquement (0-10 par update)
   - Le graphique se met à jour en temps réel
   - Les statistiques sont recalculées

3. **Arrêter la simulation** :
   - Cliquez à nouveau sur l'icône Bluetooth
   - OU cliquez sur le bouton flottant (Stop)

## 📊 Données de Test

Le service mock génère automatiquement :
- ✅ 8 jours de données historiques (5000-12000 pas/jour)
- ✅ Profil utilisateur par défaut
- ✅ Télémétrie simulée réaliste

### Profil Utilisateur Mock
```dart
userId: 'mock_user_001'
name: 'Test User'
weight: 70.0 kg
height: 170.0 cm
age: 30 ans
gender: 'M'
```

## 🔧 Personnalisation

### Modifier l'objectif de pas

Dans `test_dashboard_page.dart` :
```dart
const double goalSteps = 10000; // Changez cette valeur
```

### Modifier la fréquence de simulation

Dans `mock_pico_service.dart` :
```dart
Duration(seconds: 2 + _random.nextInt(3)) // 2-5 secondes
```

### Modifier la longueur de foulée

Dans `simple_models.dart` :
```dart
static double calculateDistance(int steps, {double strideLength = 0.75})
```

## 📱 Build pour Android

```powershell
# Build APK
flutter build apk --target=lib/main_test.dart --release

# Install sur appareil connecté
flutter install --target=lib/main_test.dart
```

## 🖥️ Build pour Windows

```powershell
flutter build windows --target=lib/main_test.dart --release
```

Le fichier .exe sera dans :
```
build\windows\runner\Release\flutter_steps_tracker.exe
```

## 🌐 Build pour Web

```powershell
flutter build web --target=lib/main_test.dart --release

# Test en local
flutter run -d chrome --target=lib/main_test.dart
```

## 🐛 Dépannage

### Les pas ne s'incrémentent pas
- Vérifiez que la connexion est active (indicateur vert)
- Ouvrez la console pour voir les logs
- Redémarrez l'application

### Erreur "Target of URI doesn't exist"
```powershell
flutter clean
flutter pub get
```

### Problèmes de compilation
```powershell
# Nettoyer et rebuild
flutter clean
flutter pub get
flutter run --target=lib/main_test.dart
```

## 📂 Structure des Fichiers

```
lib/
├── main_test.dart                          # Point d'entrée pour le test
└── features/
    └── iot/
        ├── data/
        │   ├── models/
        │   │   └── simple_models.dart      # DailyStats, UserProfile
        │   └── services/
        │       └── mock_pico_service.dart  # Simulation du Pico W
        └── presentation/
            └── pages/
                └── test_dashboard_page.dart # Interface de test
```

## 🎯 Prochaines Étapes

Une fois l'interface validée :

1. **Intégration MQTT** : Remplacer `MockPicoService` par `MqttService`
2. **Connexion Pico W** : Utiliser le firmware dans `pico_firmware/`
3. **Broker MQTT** : Installer Mosquitto (voir `MQTT_SETUP.md`)
4. **Configuration WiFi** : Configurer le Pico W avec vos identifiants

## 💡 Conseils

- 🎨 Testez sur plusieurs appareils (Windows, Android, Web)
- 📊 Observez comment l'UI réagit aux données en temps réel
- 🔄 Testez la reconnexion après déconnexion
- 📈 Vérifiez que les statistiques sont correctes
- 🎯 Personnalisez les couleurs et le thème selon vos préférences

## 🆘 Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs dans la console
2. Assurez-vous que Flutter est à jour : `flutter doctor`
3. Nettoyez le projet : `flutter clean`
4. Réinstallez les dépendances : `flutter pub get`

---

**Créé le** : 4 novembre 2025
**Version** : 1.0.0 (Test UI)
**Statut** : ✅ Prêt pour le test
