import 'package:flutter/material.dart';
import 'package:mobile/views/Voting.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/WinnerRoleViewModel.dart';
import 'package:mobile/models/Room.dart';

class UserRolePage extends StatefulWidget {
  @override
  _UserRolePageState createState() => _UserRolePageState();
}

class _UserRolePageState extends State<UserRolePage> {
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    // Start a timer to automatically navigate to the voting page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (!buttonPressed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VotingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<WinnerRoleViewModel>(
              builder: (context, winnerRoleViewModel, child) {
                return Text(
                  'Your role is: '
                      '${context.watch<WinnerRoleViewModel>().userRole}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}