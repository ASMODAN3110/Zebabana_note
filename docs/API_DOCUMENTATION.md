# Documentation API - ZeBabana Note

## 📋 Table des Matières

1. [Modèles de Données](#modèles-de-données)
2. [Services](#services)
3. [Widgets](#widgets)
4. [Écrans](#écrans)
5. [Utilitaires](#utilitaires)

## 📊 Modèles de Données

### Classe Note

Représente une note dans l'application avec toutes ses propriétés et méthodes.

#### Propriétés

| Propriété | Type | Description | Requis |
|-----------|------|-------------|--------|
| `id` | `String` | Identifiant unique de la note | ✅ |
| `title` | `String` | Titre de la note (peut être vide) | ✅ |
| `content` | `String` | Contenu principal de la note | ✅ |
| `createdAt` | `DateTime` | Date et heure de création | ✅ |
| `updatedAt` | `DateTime` | Date et heure de dernière modification | ✅ |

#### Constructeur

```dart
Note({
  required String id,
  required String title,
  required String content,
  required DateTime createdAt,
  required DateTime updatedAt,
})
```

**Paramètres :**
- `id` : Identifiant unique de la note
- `title` : Titre de la note
- `content` : Contenu de la note
- `createdAt` : Date de création
- `updatedAt` : Date de modification

#### Méthodes

##### `toJson()`
Convertit l'objet Note en format JSON pour la sérialisation.

**Retour :** `Map<String, dynamic>`

**Exemple :**
```dart
final note = Note(
  id: '1',
  title: 'Ma Note',
  content: 'Contenu de la note',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final json = note.toJson();
// Résultat: {
//   'id': '1',
//   'title': 'Ma Note',
//   'content': 'Contenu de la note',
//   'createdAt': '2023-01-01T00:00:00.000Z',
//   'updatedAt': '2023-01-01T00:00:00.000Z'
// }
```

##### `fromJson(Map<String, dynamic> json)`
Crée un objet Note à partir d'un JSON (factory constructor).

**Paramètres :**
- `json` : Map contenant les données JSON

**Retour :** `Note`

**Exemple :**
```dart
final json = {
  'id': '1',
  'title': 'Ma Note',
  'content': 'Contenu de la note',
  'createdAt': '2023-01-01T00:00:00.000Z',
  'updatedAt': '2023-01-01T00:00:00.000Z'
};

final note = Note.fromJson(json);
```

## 🔧 Services

### StorageService

Service de persistance des données utilisant SharedPreferences.

#### Méthodes

##### `saveNotes(List<Note> notes)`
Sauvegarde une liste de notes dans le stockage local.

**Paramètres :**
- `notes` : Liste des notes à sauvegarder

**Retour :** `Future<void>`

**Exemple :**
```dart
final storageService = StorageService();
final notes = [note1, note2, note3];
await storageService.saveNotes(notes);
```

**Gestion d'erreurs :**
- Aucune exception n'est levée, les erreurs sont gérées silencieusement

##### `loadNotes()`
Charge toutes les notes depuis le stockage local.

**Retour :** `Future<List<Note>>`

**Exemple :**
```dart
final storageService = StorageService();
final notes = await storageService.loadNotes();
print('${notes.length} notes chargées');
```

**Valeurs de retour :**
- Liste vide `[]` si aucune note n'est trouvée
- Liste des notes désérialisées si des données existent

### ThemeService

Service de gestion des préférences de thème.

#### Méthodes

##### `isDarkMode()`
Vérifie si le thème sombre est activé.

**Retour :** `Future<bool>`

**Exemple :**
```dart
final themeService = ThemeService();
final isDark = await themeService.isDarkMode();
if (isDark) {
  print('Thème sombre activé');
}
```

**Valeurs de retour :**
- `true` si le thème sombre est activé
- `false` si le thème clair est activé ou si aucune préférence n'est sauvegardée

##### `setDarkMode(bool isDark)`
Définit le mode de thème de l'application.

**Paramètres :**
- `isDark` : `true` pour activer le thème sombre, `false` pour le thème clair

**Retour :** `Future<void>`

**Exemple :**
```dart
final themeService = ThemeService();
await themeService.setDarkMode(true); // Active le thème sombre
```

## 🎨 Widgets

### CustomSearchBar

Widget de barre de recherche personnalisée avec icônes et animations.

#### Propriétés

| Propriété | Type | Description | Requis |
|-----------|------|-------------|--------|
| `hintText` | `String` | Texte d'indication affiché dans le champ | ✅ |
| `onChanged` | `ValueChanged<String>` | Callback appelé quand le texte change | ✅ |
| `onClear` | `VoidCallback?` | Callback appelé quand l'utilisateur efface | ❌ |
| `initialValue` | `String?` | Valeur initiale du champ | ❌ |

#### Exemple d'utilisation

```dart
CustomSearchBar(
  hintText: 'Rechercher dans vos notes...',
  onChanged: (query) {
    print('Recherche: $query');
  },
  onClear: () {
    print('Recherche effacée');
  },
  initialValue: 'Recherche initiale',
)
```

#### Callbacks

##### `onChanged(String query)`
Appelé à chaque modification du texte de recherche.

**Paramètres :**
- `query` : Nouveau texte de recherche

##### `onClear()`
Appelé quand l'utilisateur appuie sur le bouton d'effacement.

### FilterChips

Widget de puces de filtrage pour les notes.

#### Propriétés

| Propriété | Type | Description | Requis |
|-----------|------|-------------|--------|
| `selectedFilter` | `NoteFilter` | Filtre actuellement sélectionné | ✅ |
| `onFilterChanged` | `ValueChanged<NoteFilter>` | Callback appelé quand le filtre change | ✅ |

#### Exemple d'utilisation

```dart
FilterChips(
  selectedFilter: NoteFilter.all,
  onFilterChanged: (filter) {
    print('Filtre sélectionné: $filter');
  },
)
```

#### Énumération NoteFilter

```dart
enum NoteFilter {
  all,        // Toutes les notes
  recent,     // Notes récentes (7 derniers jours)
  old,        // Notes anciennes (plus de 7 jours)
  withTitle,  // Notes avec titre
  withoutTitle // Notes sans titre
}
```

## 📱 Écrans

### HomeScreen

Écran principal affichant la liste des notes avec fonctionnalités de recherche et filtrage.

#### Propriétés

| Propriété | Type | Description | Requis |
|-----------|------|-------------|--------|
| `onThemeToggle` | `VoidCallback` | Callback pour basculer le thème | ✅ |

#### Méthodes publiques

##### `_loadNotes()`
Charge toutes les notes depuis le stockage et met à jour l'interface.

**Retour :** `Future<void>`

##### `_applyFilters()`
Applique les filtres de recherche et de catégorie sur la liste des notes.

**Logique de filtrage :**
1. Filtre par texte de recherche (titre et contenu)
2. Filtre par catégorie (récentes, anciennes, avec/sans titre)
3. Met à jour la liste filtrée

##### `_formatDate(DateTime date)`
Formate une date en format relatif pour l'affichage.

**Paramètres :**
- `date` : Date à formater

**Retour :** `String`

**Formats de retour :**
- "Aujourd'hui à HH:MM" pour le même jour
- "Hier à HH:MM" pour la veille
- "Il y a X jours" pour cette semaine
- "DD/MM/YYYY" pour les dates plus anciennes

### NoteEditorScreen

Écran d'édition des notes permettant de créer ou modifier une note.

#### Propriétés

| Propriété | Type | Description | Requis |
|-----------|------|-------------|--------|
| `note` | `Note?` | Note à modifier (null pour nouvelle note) | ❌ |
| `storageService` | `dynamic` | Service de stockage (optionnel) | ❌ |

#### Méthodes publiques

##### `_saveNote()`
Sauvegarde la note dans le stockage local.

**Logique de sauvegarde :**
1. Crée ou met à jour l'objet Note
2. Charge la liste existante
3. Ajoute ou modifie la note
4. Sauvegarde la liste mise à jour
5. Affiche une confirmation
6. Retourne à l'écran précédent

**Gestion d'erreurs :**
- Affiche un SnackBar en cas d'erreur
- Log l'erreur pour le debugging

##### `_onTextChanged()`
Détecte les changements dans les champs de saisie.

**Comportement :**
- Active l'indicateur de modifications non sauvegardées
- Met à jour l'état du bouton de sauvegarde

## 🛠️ Utilitaires

### Formatage de Dates

#### `_formatDate(DateTime date)`
Formate une date en format relatif pour l'affichage utilisateur.

**Algorithme :**
1. Calcule la différence avec la date actuelle
2. Retourne le format approprié selon l'âge de la date

**Exemples :**
```dart
// Aujourd'hui à 14:30
_formatDate(DateTime.now()) // "Aujourd'hui à 14:30"

// Hier à 09:15
_formatDate(DateTime.now().subtract(Duration(days: 1))) // "Hier à 09:15"

// Il y a 3 jours
_formatDate(DateTime.now().subtract(Duration(days: 3))) // "Il y a 3 jours"

// Le 15/12/2022
_formatDate(DateTime(2022, 12, 15)) // "15/12/2022"
```

### Gestion des Filtres

#### Logique de Filtrage

**Filtre de recherche :**
```dart
filtered = filtered.where((note) {
  return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
         note.content.toLowerCase().contains(_searchQuery.toLowerCase());
}).toList();
```

**Filtre de catégorie :**
```dart
switch (_selectedFilter) {
  case NoteFilter.recent:
    filtered = filtered.where((note) {
      final difference = now.difference(note.updatedAt);
      return difference.inDays <= 7;
    }).toList();
    break;
  // ... autres cas
}
```

## 🔍 Exemples d'Utilisation

### Créer une Note

```dart
// Navigation vers l'éditeur
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NoteEditorScreen(note: null),
  ),
).then((_) => _loadNotes());
```

### Rechercher des Notes

```dart
// Configuration de la barre de recherche
CustomSearchBar(
  hintText: 'Rechercher dans vos notes...',
  onChanged: (query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  },
)
```

### Filtrer par Catégorie

```dart
// Configuration des puces de filtrage
FilterChips(
  selectedFilter: _selectedFilter,
  onFilterChanged: (filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilters();
  },
)
```

### Sauvegarder des Données

```dart
// Sauvegarde d'une liste de notes
final storageService = StorageService();
final notes = [note1, note2, note3];
await storageService.saveNotes(notes);
```

### Charger des Données

```dart
// Chargement des notes
final storageService = StorageService();
final notes = await storageService.loadNotes();
print('${notes.length} notes chargées');
```

## ⚠️ Gestion d'Erreurs

### Erreurs de Stockage
- Les erreurs de SharedPreferences sont gérées silencieusement
- Les données corrompues retournent une liste vide
- Les erreurs de sérialisation sont loggées

### Erreurs de Validation
- Les dates invalides sont gérées avec des valeurs par défaut
- Les chaînes vides sont acceptées pour le titre et le contenu
- Les IDs manquants génèrent des IDs uniques

### Erreurs d'Interface
- Les erreurs de navigation sont gérées avec des try-catch
- Les erreurs de build sont affichées dans la console
- Les erreurs de state sont gérées avec des vérifications

---

**Note** : Cette documentation est générée automatiquement et maintenue à jour avec le code source.
