class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id, 
    required this.title, 
    required this.content, 
    required this.createdAt,
    required this.updatedAt
  });

// Convertir Note en JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // Créer une Note à partir de JSON
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

}
