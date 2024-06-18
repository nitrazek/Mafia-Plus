import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/models/GameHistory.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/GameHistoryViewModel.dart';

class GameHistoryPage extends StatefulWidget {
  const GameHistoryPage({Key? key}) : super(key: key);

  @override
  GameHistoryPageState createState() => GameHistoryPageState();
}

class GameHistoryPageState extends State<GameHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<GameHistoryViewModel>().fetchGameHistory();
  }

  @override
  Widget build(BuildContext context) {
    List<GameHistory> gameHistoryList = context.watch<GameHistoryViewModel>().gameHistory;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Game History',
          style: MyStyles.backgroundTextStyle,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                MyStyles.appBarColor,
                MyStyles.lightestPurple,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          children: [
            const SizedBox(height: 25.0),
            const Text(
              'Game History',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25.0),
            for (GameHistory gameHistory in gameHistoryList)
              ListTile(
                title: Text('Game ${gameHistory.createTimestamp.toString()}'),
                subtitle: Text('Winner: ${gameHistory.winnerRole}'),
              ),
          ],
        ),
      ),
    );
  }
}