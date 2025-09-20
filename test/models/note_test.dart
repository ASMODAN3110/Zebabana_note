import 'package:test/test.dart';
import 'package:zebabana_note/models/note.dart';

void main() {
  group('Note toJson', () {
    test('should convert Note to JSON map with correct values', () {
      // Arrange
      final now = DateTime.now();
      final note = Note(
        id: '1',
        title: 'Test Note',
        content: 'This is a test note content',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final jsonMap = note.toJson();

      // Assert
      expect(jsonMap['id'], equals('1'));
      expect(jsonMap['title'], equals('Test Note'));
      expect(jsonMap['content'], equals('This is a test note content'));
      expect(jsonMap['createdAt'], equals(now.toIso8601String()));
      expect(jsonMap['updatedAt'], equals(now.toIso8601String()));
      expect(jsonMap, isA<Map<String, dynamic>>());
    });

    test('should handle different dates correctly', () {
      // Arrange
      final createdAt = DateTime(2025, 9, 19, 10, 0, 0);
      final updatedAt = DateTime(2025, 9, 20, 7, 3, 0); // 07:03 AM WAT, 20 Sept 2025
      final note = Note(
        id: '2',
        title: 'Another Note',
        content: 'Different dates test',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Act
      final jsonMap = note.toJson();

      // Assert
      expect(jsonMap['id'], equals('2'));
      expect(jsonMap['title'], equals('Another Note'));
      expect(jsonMap['content'], equals('Different dates test'));
      expect(jsonMap['createdAt'], equals(createdAt.toIso8601String()));
      expect(jsonMap['updatedAt'], equals(updatedAt.toIso8601String()));
    });
  });


  group('Note fromJson', () {
    test('should create a Note from valid JSON map', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Note',
        'content': 'This is a test note content',
        'createdAt': '2025-09-19T10:00:00.000Z',
        'updatedAt': '2025-09-20T07:10:00.000Z', // 07:10 AM WAT, 20 Sept 2025
      };

      // Act
      final note = Note.fromJson(json);

      // Assert
      expect(note.id, equals('1'));
      expect(note.title, equals('Test Note'));
      expect(note.content, equals('This is a test note content'));
      expect(note.createdAt, equals(DateTime.parse('2025-09-19T10:00:00.000Z')));
      expect(note.updatedAt, equals(DateTime.parse('2025-09-20T07:10:00.000Z')));
      expect(note, isA<Note>());
    });

    test('should throw FormatException for invalid date formats', () {
      // Arrange
      final json = {
        'id': '2',
        'title': 'Invalid Date Note',
        'content': 'Test with invalid date',
        'createdAt': 'invalid-date',
        'updatedAt': '2025-09-20T07:10:00.000Z',
      };

      // Act & Assert
      expect(() => Note.fromJson(json), throwsFormatException);
    });
  });
}