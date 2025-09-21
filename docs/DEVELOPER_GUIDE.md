# Guide du Développeur - ZeBabana Note

## 📋 Table des Matières

1. [Architecture](#architecture)
2. [Structure du Code](#structure-du-code)
3. [Modèles de Données](#modèles-de-données)
4. [Services](#services)
5. [Widgets](#widgets)
6. [Navigation](#navigation)
7. [Gestion d'État](#gestion-détat)
8. [Tests](#tests)
9. [Déploiement](#déploiement)
10. [Bonnes Pratiques](#bonnes-pratiques)

## 🏗️ Architecture

### Pattern Architectural
L'application suit le pattern **MVVM (Model-View-ViewModel)** avec des éléments de **Clean Architecture** :

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │    Business     │    │      Data       │
│                 │    │                 │    │                 │
│  - Screens      │◄──►│  - Services     │◄──►│  - Models       │
│  - Widgets      │    │  - Use Cases    │    │  - Storage      │
│  - ViewModels   │    │  - Repositories │    │  - APIs         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Flux de Données
```
User Input → Widget → State Management → Service → Storage
     ↑                                              ↓
     └─────────── UI Update ←─── State Change ←────┘
```

## 📁 Structure du Code

### Organisation des Fichiers
```
lib/
├── main.dart                    # Point d'entrée
├── models/                      # Modèles de données
│   └── note.dart               # Modèle Note
├── screens/                     # Écrans de l'application
│   └── note_editor_screen.dart # Éditeur de notes
├── services/                    # Services métier
│   ├── storage_service.dart    # Persistance des données
│   └── theme_service.dart     # Gestion des thèmes
├── widgets/                     # Widgets réutilisables
│   ├── search_bar.dart         # Barre de recherche
│   └── filter_chips.dart       # Puces de filtrage
└── utils/                       # Utilitaires (à créer)
    ├── constants.dart          # Constantes
    ├── extensions.dart         # Extensions Dart
    └── validators.dart         # Validateurs
```

### Conventions de Nommage
- **Classes** : PascalCase (`NoteEditorScreen`)
- **Méthodes** : camelCase (`_loadNotes()`)
- **Variables** : camelCase avec underscore pour privées (`_isLoading`)
- **Constantes** : UPPER_SNAKE_CASE (`_NOTES_KEY`)
- **Fichiers** : snake_case (`note_editor_screen.dart`)

## 📊 Modèles de Données

### Classe Note
```dart
/// Modèle de données représentant une note dans l'application
/// Contient toutes les informations nécessaires pour une note : titre, contenu, dates
class Note {
  /// Identifiant unique de la note
  String id;
  
  /// Titre de la note (peut être vide)
  String title;
  
  /// Contenu principal de la note
  String content;
  
  /// Date et heure de création de la note
  DateTime createdAt;
  
  /// Date et heure de dernière modification de la note
  DateTime updatedAt;
}
```

### Sérialisation JSON
```dart
// Conversion vers JSON
Map<String, dynamic> toJson() => {
  'id': id,
  'title': title,
  'content': content,
  'createdAt': createdAt.toIso8601String(),
  'updatedAt': updatedAt.toIso8601String(),
};

// Création depuis JSON
factory Note.fromJson(Map<String, dynamic> json) => Note(
  id: json['id'],
  title: json['title'],
  content: json['content'],
  createdAt: DateTime.parse(json['createdAt']),
  updatedAt: DateTime.parse(json['updatedAt']),
);
```

## 🔧 Services

### StorageService
```dart
/// Service de stockage local pour les notes
/// Utilise SharedPreferences pour persister les données de l'application
class StorageService {
  static const String _notesKey = 'notes';
  
  /// Sauvegarde une liste de notes dans le stockage local
  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => note.toJson()).toList();
    await prefs.setString(_notesKey, jsonEncode(notesJson));
  }
  
  /// Charge toutes les notes depuis le stockage local
  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString(_notesKey);
    if (notesString == null) return [];
    final notesList = jsonDecode(notesString) as List;
    return notesList.map((json) => Note.fromJson(json)).toList();
  }
}
```

### ThemeService
```dart
/// Service de gestion des thèmes de l'application
/// Permet de sauvegarder et récupérer les préférences de thème de l'utilisateur
class ThemeService {
  static const String _themeKey = 'isDarkMode';
  
  /// Vérifie si le thème sombre est activé
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
  
  /// Définit le mode de thème de l'application
  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
```

## 🎨 Widgets

### Widgets Personnalisés

#### CustomSearchBar
```dart
/// Widget de barre de recherche personnalisée
/// Fournit une interface de recherche moderne avec icônes et animations
class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String? initialValue;
}
```

#### FilterChips
```dart
/// Widget de puces de filtrage pour les notes
/// Permet à l'utilisateur de filtrer les notes selon différents critères
class FilterChips extends StatelessWidget {
  final NoteFilter selectedFilter;
  final ValueChanged<NoteFilter> onFilterChanged;
}
```

### Énumérations
```dart
/// Énumération des types de filtres disponibles pour les notes
enum NoteFilter {
  all, // Toutes les notes
  recent, // Notes récentes (7 derniers jours)
  old, // Notes anciennes (plus de 7 jours)
  withTitle, // Notes avec titre
  withoutTitle, // Notes sans titre
}
```

## 🧭 Navigation

### Structure de Navigation
```
MyApp
└── HomeScreen
    ├── NoteEditorScreen (nouvelle note)
    └── NoteEditorScreen (modifier note)
```

### Gestion des Routes
```dart
// Navigation vers l'éditeur
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NoteEditorScreen(note: null),
  ),
).then((_) => _loadNotes());

// Retour avec rechargement des données
Navigator.pop(context);
```

## 🔄 Gestion d'État

### Pattern StatefulWidget
L'application utilise le pattern StatefulWidget pour la gestion d'état :

```dart
class _HomeScreenState extends State<HomeScreen> {
  // Variables d'état
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  NoteFilter _selectedFilter = NoteFilter.all;
  
  // Méthodes de mise à jour d'état
  void _applyFilters() {
    // Logique de filtrage
    setState(() {
      _filteredNotes = filtered;
    });
  }
}
```

### Cycle de Vie des Widgets
```dart
@override
void initState() {
  super.initState();
  // Initialisation
  _loadNotes();
}

@override
void dispose() {
  // Nettoyage des ressources
  _controller.dispose();
  super.dispose();
}
```

## 🧪 Tests

### Structure des Tests
```
test/
├── models/
│   └── note_test.dart
├── screens/
│   └── note_editor_screen_test.dart
├── services/
│   ├── storage_service_test.dart
│   └── theme_service_test.dart
└── widgets/
    ├── search_bar_test.dart
    └── filter_chips_test.dart
```

### Exemple de Test Unit
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zebabana_note/models/note.dart';

void main() {
  group('Note Model Tests', () {
    test('should create note from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Note',
        'content': 'Test Content',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-01T00:00:00.000Z',
      };
      
      // Act
      final note = Note.fromJson(json);
      
      // Assert
      expect(note.id, '1');
      expect(note.title, 'Test Note');
      expect(note.content, 'Test Content');
    });
  });
}
```

### Tests d'Intégration
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:zebabana_note/main.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should display home screen', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Act
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('ZeBabana Note'), findsOneWidget);
    });
  });
}
```

## 🚀 Déploiement

### Configuration de Build

#### Android
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

#### Web
```yaml
# pubspec.yaml
flutter:
  web:
    renderer: html
```

### Variables d'Environnement
```dart
// lib/config/app_config.dart
class AppConfig {
  static const String appName = 'ZeBabana Note';
  static const String version = '1.0.0';
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
}
```

## 📋 Bonnes Pratiques

### Code Style
1. **Utilisez dart format** pour formater le code
2. **Suivez les conventions Dart** officielles
3. **Ajoutez des commentaires** pour les sections complexes
4. **Utilisez des noms descriptifs** pour les variables et méthodes

### Performance
1. **Évitez les rebuilds inutiles** avec const constructors
2. **Utilisez ListView.builder** pour les listes longues
3. **Optimisez les images** et assets
4. **Gérez la mémoire** avec dispose()

### Sécurité
1. **Validez les entrées utilisateur**
2. **Ne stockez pas de données sensibles** en local
3. **Utilisez HTTPS** pour les appels réseau
4. **Implémentez l'authentification** si nécessaire

### Maintenance
1. **Écrivez des tests** pour chaque fonctionnalité
2. **Documentez les APIs** publiques
3. **Utilisez des types stricts** (non-nullable)
4. **Refactorisez régulièrement** le code

## 🔍 Debugging

### Outils de Debug
```dart
// Logging conditionnel
if (kDebugMode) {
  print('Debug: $message');
}

// Assertions
assert(condition, 'Error message');

// Breakpoints dans l'IDE
```

### Profiling
```bash
# Profiling de performance
flutter run --profile

# Analyse de la taille
flutter build apk --analyze-size
```

## 📚 Ressources

### Documentation Flutter
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design](https://material.io/design)

### Packages Utiles
- `shared_preferences` : Stockage local
- `intl` : Internationalisation
- `flutter_colorpicker` : Sélecteur de couleurs

### Outils de Développement
- **Flutter Inspector** : Debugging UI
- **Dart DevTools** : Profiling
- **VS Code** : IDE recommandé
- **Android Studio** : IDE alternatif

---

**Note** : Ce guide est maintenu à jour avec les dernières versions de Flutter et les bonnes pratiques de développement.
