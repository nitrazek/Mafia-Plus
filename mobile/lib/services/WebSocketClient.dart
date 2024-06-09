import 'dart:async';
import 'dart:convert';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/models/VotingStart.dart';
import 'package:mobile/models/VotingSummary.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/MinigameState.dart';
import 'package:mobile/state/RoomState.dart';
import 'package:mobile/state/AccountState.dart';
import 'package:mobile/state/VotingState.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:mobile/utils/Constants.dart' as Constants;
import '../models/GameEnd.dart';
import '../models/GameStart.dart';
import '../models/Room.dart';
import '../models/Round.dart';
import '../models/Score.dart';
import '../models/VotingEnd.dart';

class WebSocketClient {
  static WebSocketClient? _instance;
  StompClient? _stompClient;
  final List<void Function({Map<String, String>? unsubscribeHeaders})> _unsubscribeFunctions = [];

  final String baseUrl = "ws://${Constants.baseUrl}";

  final AccountState _accountState = AccountState();
  final RoomState _roomState = RoomState();
  final GameState _gameState = GameState();
  final MinigameState _minigameState = MinigameState();
  final VotingState _votingState = VotingState();

  WebSocketClient._internal();

  factory WebSocketClient() {
    _instance ??= WebSocketClient._internal();
    return _instance!;
  }

  Future<void> connect(int roomId) async {
    if (_stompClient != null && _stompClient!.connected) {
      return;
    }
    if (_accountState.currentAccount == null) {
      return;
    }

    Completer<void> connectionCompleter = Completer<void>();
    StompConfig config = StompConfig(
        url: "$baseUrl/ws",
        onConnect: (StompFrame frame) {
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/room",
            callback: (frame) {
              Map<String, dynamic> roomJson = jsonDecode(frame.body!);
              Room room = Room.fromJson(roomJson);
              _roomState.setRoom(room);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/user/queue/game-start",
            callback: (frame) {
              _gameState.setGameEnd(null);
              Map<String, dynamic> gameStartJson = jsonDecode(frame.body!);
              GameStart gameStart = GameStart.fromJson(gameStartJson);
              _gameState.setGame(gameStart);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/minigame-start",
            callback: (frame) {
              Map<String, dynamic> minigameStartJson = jsonDecode(frame.body!);
              MinigameStart minigameStart = MinigameStart.fromJson(minigameStartJson);
              _minigameState.setMinigame(minigameStart);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/user/queue/voting-start",
            callback: (frame) {
              _votingState.setVotingEnd(null);
              Map<String, dynamic> votingStartJson = jsonDecode(frame.body!);
              VotingStart votingStart = VotingStart.fromJson(votingStartJson);
              _votingState.setVoting(votingStart);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/voting-summary",
            callback: (frame) {
              _votingState.setVoting(null);
              Map<String, dynamic> votingSummaryJson = jsonDecode(frame.body!);
              VotingSummary votingSummary = VotingSummary.fromJson(votingSummaryJson);
              _votingState.setVotingSummary(votingSummary);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/user/queue/$roomId/voting-end",
            callback: (frame) {
              _votingState.setVotingSummary(null);
              Map<String, dynamic> votingEndJson = jsonDecode(frame.body!);
              VotingEnd votingEnd = VotingEnd.fromJson(votingEndJson);
              _votingState.setVotingEnd(votingEnd);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/game-end",
            callback: (frame) {
              _gameState.setGame(null);
              Map<String, dynamic> gameEndJson = jsonDecode(frame.body!);
              GameEnd gameEnd = GameEnd.fromJson(gameEndJson);
              _gameState.setGameEnd(gameEnd);
            }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
              destination: "/topic/$roomId/minigame-summary",
              callback: (frame) {
                _minigameState.setScores(null);
                Map<String, dynamic> scoreEndJson = jsonDecode(frame.body!);
                Score highestScore = Score.fromJson(scoreEndJson);
                _minigameState.setScores(highestScore);
              }
          ));
          _unsubscribeFunctions.add(_stompClient!.subscribe(
            destination: "/topic/$roomId/reward",
              callback: (frame) {
              _minigameState.setReward(null);
              String rewardName =frame.body!;
              _minigameState.setReward(rewardName);
              }
          ));

          connectionCompleter.complete();
        },
        onDisconnect: (StompFrame frame) {
          print("disconnected");
        },
        stompConnectHeaders: {
          'login': _accountState.currentAccount!.username,
          'passcode': _accountState.currentAccount!.password
        }
    );
    _stompClient = StompClient(config: config);
    _stompClient?.activate();

    return connectionCompleter.future;
  }

  void unsubscribeAll() {
    for(var unsubscribeFn in _unsubscribeFunctions) {
      unsubscribeFn(unsubscribeHeaders: {});
    }
    _unsubscribeFunctions.clear();
  }

  void disconnect() {
    unsubscribeAll();
    _stompClient?.deactivate();
  }
}
