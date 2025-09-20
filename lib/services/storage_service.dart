import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart'; // Importe la classe Note

class StorageService {
  static const String _notesKey = 'notes';
 // Sauvegarde des notes dans SharedPreferences
 Future<void> saveNotes(List<Note> notes) async {
 final prefs = await SharedPreferences.getInstance();
 final notesJson = notes.map((note) => note.toJson()).toList();
 await prefs.setString(_notesKey, jsonEncode(notesJson));
 }

 // Chargement des notes depuis SharedPreferences
 Future<List<Note>> loadNotes() async {
 final prefs = await SharedPreferences.getInstance();
 final notesString = prefs.getString(_notesKey);
 if (notesString == null) return [];
 final notesList = jsonDecode(notesString) as List;
 return notesList.map((json) => Note.fromJson(json)).toList();
 }
 }