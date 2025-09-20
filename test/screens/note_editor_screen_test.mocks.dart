// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MockitoGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import '../../lib/models/note.dart' as _i4;
import '../../lib/services/storage_service.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeStorageService_0 extends _i1.SmartFake implements _i2.StorageService {
  _FakeStorageService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [StorageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageService extends _i1.Mock implements _i2.StorageService {
  MockStorageService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.Note>> loadNotes() => (super.noSuchMethod(
        Invocation.method(
          #loadNotes,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Note>>.value(<_i4.Note>[]),
      ) as _i3.Future<List<_i4.Note>>);

  @override
  _i3.Future<void> saveNotes(List<_i4.Note>? notes) => (super.noSuchMethod(
        Invocation.method(
          #saveNotes,
          [notes],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}