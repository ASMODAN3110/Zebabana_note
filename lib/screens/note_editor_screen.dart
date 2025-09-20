import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  final dynamic storageService;

  const NoteEditorScreen({super.key, this.note, this.storageService});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late final dynamic _storageService;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? StorageService();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
  try {
    print('Début sauvegarde à ${DateTime.now()}');
    final id = widget.note?.id ?? UniqueKey().toString();
    final now = DateTime.now();
    final note = Note(
      id: id,
      title: _titleController.text,
      content: _contentController.text,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );
    print('Note créée : ${note.toJson()}');
    final notes = await _storageService.loadNotes();
    print('Notes chargées : $notes');
    if (widget.note == null) {
      notes.add(note);
    } else {
      final index = notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        notes[index] = note;
      } else {
        print('Erreur : Note avec ID $id non trouvée');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : Note non trouvée')),
        );
        return;
      }
    }
    print('Notes avant sauvegarde : $notes');
    await _storageService.saveNotes(notes);
    print('Sauvegarde terminée');
    // Ajout du feedback utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.note != null ? 'Note mise à jour !' : 'Note créée !'),
        duration: const Duration(seconds: 2), // Affiche 2 secondes
      ),
    );
    Navigator.pop(context);
  } catch (e) {
    print('Erreur lors de la sauvegarde : $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : $e')),
    );
  }
}

  @override
Widget build(BuildContext context) {
  final title = widget.note != null ? 'Modifier Note' : 'Nouvelle Note'; // Titre dynamique
  return Scaffold(
    appBar: AppBar(
      title: Text(title), // Utilise le titre dynamique
      actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveNote)],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titre'),
          ),
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(labelText: 'Contenu'),
            ),
          ),
        ],
      ),
    ),
  );
}
}
