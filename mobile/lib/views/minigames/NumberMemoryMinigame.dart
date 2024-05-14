import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/viewModels/minigames/NumberMemoryMinigameViewModel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Voting.dart';
import '../styles.dart';

class NumberMemoryMinigamePage extends StatefulWidget {
  const NumberMemoryMinigamePage({Key? key}) : super(key: key);

  @override
  NumberMemoryMinigamePageState createState() => NumberMemoryMinigamePageState();
}

class NumberMemoryMinigamePageState extends State<NumberMemoryMinigamePage> {
  StreamSubscription<void>? _votingStartedSubscription;
  final TextEditingController _answerController = TextEditingController();

  int _countdownValue = 3;
  int _minigameDuration = 60;
  bool _isNumberVisible = true;
  bool? _isAnswerCorrect;
  
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
          context.read<NumberMemoryMinigameViewModel>().finishMinigame();
        });
        WidgetsBinding.instance.ensureVisualUpdate();
      } else {
        setState(() {
          _minigameDuration--;
        });
      }
    });
    _toggleNumberVisibility();
  }

  void _toggleNumberVisibility() {
    context.read<NumberMemoryMinigameViewModel>().generateNumber();
    setState(() { _isNumberVisible = true; });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() { _isNumberVisible = false; });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _votingStartedSubscription ??= context.read<NumberMemoryMinigameViewModel>().votingStarted.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 1500),
          child: const VotingPage(),
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
    return Scaffold(
      body: Stack(
        children: [
          if(_isNumberVisible)
            Center(
              child: Text(
                context.watch<NumberMemoryMinigameViewModel>().generatedNumber,
                style: const TextStyle(
                  fontSize: 30
                ),
              )
            )
          else if(!_isNumberVisible && _isAnswerCorrect == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "What was the number?"
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      )
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if(_answerController.text == "") return;
                        setState(() {
                          _isAnswerCorrect = context.read<NumberMemoryMinigameViewModel>().submitAnswer(_answerController.text);
                        });
                        _answerController.clear();
                        if(_isAnswerCorrect == true) {
                          Future.delayed(const Duration(seconds: 1), () {
                            _toggleNumberVisibility();
                            setState(() { _isAnswerCorrect = null; });
                          });
                        } else if(_isAnswerCorrect == false) {
                          context.read<NumberMemoryMinigameViewModel>().finishMinigame();
                        }
                      },
                      child: const Text("Submit")
                    )
                  ],
                )
              )
            )
          else if(!_isNumberVisible && _isAnswerCorrect == true)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size: 100, color: MyStyles.green),
                  Text(
                    "Correct answer (${context.read<NumberMemoryMinigameViewModel>().generatedNumber})",
                    style: TextStyle(fontSize: 25, color: MyStyles.green)
                  )
                ],
              ),
            )
          else if(!_isNumberVisible && _isAnswerCorrect == false)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 100, color: MyStyles.red),
                  Text(
                    "Incorrect answer (${context.read<NumberMemoryMinigameViewModel>().generatedNumber})",
                    style: TextStyle(fontSize: 25, color: MyStyles.red),
                  )
                ],
              ),
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
    );
  }
}