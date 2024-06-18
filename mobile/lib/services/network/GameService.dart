import 'dart:convert';
import 'dart:io';
import 'package:mobile/models/GameHistory.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/utils/Constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:mobile/utils/CustomHttpClient.dart';
import 'package:mobile/utils/NetworkUtils.dart';
import 'package:mobile/services/network/NetworkException.dart';

class GameService {
  final String baseUrl = "http://${Constants.baseUrl}";
  final CustomHttpClient httpClient = CustomHttpClient();
  final WebSocketClient webSocketClient = WebSocketClient();

  Future<void> startGame(int roomId) async {
    try {
      final response = await httpClient.post(
          Uri.parse("$baseUrl/game/start/${roomId}"));
      return handleResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException('No Internet Connection');
      } else {
        rethrow;
      }
    }
  }

  Future<void> addVote (int votingId, String votedName) async {
    try {
      final response = await httpClient.post(
        Uri.parse("$baseUrl/voting/$votingId/vote"),
        body: jsonEncode(<String, String>{
          'votedUsername': votedName,
        }),
      );
      return handleResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException('No Internet Connection');
      } else {
        rethrow;
      }
    }
  }

  Future<List<GameHistory>> getHistory() async {
    try {
      final response = await httpClient.get(Uri.parse("$baseUrl/game/history"));
      if (response.statusCode == 200) {
        List<dynamic> gamesJson = jsonDecode(response.body);
        List<GameHistory> games = gamesJson
            .map((json) => GameHistory.fromJson(json as Map<String, dynamic>))
            .toList();
        return games;
      } else {
        throw FetchDataException('Failed to load games');
      }
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException('No Internet Connection');
      } else {
        rethrow;
      }
    }
  }

  Future<void> useReward(String username) async {
    try{
      final response = await httpClient.post(
        Uri.parse("$baseUrl/reward"),
        body: jsonEncode(<String, String>{
          'username': username,
        }),
      );
      return handleResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException('No Internet Connection');
      } else {
        rethrow;
      }
    }
  }
}