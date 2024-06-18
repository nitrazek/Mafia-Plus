import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/models/Score.dart';
import 'package:mobile/viewModels/MinigameResultViewModel.dart';
import 'package:mobile/views/ChooseRevieved.dart';
import 'package:mobile/views/Voting.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/RewardViewModel.dart';
import 'package:mobile/views/ChooseProtected.dart';

class MinigameResultPage extends StatefulWidget {
  const MinigameResultPage({super.key});

  @override
  State<MinigameResultPage> createState() => MinigameResultPageState();
}


class MinigameResultPageState extends State<MinigameResultPage> {

  bool isWinner = false;
  int rank = 1;
  String? prize = "nie znalazlo";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        prize = context.read<RewardViewModel>().reward;
      });

      var scores = context.read<MinigameResultViewModel>().scores;
      var player = context.read<MinigameResultViewModel>().account;
      var winner = scores?.winner;

      if (player?.username == winner?.username && player != null) {
        setState(() {
          isWinner = true;
        });
      }
      navigateBasedOnPrize();
    });
  }


  void navigateBasedOnPrize() {
  // do uzycia invincible jesli ta nagroda
      if (prize == "\"INVINCIBLE\"" && isWinner==true) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 1000),
            child: ChooseProtected(),
          ),
        );
      } else if (prize == "\"REVIVE\"" && isWinner==true) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 1000),
            child: ChooseRevieved(),
          ),
        );
      }

      else {
        Future.delayed(Duration(seconds: 10), () {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1000),
              child: const VotingPage(),
            ),
          );
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    var scores = context.watch<MinigameResultViewModel>().scores;
    var player = context.watch<MinigameResultViewModel>().account;
    var playerScore = scores?.scores[player?.username];
    var winner = scores?.winner;
    if (player?.username == winner?.username && player != null) {
      isWinner = true;
    }

    double baseWidth = 350.0;
    double fontSizeScale = screenWidth / baseWidth;
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: MyStyles.backgroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                      child: Text(
                        isWinner ? 'Congratulations\nYou won!' : 'Somebody\nwas better!',
                        style: TextStyle(
                          color: isWinner ? MyStyles.green : MyStyles.red,
                          fontSize: 35 * fontSizeScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Image.asset(
                      isWinner ? 'assets/images/Prize.png' : 'assets/images/SecondPrize.png',
                      width: 100 * fontSizeScale,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      isWinner ? 'Your prize is: $prize' : 'Winner is richer by: $prize',
                      style: TextStyle(fontSize: 20 * fontSizeScale),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 45 * fontSizeScale,
                                backgroundColor: const Color(0xFF8E44AD),
                                child: Text(
                                  playerScore?.toString() ?? "0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25 * fontSizeScale,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10 * fontSizeScale),
                              Text(
                                "Yours",
                                style: TextStyle(
                                  fontSize: 20 * fontSizeScale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: CircleAvatar(
                                  radius: 80 * fontSizeScale,
                                  backgroundColor: const Color(0xFFA569BD),
                                  child: Text(
                                    scores?.highestScore?.toString() ?? "0",
                                    style: TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 40 * fontSizeScale,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10 * fontSizeScale),
                              Text(
                                "Best",
                                style: TextStyle(
                                  fontSize: 30 * fontSizeScale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
