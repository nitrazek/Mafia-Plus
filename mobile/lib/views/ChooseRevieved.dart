import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile/views/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/RewardViewModel.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';
import 'package:mobile/views/Voting.dart';

class ChooseProtected extends StatefulWidget {
  const ChooseProtected({Key? key}) : super(key: key);

  @override
  _ChooseProtectedState createState() => _ChooseProtectedState();
}

class _ChooseProtectedState extends State<ChooseProtected> {
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    FlutterView view = WidgetsBinding.instance!.platformDispatcher.views.first;
    Size size = view.physicalSize;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  void _onRewardUsed() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 1000),
        child: const VotingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String votingText = 'Who would you like to protect?';
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      votingText,
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: MyStyles.purpleLowOpacity,
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (_) => context.read<RewardViewModel>()),
                            ChangeNotifierProvider(create: (_) => context.read<VotingViewModel>()),
                          ],
                          builder: (context, child) {
                            return Consumer2<RewardViewModel, VotingViewModel>(
                              builder: (context, rewardViewModel, votingViewModel, child) {
                                if (votingViewModel.playerUsernames == null || votingViewModel.playerUsernames!.isEmpty) {
                                  Future.delayed(Duration.zero, () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        duration: const Duration(milliseconds: 1000),
                                        child: const VotingPage(),
                                      ),
                                    );
                                  });
                                  return Center(
                                    child: CircularProgressIndicator(), // Placeholder for loading state
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: votingViewModel.playerUsernames!.length,
                                    itemBuilder: (context, index) {
                                      String playerUsername = votingViewModel.playerUsernames![index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: PlayerButton(
                                                playerUsername: playerUsername,
                                                onPressed: () => rewardViewModel.useReward(playerUsername),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerButton extends StatelessWidget {
  final String playerUsername;
  final VoidCallback onPressed;

  PlayerButton({
    required this.playerUsername,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: MyStyles.buttonStyle.backgroundColor!.resolve({}),
              child: const Icon(Icons.person, size: 35.0, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              child: Text(
                playerUsername,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}