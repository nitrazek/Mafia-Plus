import 'package:flutter/foundation.dart';
import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/services/network/RoomService.dart';
import 'package:mobile/state/RoomState.dart';

class RoomSettingsViewModel with ChangeNotifier {
  final RoomState _roomState = RoomState();
  final RoomService _roomService = RoomService();

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  int? _roomId;
  int? get roomId => _roomId;

  RoomSettings? _roomSettings;
  RoomSettings? get roomSettings => _roomSettings;

  RoomSettingsViewModel() {
    _roomState.addListener(_updateRoomSettings); _updateRoomSettings();
  }

  void _updateRoomSettings() {
    if(_roomState.currentRoom == null) return;
    _roomId = _roomState.currentRoom!.id;
    _roomSettings = _roomState.currentRoom!.roomSettings;
    notifyListeners();
  }

  void setMaxNumberOfPlayers(double value) {
    _roomSettings = RoomSettings(
      isPublic: _roomSettings!.isPublic,
      maxNumberOfPlayers: value.toInt()
    );
    notifyListeners();
  }

  void setIsPublic(bool value) {
    _roomSettings = RoomSettings(
        isPublic: value,
        maxNumberOfPlayers: _roomSettings!.maxNumberOfPlayers
    );
    notifyListeners();
  }

  Future<void> saveRoomSettings(void Function() onSuccess, void Function(String errorMsg) onError) async {
    try {
      await _roomService.saveRoomSettings(_roomId!, _roomSettings!);
      onSuccess();
    } catch (error) {
      onError("Error saving game settings: $error");
    } finally {
      notifyListeners();
    }
  }
}
