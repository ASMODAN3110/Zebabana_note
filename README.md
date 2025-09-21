# ZeBabana Note 📝

Une application de prise de notes moderne et ergonomique développée avec Flutter, offrant une expérience utilisateur intuitive et des fonctionnalités avancées.

## 🚀 Fonctionnalités

### ✨ Fonctionnalités Principales
- **Création et édition de notes** : Interface intuitive pour saisir et modifier vos notes
- **Recherche intelligente** : Recherche en temps réel dans le titre et le contenu des notes
- **Système de filtrage** : Filtrez vos notes par catégorie (récentes, anciennes, avec/sans titre)
- **Thème sombre/clair** : Basculez entre les thèmes selon vos préférences
- **Sauvegarde automatique** : Vos notes sont automatiquement sauvegardées localement
- **Interface moderne** : Design Material 3 avec des animations fluides

### 🎨 Design et UX
- **Material Design 3** : Interface moderne et cohérente
- **Palette de couleurs indigo** : Design professionnel et apaisant
- **Cartes arrondies** : Interface douce et moderne
- **Animations fluides** : Transitions naturelles entre les écrans
- **Responsive** : Adaptation aux différentes tailles d'écran

### 🔍 Fonctionnalités de Recherche et Filtrage
- **Recherche textuelle** : Recherche dans le titre et le contenu
- **Filtres par date** : Notes récentes (7 derniers jours) vs anciennes
- **Filtres par contenu** : Notes avec ou sans titre
- **Recherche en temps réel** : Résultats instantanés pendant la saisie

## 🛠️ Architecture Technique

### 📁 Structure du Projet
```
lib/
├── main.dart                 # Point d'entrée et configuration de l'app
├── models/
│   └── note.dart            # Modèle de données pour les notes
├── screens/
│   └── note_editor_screen.dart # Écran d'édition des notes
├── services/
│   ├── storage_service.dart  # Service de persistance des données
│   └── theme_service.dart   # Service de gestion des thèmes
└── widgets/
    ├── search_bar.dart      # Widget de barre de recherche
    └── filter_chips.dart    # Widget de puces de filtrage
```

### 🏗️ Architecture des Composants

#### **Modèle de Données (Note)**
```dart
class Note {
  String id;           // Identifiant unique
  String title;        // Titre de la note
  String content;      // Contenu principal
  DateTime createdAt;  // Date de création
  DateTime updatedAt;  // Date de modification
}
```

#### **Services**
- **StorageService** : Gestion de la persistance avec SharedPreferences
- **ThemeService** : Gestion des préférences de thème utilisateur

#### **Widgets Personnalisés**
- **CustomSearchBar** : Barre de recherche avec icônes et animations
- **FilterChips** : Puces de filtrage avec états visuels

## 🚀 Installation et Démarrage

### Prérequis
- Flutter SDK (version 3.8.1 ou supérieure)
- Dart SDK
- Android Studio / VS Code
- Un émulateur ou appareil physique

### Installation
1. **Cloner le projet**
   ```bash
   git clone [url-du-repo]
   cd zebabana_note
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer les icônes de l'application**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Lancer l'application**
   ```bash
   # Sur émulateur Android
   flutter run
   
   # Sur navigateur web
   flutter run -d chrome
   
   # Sur Windows (nécessite Visual Studio)
   flutter run -d windows
   ```

## 📱 Plateformes Supportées

- ✅ **Android** : API 21+ (Android 5.0+)
- ✅ **Web** : Chrome, Firefox, Safari, Edge
- ✅ **Windows** : Windows 10/11
- ⚠️ **iOS** : Support théorique (nécessite Mac pour compilation)
- ⚠️ **macOS** : Support théorique (nécessite Mac pour compilation)
- ⚠️ **Linux** : Support théorique

## 🎯 Utilisation

### Créer une Note
1. Appuyez sur le bouton "Nouvelle Note" (FAB)
2. Saisissez un titre (optionnel)
3. Rédigez votre contenu
4. La note est automatiquement sauvegardée

### Rechercher des Notes
1. Utilisez la barre de recherche en haut
2. Tapez des mots-clés du titre ou du contenu
3. Les résultats s'affichent en temps réel

### Filtrer les Notes
1. Utilisez les puces de filtrage sous la barre de recherche
2. Choisissez entre :
   - **Toutes** : Affiche toutes les notes
   - **Récentes** : Notes des 7 derniers jours
   - **Anciennes** : Notes plus anciennes
   - **Avec titre** : Notes ayant un titre
   - **Sans titre** : Notes sans titre

### Changer de Thème
1. Appuyez sur l'icône de thème dans l'AppBar
2. Basculez entre thème clair et sombre
3. Votre préférence est sauvegardée automatiquement

## 🔧 Configuration

### Personnalisation des Thèmes
Les thèmes sont configurés dans `lib/main.dart` :
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1), // Couleur principale
    brightness: Brightness.light,
  ),
  // ... autres configurations
)
```

### Modification des Icônes
Les icônes sont configurées dans `pubspec.yaml` :
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  image_path: "assets/icons/app_icon.png"
  min_sdk_android: 21
```

## 🧪 Tests

### Lancer les Tests
```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/
```

### Couverture de Code
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Déploiement

### Build pour Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

### Signing Android
1. Créez un keystore
2. Configurez `android/key.properties`
3. Modifiez `android/app/build.gradle`

## 🤝 Contribution

### Guidelines
1. Suivez les conventions Dart/Flutter
2. Ajoutez des tests pour les nouvelles fonctionnalités
3. Documentez le code avec des commentaires
4. Respectez l'architecture existante

### Workflow
1. Fork le projet
2. Créez une branche feature
3. Commitez vos changements
4. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteurs

- **Développeur Principal** : [Votre Nom]
- **Design** : Material Design 3
- **Framework** : Flutter

## 🐛 Signaler un Bug

Pour signaler un bug :
1. Vérifiez les issues existantes
2. Créez une nouvelle issue
3. Décrivez le problème en détail
4. Incluez les étapes de reproduction

## 💡 Idées de Fonctionnalités

- [ ] Synchronisation cloud
- [ ] Catégories et tags
- [ ] Export PDF
- [ ] Recherche avancée
- [ ] Thèmes personnalisés
- [ ] Mode hors ligne
- [ ] Partage de notes
- [ ] Collaboration en temps réel

## 📊 Métriques

- **Taille APK** : ~20.9MB
- **Temps de démarrage** : <2s
- **Mémoire utilisée** : <50MB
- **Taille des données** : Variable selon le nombre de notes

## 🔒 Sécurité

- **Données locales** : Stockées dans SharedPreferences
- **Pas de données sensibles** : Aucune information personnelle collectée
- **Chiffrement** : Optionnel pour les notes sensibles (à implémenter)

## 📱 Captures d'Écran

*Ajoutez des captures d'écran de votre application ici*

## 🎉 Remerciements

- Flutter Team pour le framework
- Material Design pour les guidelines
- Communauté Flutter pour les packages
- Contributeurs du projet

---

**ZeBabana Note** - Votre compagnon de prise de notes moderne et élégant ! 📝✨