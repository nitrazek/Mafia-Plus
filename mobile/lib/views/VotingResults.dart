import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/views/Menu.dart';
import 'package:mobile/views/Winner.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

import '../models/Room.dart';
import '../viewModels/VotingViewModel.dart';
import 'Room.dart';

class VotingResultsPage extends StatefulWidget {
  const VotingResultsPage({super.key});
  @override
  _VotingResultsPageState createState() => _VotingResultsPageState();
}

class _VotingResultsPageState extends State<VotingResultsPage> {
  @override
  Widget build(BuildContext context) {
    bool transformChanger = true;

    if(context.watch<VotingViewModel>().room == null) {
      Timer(const Duration(seconds: 8), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuPage())
        );
      });
    } else {
      Timer(const Duration(seconds: 80  ), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoomPage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8E44AD),
              Color(0xFFc8a2d8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Text(
                        'Voting Results',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.black,
                        ),
                      ),
                      const Text(
                        'Voting Results',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Using ListView.builder for dynamic content
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: context.watch<VotingViewModel>().votingSummary?.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Toggle temp value for each container
                      transformChanger = !transformChanger;
                      var voteInfo = context.watch<VotingViewModel>().votingSummary?.results[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        padding: EdgeInsets.all(20.0),
                        transform: transformChanger ? Matrix4.rotationZ(0.03) : Matrix4.rotationZ(-0.03),
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
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