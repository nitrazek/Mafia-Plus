import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModels/WinnerViewModel.dart';
import '../views/Menu.dart';
import '../views/styles.dart';
import '../viewModels/UserRoleViewModel.dart';

class WinnerPage extends StatefulWidget {
  const WinnerPage({super.key});

  @override
  WinnerPageState createState() => WinnerPageState();
}

class WinnerPageState extends State<WinnerPage> {

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 8), () {
      Navigator.pop(context);
    });

    String winnerRole = context.watch<WinnerViewModel>().winnerRole;
    Color textColor = winnerRole == 'mafia' ? Colors.red : Colors.green;
    String roleName = winnerRole == 'mafia' ? 'Mafia' : 'Citizen';
    String imagePath = winnerRole == 'mafia' ? 'assets/images/Mafias.png' : 'assets/images/Citizens.png';

    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyStyles.purple,
              MyStyles.lightestPurple,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.015),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: screenWidth * 0.01),
                  const Text(
                    'The Winner is...',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyStyles.backgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Image.asset(
                            'assets/images/Crown.png',
                            width: 100
                        ),
                        Image.asset(
                            imagePath,
                            width: 100
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          roleName,
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
