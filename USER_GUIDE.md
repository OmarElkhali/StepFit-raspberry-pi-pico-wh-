# 📖 Guide d'Utilisation - StepFit Pro

## Bienvenue dans StepFit Pro! 🎉

StepFit Pro est votre compagnon intelligent pour le suivi de votre activité physique quotidienne. Cette application utilise un capteur de mouvement connecté en Bluetooth pour suivre vos pas, distance, calories et bien plus encore!

---

## 🚀 Démarrage Rapide

### Première Utilisation

1. **Installation**
   - Téléchargez l'APK depuis le lien fourni
   - Installez l'application sur votre smartphone Android
   - Autorisez les permissions demandées (Bluetooth, Notifications)

2. **Connexion du Capteur**
   - Allumez votre capteur (Raspberry Pi Pico WH)
   - Dans l'application, appuyez sur l'icône Bluetooth (en haut à droite)
   - Sélectionnez votre appareil dans la liste
   - Attendez la confirmation de connexion

3. **Configuration du Profil**
   - Appuyez sur l'icône de profil (en haut à droite)
   - Ajoutez votre photo (optionnel)
   - Renseignez vos informations: nom, poids, taille, âge
   - Définissez vos objectifs quotidiens
   - Sauvegardez

4. **C'est Parti!**
   - Placez le capteur sur vous (poche, ceinture, brassard)
   - Commencez à marcher
   - Observez vos statistiques en temps réel

---

## 📱 Navigation dans l'Application

### Écran Principal (Dashboard)

L'écran principal affiche en temps réel:

#### 🎯 Jauge Centrale
- **Pas actuels** avec animation
- **Progression vers l'objectif** (cercle coloré)
- **Pourcentage accompli**

#### 📊 Cartes de Statistiques
1. **Distance** (km)
   - Icône: 📍 verte
   - Valeur en kilomètres avec 2 décimales

2. **Calories** (kcal)
   - Icône: 🔥 orange
   - Calories brûlées calculées

3. **Vitesse** (km/h)
   - Indicateur animé avec aiguille
   - Vitesse instantanée

4. **Cadence** (pas/min)
   - Nombre de pas par minute
   - Indicateur de rythme

5. **Type d'Activité**
   - Immobile 🧍
   - Marche 🚶
   - Course 🏃
   - Sprint 🏃‍♂️💨

#### 🏆 Défis Quotidiens
Trois défis à accomplir chaque jour:
- Chaque défi complété affiche une coche verte ✅
- Nouveaux défis chaque jour à minuit

#### 🔔 État de Connexion
- **Connecté**: Icône Bluetooth bleue
- **Déconnecté**: Icône rouge avec bouton de reconnexion

---

## 📈 Onglet Statistiques

Accédez aux statistiques détaillées via le menu du bas.

### 📅 Vue d'Ensemble
- **Sélecteur de période**: Jour / Semaine / Mois
- **Graphique en barres**: Évolution de vos pas
- **Moyenne affichée** sous le graphique

### 📊 Graphiques Détaillés
**Onglet 1 - Vue Générale**:
- Graphique en barres de vos pas quotidiens
- Ligne de moyenne
- Couleurs: Violet principal

**Onglet 2 - Tendances**:
- Graphique en ligne lisse
- Évolution sur la période choisie
- Points de données cliquables

**Onglet 3 - Comparaison**:
- Graphique en aires empilées
- Comparaison Pas / Distance / Calories
- Légende interactive

### 🏅 Records Personnels
Section en bas de page:
- **Plus de pas en un jour**: 🚶
- **Plus longue distance**: 📍
- **Plus de calories**: 🔥
- **Plus longue série**: 🔥

---

## 🏆 Onglet Succès

Débloquez 13 succès et relevez 3 défis quotidiens!

### Types de Succès

#### 🥉 Bronze (1-3 étoiles)
- **Premier Pas**: 1000 pas
- **Explorateur Débutant**: 1 km
- **Brûleur de Calories**: 100 kcal

