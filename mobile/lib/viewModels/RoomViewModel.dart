import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/services/network/GameService.dart';
import 'package:mobile/services/network/RoomService.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/state/RoomState.dart';
import '../state/GameState.dart';

class RoomViewModel extends ChangeNotifier {
  final RoomState _roomState = RoomState();
  final GameState _gameState = GameState();
  final WebSocketClient _webSocketClient = WebSocketClient();
  final RoomService _roomService = RoomService();
  final GameService _gameService = GameService();

  String messageError = "";

  Room? _room;
  Room? get room => _room;

  bool _isHost = false;
  bool get isHost => _isHost;

  final _gameStarted = StreamController<void>.broadcast();
  Stream<void> get gameStarted => _gameStarted.stream;

  RoomViewModel() {
    _roomState.addListener(_updateRoom); _updateRoom();
    _gameState.addListener(_updateGameStart);
  }

  void _updateGameStart() {
    if(_gameState.currentGame == null) return;
    _gameStarted.add(null);
    notifyListeners();
  }

  void _updateRoom() {
    if(_roomState.currentRoom == null) return;
    _room = _roomState.currentRoom!;
    _isHost = _room!.hostUsername == _webSocketClient.username;
    notifyListeners();
  }

  Future<void> startGame(int roomId, void Function() onSuccess, void Function() onError) async {
    try {
      await _gameService.startGame(roomId);
      onSuccess.call();
    }
    catch(e)
    {
      messageError = "Wrong starting procedure";
      notifyListeners();
      onError.call();
    }
  }

  Future<void> leaveRoom(void Function() onSuccess, void Function() onError) async {
    try {
      await _roomService.leaveRoom();
      _roomState.setRoom(null);
      onSuccess.call();
    } catch(e) {
      messageError = "Leaving room error";
      notifyListeners();
      onError.call();
    }
  }

  void openGameSettings() {
    // Implement the logic for opening game settings
  }
}
