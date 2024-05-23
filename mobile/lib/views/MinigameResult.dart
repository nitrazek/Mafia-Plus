import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/models/Score.dart';
import 'package:mobile/viewModels/MinigameResultViewModel.dart';
import 'package:mobile/views/Voting.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MinigameResultPage extends StatefulWidget {
  const MinigameResultPage({super.key});

  @override
  State<MinigameResultPage> createState() => MinigameResultPageState();
}

class MinigameResultPageState extends State<MinigameResultPage> {

  bool isWinner = false;
  int rank = 1;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
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

  @override
  Widget build(BuildContext context) {
    var scores = context.watch<MinigameResultViewModel>().scores;
    var player = context.watch<MinigameResultViewModel>().account;
    var playerScore = scores?.scores[player?.username];
    var winner = scores!.winner;
    if(player?.username == winner.username && player != null)
      {
        isWinner = true;
      }
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
          )
        ),
        child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyStyles.backgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left:30.0, right: 30.0, top: 20.0),
                            child: Text(
                              isWinner ? 'Congratulations\nYou won!' : 'Somebody\nwas better!',
                              style: TextStyle(
                                color: isWinner ? MyStyles.green : MyStyles.red,
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10, ),
                          Image.asset(
                              isWinner ? 'assets/images/Prize.png' : 'assets/images/SecondPrize.png',
                              width: 100
                          ),
                          SizedBox(height: 10,),
                          Text(
                            isWinner ? 'Your prize is:' : 'Winner is richer by:',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                      SizedBox(height: 200,),
                      Container(
                          padding:EdgeInsets.only(top:15,bottom:5),
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(radius: 45, backgroundColor: Color(0xFF8E44AD),
                              child: Text(
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 25
                                ),
                                playerScore == null ? "0" : playerScore.toString(),
                              ),
                              ),
                              SizedBox(width:20),
                              Padding(
                                padding:EdgeInsets.only(bottom:30),
                                child: CircleAvatar(radius: 80, backgroundColor: Color(0xFFA569BD),
                                  child: Text(
                                    style: TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 40
                                    ),
                                      scores.highestScore == null ? "0" : scores.highestScore.toString(),
                                  ),),
                              ),
                            ],
                          )
                      ),
                          Row(
                            children: [
                              SizedBox(width: 60,),
                              Text(
                                "Yours",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                              ),
                              SizedBox(width: 91,),
                              Text(
                                "Best",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                      ],
                      )
                    ),
                  ),
                ),
        ),
      )
    ),
    );
  }
}