#### 🥈 Argent (4-6 étoiles)
- **Marcheur Assidu**: 5000 pas
- **Aventurier**: 5 km
- **Sportif**: 300 kcal

#### 🥇 Or (7-10 étoiles)
- **Champion des Pas**: 10000 pas
- **Grand Voyageur**: 10 km
- **Maître de la Forme**: 500 kcal

#### 💎 Diamant (11-13 étoiles)
- **Légende Vivante**: 20000 pas
- **Ultra Marathon**: 20 km
- **Machine à Brûler**: 1000 kcal
- **Semaine Parfaite**: 7 jours consécutifs

### Défis Quotidiens
Renouvelés chaque jour à minuit:
1. **Défi des Pas**: Atteindre X pas
2. **Défi de Distance**: Parcourir Y km
3. **Défi de Calories**: Brûler Z kcal

**Récompenses**:
- Notification animée à chaque débloquage
- Points cumulés affichés
- Badge visible sur l'écran des succès

---

## 📜 Onglet Historique

Consultez toutes vos données passées.

### Vue Calendrier
- **Dates cliquables** pour voir les détails
- **Indicateurs colorés**: Jours avec activité
- **Navigation mensuelle** avec flèches

### Statistiques à Vie
Carte en haut affichant:
- **Total de pas** depuis le début
- **Distance totale** parcourue
- **Calories totales** brûlées
- **Jours actifs**
- **Moyenne quotidienne**

### Liste des Jours
Pour chaque jour:
- Date et jour de la semaine
- Nombre de pas
- Distance (km)
- Calories (kcal)
- Temps actif (minutes)

---

## 👤 Page Profil

Personnalisez votre expérience.

### Section Avatar
- **Modifier la photo**: Appuyez sur l'avatar
- **Choisir depuis**: Galerie ou Caméra
- **Photo circulaire** affichée partout

### Informations Personnelles
Renseignez:
- **Nom**: Affiché dans l'application
- **Poids**: En kilogrammes (pour calculs)
- **Taille**: En centimètres (pour calculs)
- **Âge**: En années (pour calculs)

### Objectifs Personnalisables
Ajustez avec les curseurs:

1. **Objectif de Pas** 🚶
   - Minimum: 1000 pas
   - Maximum: 20000 pas
   - Par défaut: 10000 pas

2. **Objectif de Distance** 📍
   - Minimum: 1 km
   - Maximum: 20 km
   - Par défaut: 5 km

3. **Objectif de Calories** 🔥
   - Minimum: 100 kcal
   - Maximum: 1000 kcal
   - Par défaut: 300 kcal

### Calculs Automatiques

**IMC (Indice de Masse Corporelle)**:
```
IMC = Poids (kg) / Taille² (m)
```
Catégories:
- < 18.5: Insuffisance pondérale
- 18.5 - 24.9: Poids normal
- 25 - 29.9: Surpoids
- ≥ 30: Obésité

**Métabolisme Basal (BMR)**:
```
Hommes: 10 × Poids + 6.25 × Taille - 5 × Âge + 5
Femmes: 10 × Poids + 6.25 × Taille - 5 × Âge - 161
```

### Actions Rapides
Boutons en bas:
- **Paramètres de Notifications**: Configure les alertes
- **Exporter les Données**: CSV ou PDF
- **Réinitialiser**: Efface toutes les données

---

## 🔔 Notifications

### Configuration

Accédez via: **Profil → Paramètres de notifications**

#### Rappel Quotidien
- **Activer/Désactiver**: Toggle en haut
- **Choisir l'heure**: Bouton "Modifier l'heure"
- **Par défaut**: 19:00

#### Types de Notifications

1. **Succès Débloqués** 🏆
   - Notification dorée
   - Affichée quand vous débloquez un succès
   - Son de célébration

2. **Objectifs Atteints** ✅
   - Notification verte
   - Quand vous atteignez un objectif
   - Message de félicitations

3. **Défis Complétés** 🎯
   - Notification bleue
   - À chaque défi quotidien réussi
   - Points ajoutés

4. **Alertes d'Inactivité** ⏰
   - Notification orange
   - Après 2h sans activité
   - Message d'encouragement

