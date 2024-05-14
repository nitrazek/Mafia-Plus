import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/utils/MinigameViewFactory.dart';
import 'package:mobile/viewModels/UserRoleViewModel.dart';
import 'package:mobile/views/Waiting.dart';
import 'package:provider/provider.dart';

class UserRolePage extends StatefulWidget {
  const UserRolePage({super.key});

  @override
  UserRolePageState createState() => UserRolePageState();
}

class UserRolePageState extends State<UserRolePage> {
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
    if (context.read<UserRoleViewModel>().votingStart != null &&
        !context.read<UserRoleViewModel>().votingStart!.isAlive) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const WaitingPage(viewType: 0)));
    }
    _votingStartedSubscription ??=
        context.read<UserRoleViewModel>().minigameStarted.listen((minigame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: MinigameViewFactory.createMinigameView(minigame)));
      });
    });
  }

  @override
  void dispose() {
    _votingStartedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String role = context.watch<UserRoleViewModel>().role;
    Color textColor = role == 'mafia' ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: MyStyles.backgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [MyStyles.purple, MyStyles.lightestPurple],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.025),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(55.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35.0),
                        child: Text(
                          'Your role is: $role',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 65.0),
                        child: role == 'mafia'
                            ? Image.asset(
                                'assets/images/mafia.png',
                                width: 90,
                              )
                            : Image.asset(
                                'assets/images/citizen.png',
                                width: 110,
                              ),
                      ),
                    ],
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
