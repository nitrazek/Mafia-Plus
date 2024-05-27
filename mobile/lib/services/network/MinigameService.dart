import 'dart:convert';
import 'dart:io';

import 'package:mobile/utils/Constants.dart' as Constants;
import '../../utils/CustomHttpClient.dart';
import '../../utils/NetworkUtils.dart';
import 'NetworkException.dart';

class MinigameService {
  final String baseUrl = "http://${Constants.baseUrl}";
  final CustomHttpClient httpClient = CustomHttpClient();

  Future<void> finishMinigame(int minigameId, int score) async {
    try {
      final response = await httpClient.post(
        Uri.parse("$baseUrl/minigame/$minigameId"),
        body: jsonEncode(<String, String>{
          'score': score.toString(),
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