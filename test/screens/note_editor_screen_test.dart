import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zebabana_note/models/note.dart';
import 'package:zebabana_note/screens/note_editor_screen.dart';
import 'package:mockito/mockito.dart';
import 'note_editor_screen_test.mocks.dart';

class MockRoute extends Mock implements Route<dynamic> {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('NoteEditorScreen initState', () {
    testWidgets(
      'should initialize controllers with note values when note is provided',
      (WidgetTester tester) async {
        // Arrange
        final note = Note(
          id: '1',
          title: 'Existing Note',
          content: 'This is an existing note content',
          createdAt: DateTime(2025, 9, 19),
          updatedAt: DateTime(2025, 9, 20, 7, 26), // 07:26 AM WAT, 20 Sept 2025
        );
        await tester.pumpWidget(
          MaterialApp(home: NoteEditorScreen(note: note)),
        );

        // Act & Assert
        expect(find.widgetWithText(TextField, 'Existing Note'), findsOneWidget);
        expect(
          find.widgetWithText(TextField, 'This is an existing note content'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should initialize controllers with empty values when no note is provided',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(home: NoteEditorScreen()));

        // Act & Assert
        final titleFinder = find.widgetWithText(TextField, '').first;
        final contentFinder = find.widgetWithText(TextField, '').last;
        final titleField = tester.widget<TextField>(titleFinder);
        final contentField = tester.widget<TextField>(contentFinder);
        expect(titleField.controller!.text, isEmpty);
        expect(contentField.controller!.text, isEmpty);
      },
    );
  });

  group('NoteEditorScreen _saveNote', () {
    late MockStorageService mockStorageService;
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockStorageService = MockStorageService();
      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets('should create and save a new note when no note is provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final now = DateTime(2025, 9, 20, 8, 15); // 08:15 AM WAT, 20 Sept 2025
      when(mockStorageService.loadNotes()).thenAnswer((_) async => <Note>[]);
      when(mockStorageService.saveNotes(any)).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockNavigatorObserver],
          home: NoteEditorScreen(
            note: null,
            storageService: mockStorageService,
          ),
        ),
      );
      // Remplir les champs (ajuste les index si nécessaire)
      await tester.enterText(find.byType(TextField).at(0), 'New Note');
      await tester.enterText(find.byType(TextField).at(1), 'New content');
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Assert
      // Vérifier les paramètres passés à saveNotes
      final capturedNotes = verify(
        mockStorageService.saveNotes(captureAny),
      ).captured;
      expect(capturedNotes.length, 1);
      final savedNotes = capturedNotes.single as List<Note>;
      expect(savedNotes.length, 1);
      final savedNote = savedNotes.first;
      expect(savedNote.id, isNotNull);
      expect(savedNote.title, 'New Note');
      expect(savedNote.content, 'New content');
      expect(savedNote.createdAt, isA<DateTime>());
      expect(savedNote.updatedAt, isA<DateTime>());
    });

    testWidgets('should update an existing note when note is provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final existingNote = Note(
        id: '1',
        title: 'Old Note',
        content: 'Old content',
        createdAt: DateTime(2025, 9, 19),
        updatedAt: DateTime(2025, 9, 19),
      );
      final now = DateTime(2025, 9, 20, 8, 15); // 08:15 AM WAT, 20 Sept 2025
      when(
        mockStorageService.loadNotes(),
      ).thenAnswer((_) async => [existingNote]);
      when(mockStorageService.saveNotes(any)).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockNavigatorObserver],
          home: NoteEditorScreen(
            note: existingNote,
            storageService: mockStorageService,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).at(0), 'Updated Note');
      await tester.enterText(find.byType(TextField).at(1), 'Updated content');
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Assert
      // Vérifier les paramètres passés à saveNotes
      final capturedNotes = verify(
        mockStorageService.saveNotes(captureAny),
      ).captured;
      expect(capturedNotes.length, 1);
      final savedNotes = capturedNotes.single as List<Note>;
      expect(savedNotes.length, 1);
      final updatedNote = savedNotes.first;
      expect(updatedNote.id, '1');
      expect(updatedNote.title, 'Updated Note');
      expect(updatedNote.content, 'Updated content');
      expect(updatedNote.createdAt, existingNote.createdAt);
      expect(updatedNote.updatedAt, isA<DateTime>());
    });
  });

  group('NoteEditorScreen build method', () {
    late MockStorageService mockStorageService;

    setUp(() {
      mockStorageService = MockStorageService();
    });

    testWidgets(
      'should build scaffold with title and text fields when no note is provided',
      (WidgetTester tester) async {
        // Arrange
        final now = DateTime(2025, 9, 20, 8, 43); // 08:43 AM WAT, 20 Sept 2025
        when(mockStorageService.loadNotes()).thenAnswer((_) async => <Note>[]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: NoteEditorScreen(
              storageService: mockStorageService,
              note: null,
            ),
          ),
        );

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Nouvelle Note'), findsOneWidget);
        expect(find.byIcon(Icons.save), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.text('Titre'), findsOneWidget);
        expect(find.text('Contenu'), findsOneWidget);
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);

        // Vérifie que les TextFields sont vides quand note est null
        final titleField = tester.widget<TextField>(
          find.byType(TextField).first,
        );
        final contentField = tester.widget<TextField>(
          find.byType(TextField).last,
        );
        expect(titleField.controller!.text, '');
        expect(contentField.controller!.text, '');
      },
    );

    testWidgets(
      'should build scaffold with prefilled text fields when note is provided',
      (WidgetTester tester) async {
        // Arrange
        final existingNote = Note(
          id: '1',
          title: 'Old Title',
          content: 'Old Content',
          createdAt: DateTime(2025, 9, 19),
          updatedAt: DateTime(2025, 9, 19),
        );
        when(
          mockStorageService.loadNotes(),
        ).thenAnswer((_) async => [existingNote]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: NoteEditorScreen(
              storageService: mockStorageService,
              note: existingNote,
            ),
          ),
        );

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Nouvelle Note'), findsOneWidget);
        expect(find.byIcon(Icons.save), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.text('Titre'), findsOneWidget);
        expect(find.text('Contenu'), findsOneWidget);
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);

        // Vérifie que les TextFields sont préremplis avec les données de la note
        final titleField = tester.widget<TextField>(
          find.byType(TextField).first,
        );
        final contentField = tester.widget<TextField>(
          find.byType(TextField).last,
        );
        expect(titleField.controller!.text, 'Old Title');
        expect(contentField.controller!.text, 'Old Content');
      },
    );
  });
}
