# 🎨 Instructions pour ajouter le logo du coureur

## Étapes pour compléter la configuration :

### 1. Télécharger l'image du logo
1. Faites un clic droit sur l'image du coureur orange (celle avec le fond transparent)
2. Sélectionnez "Enregistrer l'image sous..."
3. Naviguez vers : `C:\Users\SetupGame\Desktop\IOT\Flutter-Steps-Tracker\assets\images\`
4. Nommez le fichier exactement : `runner_logo.png`
5. Cliquez sur "Enregistrer"

### 2. Générer les icônes de l'application
Une fois l'image sauvegardée, exécutez cette commande dans le terminal :

```bash
flutter pub run flutter_launcher_icons
```

Cette commande va créer automatiquement toutes les tailles d'icônes nécessaires pour Android et iOS.

### 3. Lancer l'application
Après avoir généré les icônes, lancez l'application :

```bash
flutter run -d emulator-5554
```

## ✅ Changements déjà effectués :

### Logo intégré dans :
- ✅ Page d'accueil (ImprovedHomePage) - Header avec cercle orange
- ✅ AppBar de navigation (BottomNavbar) - Logo + texte "Tracker"
- ✅ Configuration pour l'icône de l'application (launcher icon)

### Nom de l'application changé :
- ✅ `android/app/src/main/AndroidManifest.xml` → "Tracker"
- ✅ `lib/main.dart` → title: "Tracker"

### Thème orange :
- ✅ Couleur primaire : Orange
- ✅ Couleur secondaire : Deep Orange
- ✅ Couleurs supplémentaires : kLightOrange, kDarkOrange, kAccentColor

## 📱 Résultat attendu :
- Icône de l'app sur l'écran d'accueil : Logo du coureur orange
- Nom de l'app : "Tracker"
- Thème : Orange partout dans l'application
- Logo visible dans le header et la navigation

## 🔧 Si l'image n'est pas encore ajoutée :
L'application affichera temporairement une icône de course (fallback) jusqu'à ce que vous ajoutiez le fichier `runner_logo.png`.
