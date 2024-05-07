import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';
import 'package:provider/provider.dart';

class ClickTheButtonMinigamePage extends StatelessWidget {
  const ClickTheButtonMinigamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.8,
            MediaQuery.of(context).size.width * 0.8
          ),
          shape: const CircleBorder(),
          primary: MyStyles.red
        ),
        onPressed: () {
          context.read<MinigameViewModel>().increaseScore(1);
        },
        child: Text("Click me!", style: MyStyles.backgroundTextStyle)
      )
    );
  }
}