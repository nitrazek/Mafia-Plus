import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/viewModels/VotedViewModel.dart';
import 'package:mobile/views/Voting.dart';
import 'package:mobile/views/Waiting.dart';
import 'package:mobile/views/Winner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/views/VotingAnnouncement.dart';
import 'package:mobile/viewModels/WaitingViewModel.dart';

class VotedPage extends StatefulWidget {
  const VotedPage({Key? key}) : super(key: key);

  @override
  VotedPageState createState() => VotedPageState();
}

class VotedPageState extends State<VotedPage> {
  StreamSubscription<void>? _gameEndedSubscription;
  StreamSubscription<void>? _votingStartedSubscription;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameEndedSubscription ?? context.read<VotedViewModel>().gameEnded.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 500),
            child: const WinnerPage()
        ));
      });
    });
    _votingStartedSubscription ??= context.read<VotedViewModel>().votingStarted.listen((conditions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
          //turn mafii
          if (Provider
              .of<WaitingViewModel>(context, listen: false)
              .turn == 'mafia') {
            Navigator.pushReplacement(context, PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1500),
              child: VotingAnnouncement(viewType: 1),
            ));
          }

          //turn miasta
          else {
            Navigator.pushReplacement(context, PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 1500),
              child: VotingAnnouncement(viewType: 0),
            ));
          }
      });
    });
  }

  @override
  void dispose() {
    _gameEndedSubscription?.cancel();
    _votingStartedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
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
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Voting result",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
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
                        SizedBox(height: screenHeight * 0.035),
                        SizedBox(
                          width: double.infinity,
                          child: DefaultTextStyle(
                            style: MyStyles.votedPlayerUsernameStyle,
                            child: Center(
                              child: AnimatedTextKit(
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    '${context.watch<VotedViewModel>().votingType} decided:\n\n${context.watch<VotedViewModel>().votedPlayerNickname}\nhas been voted out',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.035),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      )
    ),
    );
  }
}