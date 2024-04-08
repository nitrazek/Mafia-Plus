// Mocks generated by Mockito 5.4.4 from annotations
// in mobile/test/widgetTest/VotingResultsTest.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:ui' as _i4;

import 'package:mobile/viewModels/RoomViewModel.dart' as _i5;
import 'package:mobile/viewModels/VotingResultsViewModel.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [VotingResultsViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockVotingResultsViewModel extends _i1.Mock
    implements _i2.VotingResultsViewModel {
  MockVotingResultsViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<void> get votingFinished => (super.noSuchMethod(
        Invocation.getter(#votingFinished),
        returnValue: _i3.Stream<void>.empty(),
      ) as _i3.Stream<void>);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  void addListener(_i4.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i4.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [RoomViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockRoomViewModel extends _i1.Mock implements _i5.RoomViewModel {
  MockRoomViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get messageError => (super.noSuchMethod(
        Invocation.getter(#messageError),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#messageError),
        ),
      ) as String);

  @override
  set messageError(String? _messageError) => super.noSuchMethod(
        Invocation.setter(
          #messageError,
          _messageError,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isHost => (super.noSuchMethod(
        Invocation.getter(#isHost),
        returnValue: false,
      ) as bool);

  @override
  _i3.Stream<void> get gameStarted => (super.noSuchMethod(
        Invocation.getter(#gameStarted),
        returnValue: _i3.Stream<void>.empty(),
      ) as _i3.Stream<void>);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i3.Future<void> startGame(
    int? roomId,
    void Function()? onSuccess,
    void Function()? onError,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #startGame,
          [
            roomId,
            onSuccess,
            onError,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> leaveRoom(
    void Function()? onSuccess,
    void Function()? onError,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #leaveRoom,
          [
            onSuccess,
            onError,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  void openGameSettings() => super.noSuchMethod(
        Invocation.method(
          #openGameSettings,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i4.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i4.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
