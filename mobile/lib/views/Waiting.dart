import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/viewModels/WaitingViewModel.dart';
import 'package:mobile/views/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';
import 'package:mobile/state/VotingState.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';

import 'Voted.dart';

class WaitingPage extends StatefulWidget {
  final int viewType;

  const WaitingPage({Key? key, required this.viewType}) : super(key: key);

  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription<void>? _votingFinishedSubscription;
  final RoomViewModel _roomViewModel = RoomViewModel();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _votingFinishedSubscription ??= context.read<WaitingViewModel>().votingFinished.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(context.read<WaitingViewModel>().turn == 'city') {
          Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 1500),
            child: const VotingResultsPage(),
          ));
        } else {
          Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 1500),
            child: const VotedPage(),
          ));
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _votingFinishedSubscription?.cancel();
    super.dispose();
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
              MyStyles.lightestPurple,
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
                    color: MyStyles.purpleLowOpacity,
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
                      widget.viewType == 0 ? "Congrats!" : "Good night!",
                      style: TextStyle(
                        fontSize: 60,
                        color: MyStyles.purple,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Text(
                      widget.viewType == 0
                          ? "You died!:3"
                          : "hope you wake up in the morning...",
                      style: TextStyle(
                        fontSize: 40,
                        color: MyStyles.purple,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: _controller.value,
                          child: widget.viewType == 0
                              ? Image.asset(
                              'assets/images/skull.png', width: 120)
                              : Image.asset(
                              'assets/images/sleep.png', width: 120),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    // Przycisk "quit" wyświetli się, jeśli gracz odpadł
                    if (widget.viewType == 0)
                      ElevatedButton(
                          style: MyStyles.buttonStyle,
                          onPressed: () {
                            _roomViewModel.leaveRoom(
                                  () {
                                // onSuccess - tutaj możesz wykonać jakieś operacje po pomyślnym opuszczeniu pokoju
                              },
                                  () {
                                // onError - tutaj możesz wykonać jakieś operacje po błędzie podczas opuszczania pokoju
                              },
                            );
                          },
                          child: const Text(
                              'Quit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ))
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