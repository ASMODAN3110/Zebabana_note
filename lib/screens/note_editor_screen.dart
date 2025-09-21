// Import des packages Flutter et des modules de l'application
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

/// Écran d'édition des notes
/// Permet de créer une nouvelle note ou de modifier une note existante
class NoteEditorScreen extends StatefulWidget {
  /// Note à modifier (null pour une nouvelle note)
  final Note? note;

  /// Service de stockage (optionnel, utilise StorageService par défaut)
  final dynamic storageService;

  const NoteEditorScreen({super.key, this.note, this.storageService});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

/// État de l'écran d'édition des notes
/// Gère la saisie, la validation et la sauvegarde des notes
class _NoteEditorScreenState extends State<NoteEditorScreen> {
  // Contrôleur pour le champ de saisie du titre
  final _titleController = TextEditingController();

  // Contrôleur pour le champ de saisie du contenu
  final _contentController = TextEditingController();

  // Service de stockage pour persister les notes
  late final dynamic _storageService;

  // Indique si des modifications ont été apportées à la note
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Initialiser le service de stockage
    _storageService = widget.storageService ?? StorageService();

    // Si on modifie une note existante, pré-remplir les champs
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    // Écouter les changements dans les champs de saisie
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  /// Détecte les changements dans les champs de saisie
  /// Active l'indicateur de modifications non sauvegardées
  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  /// Sauvegarde la note dans le stockage local
  /// Crée une nouvelle note ou met à jour une note existante
  Future<void> _saveNote() async {
    try {
      // Générer un ID unique pour une nouvelle note ou utiliser l'ID existant
      final id = widget.note?.id ?? UniqueKey().toString();
      final now = DateTime.now();

      // Créer l'objet Note avec les données saisies
      final note = Note(
        id: id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt:
            widget.note?.createdAt ??
            now, // Conserver la date de création pour les notes existantes
        updatedAt: now, // Toujours mettre à jour la date de modification
      );

      // Charger la liste des notes existantes
      final notes = await _storageService.loadNotes();

      if (widget.note == null) {
        // Ajouter une nouvelle note à la liste
        notes.add(note);
      } else {
        // Mettre à jour une note existante
        final index = notes.indexWhere((n) => n.id == id);
        if (index != -1) {
          notes[index] = note;
        }
      }

      // Sauvegarder la liste mise à jour
      await _storageService.saveNotes(notes);

      // Désactiver l'indicateur de modifications
      setState(() {
        _hasChanges = false;
      });

      // Afficher une confirmation à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.note != null ? 'Note mise à jour !' : 'Note créée !',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Retourner à l'écran précédent
      Navigator.pop(context);
    } catch (e) {
      // Afficher une erreur en cas de problème de sauvegarde
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.note != null ? 'Modifier Note' : 'Nouvelle Note';

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
              child: const Icon(Icons.edit_note, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _hasChanges
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.save,
                color: _hasChanges
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: _hasChanges ? _saveNote : null,
              tooltip: 'Sauvegarder',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _titleController,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Titre de la note',
                    hintText: 'Donnez un titre à votre note...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                      0.3,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.title,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    decoration: InputDecoration(
                      labelText: 'Contenu de votre note',
                      hintText:
                          'Commencez à écrire vos idées, pensées, ou tout ce qui vous passe par la tête...\n\n💡 Conseil : Utilisez des puces (•) pour organiser vos idées\n📝 Ajoutez des titres avec # pour structurer votre contenu',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                        0.3,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_note,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_hasChanges)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Vous avez des modifications non sauvegardées',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _hasChanges
          ? Container(
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
                onPressed: _saveNote,
                tooltip: 'Sauvegarder',
                icon: const Icon(Icons.save),
                label: const Text('Sauvegarder'),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
