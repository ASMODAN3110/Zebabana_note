import 'package:flutter/material.dart';
import 'screens/note_editor_screen.dart';
import 'services/storage_service.dart'; // Import pour accéder à StorageService
import 'models/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZeBabana Note',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StorageService _storageService;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _storageService = StorageService();
    _loadNotes(); // Charge les notes au démarrage
  }

  Future<void> _loadNotes() async {
    final notes = await _storageService.loadNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _deleteNote(String id) async {
    setState(() {
      _notes.removeWhere((note) => note.id == id); // Supprime localement
    });
    await _storageService.saveNotes(_notes); // Persiste la liste mise à jour
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note supprimée !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ZeBabana Note'),
        centerTitle: true,
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.note_add,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Bienvenue dans ZeBabana Note',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Appuyez sur le bouton + pour créer votre première note.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
  padding: const EdgeInsets.all(16.0),
  itemCount: _notes.length,
  itemBuilder: (context, index) {
    final note = _notes[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.content.length > 50
              ? '${note.content.substring(0, 50)}...'
              : note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditorScreen(note: note),
            ),
          ).then((_) => _loadNotes()); // Recharge après modification
        },
        trailing: Row( // Unique trailing avec heure et icône
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${note.updatedAt.toLocal().hour}:${note.updatedAt.toLocal().minute}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteNote(note.id),
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  },
),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(note: null),
            ),
          ).then((_) => _loadNotes()); // Recharge après création
        },
        tooltip: 'Nouvelle Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}


