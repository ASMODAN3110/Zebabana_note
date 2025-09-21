// Import des packages Flutter et des modules de l'application
import 'package:flutter/material.dart';
import 'screens/note_editor_screen.dart';
import 'services/storage_service.dart';
import 'services/theme_service.dart';
import 'models/note.dart';
import 'widgets/search_bar.dart' as search_widget;
import 'widgets/filter_chips.dart';

/// Point d'entrée principal de l'application ZeBabana Note
/// Lance l'application Flutter avec le widget racine MyApp
void main() {
  runApp(const MyApp());
}

/// Widget racine de l'application ZeBabana Note
/// Gère la configuration globale de l'application, les thèmes et la navigation
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// État de l'application principale
/// Gère le thème sombre/clair et la configuration de l'application
class _MyAppState extends State<MyApp> {
  // Service de gestion des thèmes pour persister les préférences utilisateur
  final ThemeService _themeService = ThemeService();

  // État du thème : true = sombre, false = clair
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Charger le thème sauvegardé au démarrage de l'application
    _loadTheme();
  }

  /// Charge le thème sauvegardé depuis les préférences utilisateur
  /// Met à jour l'état de l'application avec le thème approprié
  Future<void> _loadTheme() async {
    final isDark = await _themeService.isDarkMode();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  /// Bascule entre le thème sombre et clair
  /// Sauvegarde la préférence utilisateur et met à jour l'interface
  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await _themeService.setDarkMode(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZeBabana Note',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo moderne
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo moderne
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onThemeToggle: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Écran principal de l'application ZeBabana Note
/// Affiche la liste des notes avec fonctionnalités de recherche et filtrage
class HomeScreen extends StatefulWidget {
  /// Callback pour basculer entre thème sombre et clair
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// État de l'écran principal
/// Gère la liste des notes, la recherche, le filtrage et les interactions utilisateur
class _HomeScreenState extends State<HomeScreen> {
  // Service de stockage pour persister les notes
  late final StorageService _storageService;

  // Liste complète des notes
  List<Note> _notes = [];

  // Liste des notes filtrées selon les critères de recherche et filtrage
  List<Note> _filteredNotes = [];

  // État de chargement des données
  bool _isLoading = true;

  // Requête de recherche saisie par l'utilisateur
  String _searchQuery = '';

  // Filtre actuellement sélectionné
  NoteFilter _selectedFilter = NoteFilter.all;

  @override
  void initState() {
    super.initState();
    // Initialiser le service de stockage et charger les notes
    _storageService = StorageService();
    _loadNotes();
  }

  /// Charge toutes les notes depuis le stockage local
  /// Met à jour l'état de chargement et applique les filtres
  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });
    final notes = await _storageService.loadNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
    // Appliquer les filtres après le chargement
    _applyFilters();
  }

  /// Applique les filtres de recherche et de catégorie sur la liste des notes
  /// Met à jour la liste filtrée affichée à l'utilisateur
  void _applyFilters() {
    // Créer une copie de la liste des notes pour le filtrage
    List<Note> filtered = List.from(_notes);

    // Appliquer le filtre de recherche textuelle
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Appliquer le filtre de catégorie selon le type sélectionné
    final now = DateTime.now();
    switch (_selectedFilter) {
      case NoteFilter.all:
        // Afficher toutes les notes
        break;
      case NoteFilter.recent:
        // Afficher seulement les notes des 7 derniers jours
        filtered = filtered.where((note) {
          final difference = now.difference(note.updatedAt);
          return difference.inDays <= 7;
        }).toList();
        break;
      case NoteFilter.old:
        // Afficher seulement les notes plus anciennes que 7 jours
        filtered = filtered.where((note) {
          final difference = now.difference(note.updatedAt);
          return difference.inDays > 7;
        }).toList();
        break;
      case NoteFilter.withTitle:
        // Afficher seulement les notes qui ont un titre
        filtered = filtered.where((note) => note.title.isNotEmpty).toList();
        break;
      case NoteFilter.withoutTitle:
        // Afficher seulement les notes sans titre
        filtered = filtered.where((note) => note.title.isEmpty).toList();
        break;
    }

    // Mettre à jour l'interface avec la liste filtrée
    setState(() {
      _filteredNotes = filtered;
    });
  }

  /// Gère les changements dans la barre de recherche
  /// Met à jour la requête de recherche et applique les filtres
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  /// Gère les changements de filtre de catégorie
  /// Met à jour le filtre sélectionné et applique les filtres
  void _onFilterChanged(NoteFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilters();
  }

  /// Formate une date en format relatif pour l'affichage utilisateur
  /// Retourne "Aujourd'hui", "Hier", "Il y a X jours" ou la date complète
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Même jour : afficher l'heure
      return 'Aujourd\'hui à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Hier : afficher "Hier" avec l'heure
      return 'Hier à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      // Cette semaine : afficher le nombre de jours
      return 'Il y a ${difference.inDays} jours';
    } else {
      // Plus ancien : afficher la date complète
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Supprime une note de la liste et du stockage
  /// Affiche une confirmation à l'utilisateur
  Future<void> _deleteNote(String id) async {
    // Retirer la note de la liste locale
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });

    // Sauvegarder la liste mise à jour
    await _storageService.saveNotes(_notes);

    // Appliquer les filtres pour mettre à jour l'affichage
    _applyFilters();

    // Afficher une confirmation à l'utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note supprimée !'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.note_alt, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'ZeBabana Note',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Changer le thème',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.1),
                            theme.colorScheme.secondary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.note_add_outlined,
                        size: 96,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Bienvenue dans ZeBabana Note',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Commencez à capturer vos idées et pensées\nen créant votre première note.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NoteEditorScreen(note: null),
                          ),
                        ).then((_) => _loadNotes());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Créer ma première note'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                search_widget.CustomSearchBar(
                  hintText: 'Rechercher dans vos notes...',
                  onChanged: _onSearchChanged,
                ),
                FilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                ),
                Expanded(
                  child: _filteredNotes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Aucune note trouvée pour "$_searchQuery"'
                                    : 'Aucune note ne correspond au filtre sélectionné',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_searchQuery.isNotEmpty ||
                                  _selectedFilter != NoteFilter.all)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _searchQuery = '';
                                        _selectedFilter = NoteFilter.all;
                                      });
                                      _applyFilters();
                                    },
                                    icon: const Icon(Icons.clear_all),
                                    label: const Text('Effacer les filtres'),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = _filteredNotes[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteEditorScreen(note: note),
                                      ),
                                    ).then((_) => _loadNotes());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: theme.colorScheme.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.note,
                                                size: 20,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                note.title.isEmpty
                                                    ? 'Note sans titre'
                                                    : note.title,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            PopupMenuButton<String>(
                                              onSelected: (value) {
                                                if (value == 'delete') {
                                                  _showDeleteDialog(note.id);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Supprimer'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              child: Icon(
                                                Icons.more_vert,
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          note.content.isEmpty
                                              ? 'Aucun contenu'
                                              : note.content.length > 120
                                              ? '${note.content.substring(0, 120)}...'
                                              : note.content,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                height: 1.4,
                                              ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withOpacity(0.7),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _formatDate(note.updatedAt),
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant
                                                        .withOpacity(0.7),
                                                  ),
                                            ),
                                            const Spacer(),
                                            if (note.content.isNotEmpty)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '${note.content.length} caractères',
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteEditorScreen(note: null),
              ),
            ).then((_) => _loadNotes());
          },
          icon: const Icon(Icons.add),
          label: const Text('Nouvelle Note'),
          tooltip: 'Créer une nouvelle note',
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showDeleteDialog(String noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la note'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer cette note ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNote(noteId);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