5. **Séries Continues** 🔥
   - Notification rouge-orange
   - À 7, 30, ou multiples de 10 jours
   - Célèbre votre régularité

6. **Progression** 📊
   - Notification discrète
   - 50%, 75%, 90% de l'objectif
   - Vous motive à continuer

#### Section Test
Trois boutons pour tester:
- **Tester Succès**: Simule un succès
- **Tester Objectif**: Simule un objectif atteint
- **Tester Inactivité**: Simule une alerte

---

## 📤 Export de Données

### Accès
**Profil → Exporter les données**

### Choisir la Période

1. **Appuyez sur "Modifier la période"**
2. **Sélectionnez**: Date de début et de fin
3. **Validation**: Les dates sont affichées

Par défaut: 30 derniers jours

### Format CSV 📊

**Idéal pour**: Excel, Google Sheets, analyse

**Contient**:
```
Date, Pas, Distance (km), Calories, Vitesse Moyenne (km/h), Minutes Actives
```

**Utilisation**:
1. Appuyez sur le bouton vert **"Exporter en CSV"**
2. Attendez la génération
3. Choisissez l'application de partage
4. Envoyez par email, stockage, etc.

### Format PDF 📄

**Idéal pour**: Rapports, impression, présentation

**Contient**:
1. **En-tête**: Titre et période
2. **Résumé à Vie**:
   - Total de pas
   - Distance totale
   - Calories totales
   - Jours actifs
   - Moyenne quotidienne

3. **Records Personnels**:
   - Plus de pas en un jour
   - Plus longue distance
   - Plus de calories
   - Série actuelle

4. **Tableau Détaillé**:
   - Une ligne par jour
   - Toutes les statistiques
   - Formatage professionnel

**Utilisation**:
1. Appuyez sur le bouton rouge **"Exporter en PDF"**
2. Attendez la génération
3. Choisissez l'application de partage
4. Imprimez ou partagez

### Historique des Exports

La section en bas affiche:
- **Nombre d'exports CSV**
- **Nombre d'exports PDF**
- **Total des fichiers**

**Nettoyage**:
- Appuyez sur "Nettoyer" pour supprimer les exports de plus de 30 jours
- Libère de l'espace de stockage

---

## 🔧 Paramètres Avancés

### Capteur Bluetooth

#### Connexion
- **Scan**: Recherche automatique des appareils à proximité
- **Nom du capteur**: "Pico WH" ou "StepSensor"
- **Connexion auto**: Se reconnecte automatiquement au démarrage

#### Déconnexion
- **Intentionnelle**: Via le bouton dans les paramètres
- **Accidentelle**: Notification affichée avec option de reconnexion

#### Dépannage
Si la connexion échoue:
1. Redémarrez le capteur (débranchez/rebranchez)
2. Désactivez/Réactivez le Bluetooth du téléphone
3. Relancez l'application
4. Vérifiez la batterie du capteur

### Moniteur de Capteurs

Accédez via: **Menu → Capteur Monitor**

Affiche en temps réel:
- **Accélération X, Y, Z** (m/s²)
- **Gyroscope X, Y, Z** (°/s)
- **Température** du capteur
- **Fréquence de mise à jour** (Hz)

Utile pour:
- Vérifier le bon fonctionnement
- Calibration
- Diagnostic de problèmes

---

## 💡 Conseils d'Utilisation

### Pour une Précision Optimale

1. **Placement du Capteur**
   - ✅ Poche de pantalon
   - ✅ Ceinture centrale
   - ✅ Brassard (bras)
   - ❌ Sac à dos (trop de mouvement parasite)

2. **Calibration**
   - Marchez normalement pendant 2-3 minutes
   - L'algorithme s'adapte à votre foulée
   - Plus vous utilisez, plus c'est précis

3. **Batterie**
   - Chargez le capteur régulièrement
   - Autonomie: ~10 heures d'utilisation continue
   - LED rouge = batterie faible

### Maximiser Votre Activité

