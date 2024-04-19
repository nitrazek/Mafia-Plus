import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';
import 'package:mobile/views/minigames/Minigame.dart';
import 'package:mobile/views/styles.dart';
import 'package:provider/provider.dart';

class MinigameIntroPage extends StatefulWidget {
  final String title;
  final String description;
  final Widget minigame;

  const MinigameIntroPage({
    Key? key,
    required this.title,
    required this.description,
    required this.minigame
  }) : super(key: key);

  @override
  MinigameIntroPageState createState() => MinigameIntroPageState();
}

class MinigameIntroPageState extends State<MinigameIntroPage> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
        create: (context) => MinigameViewModel(),
        child: MinigamePage(minigame: widget.minigame)
      )));
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minigame'),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyStyles.purple,
                MyStyles.lightestPurple,
              ],
            ),
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: MyStyles.minigameTitleStyle
            ),
            const SizedBox(height: 15),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: MyStyles.minigameDescriptionStyle
            )
          ],
        )
      )
    );
  }
}