import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/viewModels/VotingResultsViewModel.dart';
import 'package:mobile/views/Menu.dart';
import 'package:mobile/views/Voted.dart';
import 'package:mobile/views/Winner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

import '../models/Room.dart';
import '../viewModels/VotingViewModel.dart';
import 'Room.dart';

class VotingResultsPage extends StatefulWidget {
  const VotingResultsPage({super.key});

  @override
  VotingResultsPageState createState() => VotingResultsPageState();
}

class VotingResultsPageState extends State<VotingResultsPage> {
  StreamSubscription<void>? _votingFinishedSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _votingFinishedSubscription ??= context.read<VotingResultsViewModel>().votingFinished.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          child: const VotedPage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _votingFinishedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
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
            const SizedBox(height: 80),
            const Text(
              'Voting Results',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Changed to white color
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: MyStyles.backgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: context.watch<VotingResultsViewModel>().votingSummary?.votingResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              var voteInfo = context.watch<VotingResultsViewModel>().votingSummary?.votingResults[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: MyStyles.lightPurple,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      voteInfo!.username,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Votes: ${voteInfo.voteCount}',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 450),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}