1. **Objectifs Progressifs**
   - Commencez petit (5000 pas)
   - Augmentez graduellement
   - Visez 10000 pas pour la santé générale

2. **Défis Quotidiens**
   - Faites-les tous les 3 chaque jour
   - Maintenez une série continue
   - Visez au moins 7 jours d'affilée

3. **Analyse des Statistiques**
   - Consultez vos tendances hebdomadaires
   - Identifiez les jours les plus actifs
   - Planifiez en conséquence

4. **Notifications**
   - Activez les rappels d'inactivité
   - Configurez l'heure qui vous convient
   - Utilisez-les comme motivation

---

## ❓ FAQ (Foire Aux Questions)

### Questions Générales

**Q: L'application nécessite-t-elle internet?**  
R: Non! Toutes les données sont stockées localement sur votre téléphone.

**Q: Puis-je utiliser plusieurs capteurs?**  
R: Non, un seul capteur à la fois. Mais vous pouvez changer de capteur.

**Q: Les données sont-elles sauvegardées?**  
R: Oui, automatiquement toutes les 5 minutes et à chaque fermeture de l'app.

**Q: Puis-je exporter mes données?**  
R: Oui! Format CSV (pour Excel) ou PDF (pour impression).

### Problèmes Courants

**Q: Le capteur ne se connecte pas**  
R: 
1. Vérifiez que le Bluetooth est activé
2. Vérifiez que le capteur est allumé
3. Redémarrez les deux appareils
4. Supprimez et re-scannez le capteur

**Q: Les pas ne sont pas comptés**  
R:
1. Vérifiez que le capteur est connecté (icône bleue)
2. Vérifiez le placement du capteur
3. Marchez normalement (pas de course)
4. Attendez 2-3 pas pour la détection

**Q: Les notifications ne s'affichent pas**  
R:
1. Vérifiez les permissions de notification
2. Désactivez l'optimisation de batterie pour l'app
3. Vérifiez dans Paramètres → Notifications

**Q: L'export ne fonctionne pas**  
R:
1. Vérifiez l'espace de stockage disponible
2. Autorisez l'accès au stockage
3. Choisissez une période avec des données

**Q: Mon IMC n'est pas correct**  
R: Vérifiez que vous avez bien entré:
- Poids en **kilogrammes** (pas en livres)
- Taille en **centimètres** (pas en mètres)

### Performances

**Q: L'application consomme beaucoup de batterie**  
R:
- Normal avec Bluetooth activé en continu
- Déconnectez le capteur quand non utilisé
- Fermer l'app en arrière-plan réduit la consommation

**Q: L'interface est lente**  
R:
1. Fermez les autres applications
2. Redémarrez votre téléphone
3. Nettoyez le cache de l'app
4. Vérifiez que vous avez au moins 100MB de RAM libre

---

## 📊 Comprendre Vos Métriques

### Pas
**Comment c'est calculé?**
- Accéléromètre détecte les oscillations verticales
- Algorithme filtre les faux positifs
- Validation par intervalle de temps

**Pourquoi ça diffère des autres apps?**
- Algorithme propriétaire adaptatif
- Calibré pour votre démarche unique
- Plus précis après utilisation régulière

### Distance
**Formule**: 
```
Distance = Pas × Longueur de foulée
```

**Longueur de foulée moyenne**:
- Marche: 0.415 × Taille
- Course: 0.65 × Taille

### Calories
**Formule MET** (Metabolic Equivalent):
```
Calories = MET × Poids × Durée (heures)
```

**MET par activité**:
- Immobile: 1.0
- Marche lente: 2.5
- Marche rapide: 3.5
- Course: 7.0
- Sprint: 12.0

### Vitesse
**Calcul**:
```
Vitesse = Distance / Temps
```

- Moyenne glissante sur 10 échantillons
- Mise à jour toutes les 0.5 secondes
- Filtre les variations brutales

---

## 🎯 Objectifs de Santé

### Recommandations OMS

**Adultes (18-64 ans)**:
- **Minimum**: 150 min d'activité modérée/semaine
- **Optimal**: 300 min/semaine
- **Pas équivalent**: 7000-10000 pas/jour

