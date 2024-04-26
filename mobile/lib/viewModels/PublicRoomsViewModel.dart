import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/services/network/RoomService.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/state/RoomState.dart';

import '../services/network/NetworkException.dart';

class PublicRoomsViewModel with ChangeNotifier {
  final RoomService _roomService = RoomService();
  //dopusane 2
  final WebSocketClient _webSocketClient = WebSocketClient();
  final RoomState _roomState = RoomState();

  List<Room> _publicRooms = [];

  List<Room> get publicRooms => _publicRooms;

  Future<void> fetchPublicRooms() async {
    try {
      List<Room> rooms = await _roomService.getPublicRooms();
      _publicRooms = rooms;
      notifyListeners();
    } catch (e) {
      print('Error while fetching room list: $e');
    }
  }

  Future<void> refreshPublicRooms() async {
    await fetchPublicRooms();
  }

  Future<void> joinRoom(String accessCode, void Function() onSuccess, void Function(String errorMsg) onError) async {

    if (accessCode.isNotEmpty) {
      try {
        Room room = await _roomService.joinRoomByAccessCode(accessCode);
        await _webSocketClient.connect(room.id);
        _roomState.setRoom(room);
        onSuccess.call();
      }
      catch (e) {
        if(e is UnauthorisedException) {
          onError.call("Lobby is full");
        } else {
          onError.call("Wrong code");
        }
      }
    }
  }
}
