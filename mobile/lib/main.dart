import 'package:flutter/material.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/RoomState.dart';
import 'package:mobile/state/VotingState.dart';
import 'package:mobile/viewModels/UserRoleViewModel.dart';
import 'package:mobile/viewModels/VotedViewModel.dart';
import 'package:mobile/viewModels/VotingResultsViewModel.dart';
import 'package:mobile/viewModels/WaitingViewModel.dart';
import 'package:mobile/viewModels/WinnerViewModel.dart';
import 'package:mobile/views/GameHistory.dart';
import 'package:mobile/viewModels/JoinPrivateRoomViewModel.dart';
import 'package:mobile/viewModels/MenuViewModel.dart';
import 'package:mobile/viewModels/RoomSettingsViewModel.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'package:mobile/views/MinigameResult.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/LoginViewModel.dart';
import 'package:mobile/viewModels/RegisterViewModel.dart';
import 'package:mobile/views/Login.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mobile/viewModels/PublicRoomsViewModel.dart';
import 'package:mobile/views/Register.dart';
import 'package:mobile/viewModels/GameHistoryViewModel.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

void main() {
  RoomState(); GameState(); VotingState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
        ChangeNotifierProvider(create: (context) => JoinPrivateRoomViewModel()),
        ChangeNotifierProvider(create: (context) => PublicRoomsViewModel()),
        ChangeNotifierProvider(create: (context) => RoomSettingsViewModel()),
        ChangeNotifierProvider(create: (context) => GameHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => RoomViewModel()),
        ChangeNotifierProvider(create: (context) => UserRoleViewModel()),
        ChangeNotifierProvider(create: (context) => VotingViewModel()),
        ChangeNotifierProvider(create: (context) => WaitingViewModel()),
        ChangeNotifierProvider(create: (context) => VotingResultsViewModel()),
        ChangeNotifierProvider(create: (context) => VotedViewModel()),
        ChangeNotifierProvider(create: (context) => WinnerViewModel())
      ],
      child: const MaterialApp(
        title: 'MAFIA+',
        home: LoginPage(),
      ),
    );
  }
}
