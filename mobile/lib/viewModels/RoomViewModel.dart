import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/services/network/GameService.dart';
import 'package:mobile/services/network/RoomService.dart';

import 'package:mobile/models/Room.dart';
import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/services/WebSocketClient.dart';

class RoomViewModel extends ChangeNotifier{
  final WebSocketClient webSocketClient = WebSocketClient();
  Room? _room;
  bool _isHost = false;
  final _gameStarted = StreamController<void>.broadcast();
  final RoomService roomService = RoomService();
  final GameService gameService = GameService();
  String messageError = "";

  Room? get room => _room;
  Stream<void> get gameStarted => _gameStarted.stream;
  bool get isHost => _isHost;

  void setIsHost(bool value)
  {
    _isHost = value;
    notifyListeners();
  }

  void setRoom(Room value)
  {
    _room = value;
    setIsHost(value.hostUsername == webSocketClient.username);
    notifyListeners();
  }

  Future<void> startGame(int roomId, void Function() onSuccess, void Function() onError) async {
    try {
      await gameService.startGame(roomId);
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
      await roomService.leaveRoom();
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

  void connectWebSocket() {
    webSocketClient.roomUpdate.listen((room) { setRoom(room); });
    webSocketClient.gameStartUpdate.listen((gameStart) {
      _gameStarted.add(null);
      notifyListeners();
    });
  }
}
