import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/viewModels/VotedViewModel.dart';
import 'package:provider/provider.dart';

class VotedPage extends StatefulWidget {
  const VotedPage({super.key});

  @override
  VotedPageState createState() => VotedPageState();
  }

  class VotedPageState extends State<VotedPage> {

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyStyles.purple,
              MyStyles.lightestPurple
            ]
          )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                const Text(
                  "Voting result",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: context.watch<VotedViewModel>().votingType == 'Mafia'
                              ? Image.asset(
                            'assets/images/mafia.png',
                            width: 90,
                          )
                              : Image.asset(
                            'assets/images/citizen.png',
                            width: 110,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: DefaultTextStyle(
                            style: MyStyles.votedPlayerUsernameStyle,
                            child: Center(
                              child: AnimatedTextKit(
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    '${context.watch<VotedViewModel>().votedPlayerNickname} decided:\n\n${context.watch<VotedViewModel>().votedPlayerNickname}\nhas been voted out',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      )
    );
  }
}