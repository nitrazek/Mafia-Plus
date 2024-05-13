import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/Minigame.dart';
import 'package:mobile/viewModels/minigames/ClickTheButtonMinigameViewModel.dart';
import 'package:mobile/views/minigames/ClickTheButtonMinigame.dart';
import 'package:mobile/views/styles.dart';
import 'package:provider/provider.dart';

class MinigameIntroPage extends StatefulWidget {
  final String title;
  final String description;
  final Widget Function(BuildContext context) minigameNavigation;

  const MinigameIntroPage({
    Key? key,
    required this.title,
    required this.description,
    required this.minigameNavigation
  }) : super(key: key);

  @override
  MinigameIntroPageState createState() => MinigameIntroPageState();
}

class MinigameIntroPageState extends State<MinigameIntroPage> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: widget.minigameNavigation)
      );
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
        padding: const EdgeInsets.all(25.0),
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