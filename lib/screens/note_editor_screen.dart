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
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? StorageService();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveNote() async {
    try {
      final id = widget.note?.id ?? UniqueKey().toString();
      final now = DateTime.now();
      final note = Note(
        id: id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: widget.note?.createdAt ?? now,
        updatedAt: now,
      );

      final notes = await _storageService.loadNotes();
      if (widget.note == null) {
        notes.add(note);
      } else {
        final index = notes.indexWhere((n) => n.id == id);
        if (index != -1) {
          notes[index] = note;
        }
      }
      await _storageService.saveNotes(notes);
      
      setState(() {
        _hasChanges = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.note != null ? 'Note mise à jour !' : 'Note créée !'),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.note != null ? 'Modifier Note' : 'Nouvelle Note';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: _hasChanges ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: _saveNote,
            tooltip: 'Sauvegarder',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: theme.textTheme.titleLarge,
              decoration: InputDecoration(
                labelText: 'Titre de la note',
                hintText: 'Entrez le titre...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Contenu',
                  hintText: 'Écrivez votre note ici...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 200),
                    child: Icon(Icons.edit_note),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _hasChanges
          ? FloatingActionButton(
              onPressed: _saveNote,
              tooltip: 'Sauvegarder',
              child: const Icon(Icons.save),
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
