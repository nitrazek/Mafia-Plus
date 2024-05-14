import 'package:flutter/cupertino.dart';
import 'package:mobile/viewModels/minigames/ClickTheButtonMinigameViewModel.dart';
import 'package:mobile/viewModels/minigames/NumberMemoryMinigameViewModel.dart';
import 'package:mobile/views/Login.dart';
import 'package:mobile/views/minigames/ClickTheButtonMinigame.dart';
import 'package:mobile/views/minigames/NumberMemoryMinigame.dart';
import 'package:provider/provider.dart';

import '../models/MinigameType.dart';
import '../views/minigames/MinigameIntro.dart';

class MinigameViewFactory {
  static Widget Function(BuildContext context) createMinigameView(MinigameType minigameType) {
    switch(minigameType) {
      case MinigameType.CLICK_THE_BUTTON:
        return (context) => MinigameIntroPage(
          title: "Click The Button!",
          description: "Score the highest points by clicking big red button as many times as possible.",
          minigameNavigation: (context) => ChangeNotifierProvider(
            create: (context) => ClickTheButtonMinigameViewModel(),
            builder: (context, child) => const ClickTheButtonMinigamePage(),
          ),
        );
      case MinigameType.NUMBER_MEMORY:
        return (context) => MinigameIntroPage(
          title: "Number Memory",
          description: "Score the highest points by memorizing as many numbers as you can. Each correct answer increases number by 1 digit.",
          minigameNavigation: (context) => ChangeNotifierProvider(
            create: (context) => NumberMemoryMinigameViewModel(),
            builder: (context, child) => const NumberMemoryMinigamePage(),
          ),
        );
    }
  }
}