import 'package:flutter/material.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/services/network/RoomService.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/state/RoomState.dart';

import '../services/network/NetworkException.dart';

class JoinPrivateRoomViewModel extends ChangeNotifier {

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final RoomService _roomService = RoomService();
  final WebSocketClient _webSocketClient = WebSocketClient();
  final RoomState _roomState = RoomState();

  final RegExp accessCodeRegex = RegExp(r'^[a-zA-Z0-9]*$');

  Future<void> joinRoom(String accessCode, void Function() onSuccess, void Function(String errorMsg) onError) async {
    _setLoading(true);

    if (accessCode.isNotEmpty) {
      try {
        if(!accessCodeRegex.hasMatch(accessCode)) {
          onError("Access code should contain only alpha-numeric characters");
          return;
        }
        Room room = await _roomService.joinRoomByAccessCode(accessCode);
        await _webSocketClient.connect(room.id);
        _roomState.setRoom(room);
        onSuccess();
      }
      catch (e) {
        if(e is UnauthorisedException) {
          onError("Lobby is full");
        } else {
          onError("Wrong code");
        }
      }
    }
    else {
      onError("Code is empty");
    }
  }
}