**Seniors (65+ ans)**:
- **Minimum**: 150 min/semaine
- **Focus**: Équilibre et force
- **Pas équivalent**: 5000-7000 pas/jour

**Jeunes (5-17 ans)**:
- **Minimum**: 60 min/jour
- **Intensité**: Modérée à vigoureuse
- **Pas équivalent**: 10000-15000 pas/jour

### Zones d'Activité

**🟢 Zone Santé (3000-5000 pas)**:
- Réduit les risques cardiovasculaires
- Améliore la circulation
- Maintient la mobilité

**🟡 Zone Fitness (5000-10000 pas)**:
- Perte de poids modérée
- Renforcement musculaire
- Amélioration cardio

**🟠 Zone Sportive (10000-15000 pas)**:
- Entraînement intensif
- Endurance accrue
- Performance athlétique

**🔴 Zone Extrême (15000+ pas)**:
- Athlètes confirmés
- Préparation marathon
- Nécessite récupération

---

## 🔒 Confidentialité & Sécurité

### Vos Données

**Stockage**:
- ✅ 100% local sur votre téléphone
- ✅ Pas de cloud par défaut
- ✅ Aucun serveur distant

**Partage**:
- ✅ Vous contrôlez les exports
- ✅ Partage manuel uniquement
- ✅ Pas de tracking tiers

**Suppression**:
- ✅ Fonction de réinitialisation dans Profil
- ✅ Suppression immédiate et complète
- ✅ Pas de backup caché

### Permissions

**Bluetooth** 📡:
- Nécessaire pour la connexion au capteur
- Utilisé uniquement pour la communication
- Peut être révoqué (app ne fonctionnera pas)

**Notifications** 🔔:
- Optionnel mais recommandé
- Pour les rappels et achievements
- Configurable complètement

**Stockage** 💾:
- Pour sauvegarder vos données
- Pour générer les exports
- Seulement dossier de l'app

---

## 📞 Support & Aide

### Besoin d'Aide?

**Documentation**:
- Ce guide (APPLICATION_INFO.md)
- Guide de design (DESIGN_SYSTEM.md)
- README technique

**Contact**:
- Email: support@stepfitpro.com
- GitHub Issues: Pour bugs techniques

### Signaler un Bug

Incluez:
1. **Appareil**: Modèle et version Android
2. **Description**: Étapes pour reproduire
3. **Captures d'écran**: Si possible
4. **Logs**: Via Android Studio si disponible

### Suggérer une Fonctionnalité

Nous sommes à l'écoute! Envoyez:
- Description détaillée
- Cas d'usage
- Mockups si possible

---

## 🎓 Tutoriel Vidéo (Bientôt)

Des tutoriels vidéo seront disponibles sur:
- YouTube: @StepFitPro
- Site web: www.stepfitpro.com/tutorials

Sujets couverts:
- ✅ Installation et première connexion
- ✅ Configuration du profil
- ✅ Maximiser la précision
- ✅ Comprendre les statistiques
- ✅ Exporter vos données
- ✅ Dépannage courant

---

## 🌟 Conseils de Pro

### Pour les Débutants
1. Commencez avec l'objectif par défaut (10000 pas)
2. Portez le capteur chaque jour
3. Consultez vos statistiques le soir
4. Célébrez chaque succès

### Pour les Intermédiaires
1. Ajustez vos objectifs progressivement
2. Essayez de maintenir une série de 7 jours
3. Analysez vos tendances hebdomadaires
4. Exportez vos données mensuellement

### Pour les Avancés
1. Utilisez les défis quotidiens comme motivation
2. Combinez avec un plan d'entraînement
3. Analysez vos statistiques détaillées
4. Visez tous les succès diamant

---

**Version du Guide**: 2.0  
**Dernière mise à jour**: Novembre 2025  
**Application**: StepFit Pro v2.0

---

Merci d'utiliser StepFit Pro! 🎉  
Bon entraînement! 🚶‍♂️🏃‍♀️
