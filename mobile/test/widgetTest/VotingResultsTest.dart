import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/models/VotingResult.dart';
import 'package:mobile/models/VotingSummary.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'package:mobile/viewModels/VotingResultsViewModel.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'VotingResultsTest.mocks.dart';

@GenerateMocks([VotingResultsViewModel, RoomViewModel])
void main() {
  late MockVotingResultsViewModel mockVotingResultsViewModel;
  late MockRoomViewModel mockRoomViewModel;

  setUp(() {
    mockVotingResultsViewModel = MockVotingResultsViewModel();
    mockRoomViewModel = MockRoomViewModel();
  });

  testWidgets('VotingResults updates when VotingViewModel updates votingSummary', (WidgetTester tester) async {
    VotingSummary votingSummary = VotingSummary(votingResults: [
      VotingResult(username: "user1", voteCount: 1),
      VotingResult(username: "user2", voteCount: 2),
      VotingResult(username: "user3", voteCount: 3),
    ]);
    Room room = Room(
      id: 1,
      accountUsernames: ["user1", "user2", "user3"],
      hostUsername: "user1",
      accessCode: "0000001",
      roomSettings: RoomSettings(
        isPublic: true,
        numberOfPlayers: 10
      )
    );
    when(mockVotingResultsViewModel.votingSummary).thenReturn(votingSummary);
    when(mockRoomViewModel.room).thenReturn(room);
    when(mockRoomViewModel.isHost).thenReturn(true);
    when(mockRoomViewModel.gameStarted).thenAnswer((_) => StreamController<void>.broadcast().stream);

    await tester.pumpWidget(
      ChangeNotifierProvider<RoomViewModel>(
        create: (_) => mockRoomViewModel,
        child: ChangeNotifierProvider<VotingResultsViewModel>(
          create: (_) => mockVotingResultsViewModel,
          child: const MaterialApp(
            home: VotingResultsPage(),
          ),
        ),
      ),
    );

    expect(find.text('Voting Results'), findsOneWidget);
    for (var i = 0; i < votingSummary.votingResults.length; i++) {
      final result = votingSummary.votingResults[i];
      expect(find.text(result.username), findsOneWidget);
      expect(find.text('Votes: ${result.voteCount}'), findsOneWidget);
    }

    await tester.pump(const Duration(seconds: 8));
  });
}