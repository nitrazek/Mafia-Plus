import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:mobile/models/VotingResult.dart';
import 'package:mobile/models/VotingSummary.dart';
import 'package:mobile/utils/CustomHttpClient.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:mobile/utils/Constants.dart' as Constants;
import '../models/GameStart.dart';
import '../models/Room.dart';
import '../models/Round.dart';

class WebSocketClient {
  static WebSocketClient? _instance;
  StompClient? _stompClient;
  late int roomId;
  late String username;
  late String password;

  final String baseUrl = "ws://${Constants.baseUrl}";

  final _roomUpdate = StreamController<Room>();
  Stream<Room> get roomUpdate => _roomUpdate.stream;
  Room? lastRoomUpdate;

  final _gameStartUpdate = StreamController<GameStart>();
  Stream<GameStart> get gameStartUpdate => _gameStartUpdate.stream;
  GameStart? lastGameStartUpdate;

  final _roundStartUpdate = StreamController<Round>();
  Stream<Round> get roundStartUpdate => _roundStartUpdate.stream;
  Round? lastRoundStartUpdate;

  final _votingSummaryUpdate = StreamController<VotingSummary>.broadcast();
  Stream<VotingSummary> get votingSummaryUpdate => _votingSummaryUpdate.stream;
  VotingSummary? lastVotingSummary;

  WebSocketClient._internal();

  factory WebSocketClient() {
    _instance ??= WebSocketClient._internal();
    return _instance!;
  }

  void setCredentials(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Future<void> connect(int roomId) async {
    if (_stompClient != null && _stompClient!.connected) {
      return;
    }

    Completer<void> connectionCompleter = Completer<void>();
    StompConfig config = StompConfig(
        url: "$baseUrl/ws",
        onConnect: (StompFrame frame) {
          _stompClient?.subscribe(
            destination: "/topic/$roomId/room",
            callback: (frame) {
              Map<String, dynamic> roomJson = jsonDecode(frame.body!);
              Room room = Room.fromJson(roomJson);
              lastRoomUpdate = room;
              _roomUpdate.add(room);
            }
          );
          _stompClient?.subscribe(
              destination: "/user/queue/game-start",
              callback: (frame) {
                Map<String, dynamic> gameStartJson = jsonDecode(frame.body!);
                GameStart gameStart = GameStart.fromJson(gameStartJson);
                lastGameStartUpdate = gameStart;
                _gameStartUpdate.add(gameStart);
              }
          );
          _stompClient?.subscribe(
              destination: "/topic/$roomId/round-start",
              callback: (frame) {
                Map<String, dynamic> roundStartJson = jsonDecode(frame.body!);
                Round round = Round.fromJson(roundStartJson);
                lastRoundStartUpdate = round;
                _roundStartUpdate.add(round);
              }
          );
          _stompClient?.subscribe(
            destination: "/topic/$roomId/voting-summary",
            callback: (frame) {
              Map<String, dynamic> votingSummaryJson = jsonDecode(frame.body!);
              //VotingSummary votingSummary = VotingSummary.fromJson(votingSummaryJson);
              VotingResult result = VotingResult(username: 'Gracz1', voteCount: 7);
              VotingSummary summary = VotingSummary(results: [result]);
              lastVotingSummary = summary;
              _votingSummaryUpdate.add(summary);
            }
          );
          connectionCompleter.complete();
        },
        onDisconnect: (StompFrame frame) {
          print("disconnected");
        },
        stompConnectHeaders: {
          'login': username,
          'passcode': password
        }
    );
    _stompClient = StompClient(config: config);
    _stompClient?.activate();

    return connectionCompleter.future;
  }

  void dispose() {
    _roomUpdate.close();
    _stompClient?.deactivate();
  }
}
