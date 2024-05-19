import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/viewModels/minigames/ClickTheButtonMinigameViewModel.dart';
import 'package:mobile/views/Voting.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mobile/views/minigames/ClickTheButtonMinigame.dart';
import 'package:mobile/views/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ClickTheButtonMinigamePage extends StatefulWidget {
  const ClickTheButtonMinigamePage({Key? key}) : super(key: key);

  @override
  ClickTheButtonMinigamePageState createState() => ClickTheButtonMinigamePageState();
}

class ClickTheButtonMinigamePageState extends State<ClickTheButtonMinigamePage> {
  StreamSubscription<void>? _votingStartedSubscription;

  int _countdownValue = 3;
  int _minigameDuration = 10;
  late Timer _countdownTimer, _minigameTimer;
  late OverlayEntry _overlayEntry;

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_countdownValue == 0) {
        timer.cancel();
        _overlayEntry.remove();
        _startMinigame();
      } else {
        setState(() {
          _countdownValue--;
          _overlayEntry.markNeedsBuild();
        });
      }
    });
  }

  void _startMinigame() {
    _minigameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_minigameDuration == 0) {
        timer.cancel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ClickTheButtonMinigameViewModel>().finishMinigame();
        });
        WidgetsBinding.instance.ensureVisualUpdate();
      } else {
        setState(() {
          _minigameDuration--;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _votingStartedSubscription ??= context.read<ClickTheButtonMinigameViewModel>().votingStarted.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 1500),
          child: const VotingResultsPage(),
        ));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(
      builder: (context) => Scaffold(
        body: Container(
          color: MyStyles.black.withOpacity(0.5), child: Center(
            child: Text(
              '$_countdownValue',
              style: TextStyle(fontSize: 100, color: MyStyles.red)
            )
          )
        )
      )
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry);
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _minigameTimer.cancel();
    _overlayEntry.remove();
    _votingStartedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child: Scaffold(
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.8,
                  MediaQuery.of(context).size.width * 0.8
                ),
                shape: const CircleBorder(),
                backgroundColor: MyStyles.red
              ),
              onPressed: () {
                context.read<ClickTheButtonMinigameViewModel>().click();
              },
              child: Text("Click me!", style: MyStyles.backgroundTextStyle)
            )
          ),
          Positioned(
            top: 30.0,
            right: 30.0,
            child: Text(
              '$_minigameDuration',
              style: TextStyle(fontSize: 30, color: MyStyles.black)
            )
          )
        ]
      )
    ),
    );
  }
}