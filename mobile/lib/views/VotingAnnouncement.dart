import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/WaitingViewModel.dart';
import 'package:mobile/views/styles.dart';
import 'package:mobile/views/Voting.dart';
import 'package:mobile/views/Waiting.dart';
import 'package:mobile/viewModels/VotedViewModel.dart';

class VotingAnnouncement extends StatefulWidget {
  final int viewType;

  const VotingAnnouncement({Key? key, required this.viewType}) : super(key: key);

  @override
  _VotingAnnouncementState createState() => _VotingAnnouncementState();
}

class _VotingAnnouncementState extends State<VotingAnnouncement> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      navigateToNextPage(context);
    });
  }


  void navigateToNextPage(BuildContext context) {
    final waitingViewModel = Provider.of<WaitingViewModel>(context, listen: false);
    final votedViewModel = context.read<VotedViewModel>();

    votedViewModel.votingStarted.listen((conditions) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (conditions.isVoting) {
          // Warunek: jeśli glosuje i jest zywa mafia
          if (waitingViewModel.turn == 'mafia') {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 1500),
                child: const VotingPage(),
              ),
            );
          } else {
            // Warunek: jeśli glosuje i jest zywe cokolwiek innego
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 1500),
                child:  const VotingPage(),
              ),
            );
          }
        }

        else {
          // Warunek: jeśli nie glosuje
          if (conditions.isAlive) {
            // Żyje więc będzie w waitingpage potem
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 1500),
                child: WaitingPage(viewType: 1),
              ),
            );
          } else {
            // Nie żyje
            if (waitingViewModel.turn == 'mafia') {
              // Jak jest glosowanie mafii i nie glosuje bo nie zyje
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 1500),
                  child: WaitingPage(viewType: 0),
                ),
              );
            } else {
              // Jak jest glosowanie miasta i nie glosuje bo nie zyje
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 1500),
                  child: WaitingPage(viewType: 0),
                ),
              );
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyStyles.purple,
              MyStyles.lightestPurple
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 100.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.viewType == 0
                          ? "Prepare! It's time to find the mafia!"
                          : "Mafia will choose someone to eliminate in a moment...",
                      style: TextStyle(
                        fontSize: 30,
                        color: MyStyles.purple,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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