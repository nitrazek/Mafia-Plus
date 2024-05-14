import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/WaitingViewModel.dart';
import 'package:mobile/views/styles.dart';
import 'package:mobile/views/Voting.dart';
import 'package:mobile/views/Waiting.dart';

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
     // navigateToNextPage(context);
    });
  }


  /*void navigateToNextPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 1500),
        child: widget.viewType == 0
            ? VotingPage() //al glosuja
            : Provider.of<WaitingViewModel>(context, listen: false).turn == 'mafia'
            ? const VotingPage() //jezeli mafia glosuje
            : WaitingPage(viewType: 1), //a tak to waitingpage
      ),
    );
  } */

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