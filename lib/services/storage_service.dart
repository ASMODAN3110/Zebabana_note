// Import des packages nécessaires pour la sérialisation et le stockage local
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

/// Service de stockage local pour les notes
/// Utilise SharedPreferences pour persister les données de l'application
class StorageService {
  /// Clé utilisée pour stocker les notes dans SharedPreferences
  static const String _notesKey = 'notes';

  /// Sauvegarde une liste de notes dans le stockage local
  /// Convertit les notes en JSON et les stocke dans SharedPreferences
  ///
  /// [notes] - Liste des notes à sauvegarder
  Future<void> saveNotes(List<Note> notes) async {
    // Obtenir l'instance de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Convertir chaque note en JSON
    final notesJson = notes.map((note) => note.toJson()).toList();

    // Encoder la liste en JSON et la sauvegarder
    await prefs.setString(_notesKey, jsonEncode(notesJson));
  }

  /// Charge toutes les notes depuis le stockage local
  /// Désérialise les données JSON en objets Note
  ///
  /// Retourne une liste vide si aucune note n'est trouvée
  Future<List<Note>> loadNotes() async {
    // Obtenir l'instance de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Récupérer la chaîne JSON des notes
    final notesString = prefs.getString(_notesKey);

    // Retourner une liste vide si aucune donnée n'est trouvée
    if (notesString == null) return [];

    // Décoder le JSON en liste d'objets
    final notesList = jsonDecode(notesString) as List;

    // Convertir chaque objet JSON en objet Note
    return notesList.map((json) => Note.fromJson(json)).toList();
  }
}
