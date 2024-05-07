import 'package:flutter/cupertino.dart';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';
import 'package:mobile/views/minigames/ClickTheButtonMinigame.dart';
import 'package:mobile/views/minigames/TestMinigame.dart';
import 'package:provider/provider.dart';

import '../models/MinigameType.dart';
import '../views/minigames/MinigameIntro.dart';

class MinigameViewFactory {
  static Widget Function(BuildContext context) createMinigameView(MinigameType minigameType) {
    switch(minigameType) {
      case MinigameType.TEST:
        return (context) => const MinigameIntroPage(
          title: "TEST",
          description: "To jest test, bardzo fajny test, nic podejrzanego o_O",
          minigame: TestMinigamePage()
        );
      case MinigameType.CLICK_THE_BUTTON:
        return (context) => const MinigameIntroPage(
          title: "Click The Button!",
          description: "Score the highest points by clicking big red button as many times as possible.",
          minigame: ClickTheButtonMinigamePage()
        );
    }
  }
}