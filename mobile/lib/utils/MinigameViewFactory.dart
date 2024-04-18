import 'package:flutter/cupertino.dart';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/viewModels/minigames/TestViewModel.dart';
import 'package:mobile/views/minigames/Test.dart';
import 'package:provider/provider.dart';

class MinigameViewFactory {
  static Widget Function(BuildContext context) createMinigameView(MinigameType minigameType) {
    switch(minigameType) {
      case MinigameType.TEST:
        return (context) => ChangeNotifierProvider(
          create: (context) => TestViewModel(),
          child: const TestPage()
        );
    }
  }
}