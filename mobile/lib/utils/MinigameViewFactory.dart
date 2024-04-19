import 'package:flutter/cupertino.dart';
import 'package:mobile/models/MinigameStart.dart';
import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';
import 'package:mobile/views/minigames/TestMinigame.dart';
import 'package:provider/provider.dart';

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
    }
  }
}