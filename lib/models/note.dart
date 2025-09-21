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

  /// Constructeur de la classe Note
  /// Tous les paramètres sont requis pour créer une note valide
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convertit l'objet Note en format JSON
  /// Utilisé pour la sérialisation lors de la sauvegarde
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(), // Format ISO 8601 pour les dates
    'updatedAt': updatedAt.toIso8601String(),
  };

  /// Crée un objet Note à partir d'un JSON
  /// Utilisé pour la désérialisation lors du chargement
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    createdAt: DateTime.parse(
      json['createdAt'],
    ), // Parse la date depuis le format ISO
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
