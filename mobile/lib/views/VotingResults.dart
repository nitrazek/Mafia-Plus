import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'package:mobile/views/Menu.dart';
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
    bool temp = true;

    if(context.watch<VotingViewModel>().room == null) {
      Timer(Duration(seconds: 8), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuPage())
        );
      });
    } else {
      Timer(Duration(seconds: 8), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoomPage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF8E44AD),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
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
                    Text(
                      'Voting Results',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Using ListView.builder for dynamic content
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: context.watch<VotingViewModel>().votingSummary?.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Toggle temp value for each container
                    temp = !temp;
                    var voteInfo = context.watch<VotingViewModel>().votingSummary?.results[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.all(20.0),
                      transform: temp ? Matrix4.rotationZ(0.05) : Matrix4.rotationZ(-0.05),
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
    );
  }
}