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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(context.watch<VotingViewModel>().room == null) {
      Timer(const Duration(seconds: 8), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuPage())
        );
      });
    } else {
      Timer(const Duration(seconds: 8), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RoomPage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
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
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'Voting Results',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: context.watch<VotingViewModel>().votingSummary?.results.length,
                            itemBuilder: (BuildContext context, int index) {
                              var voteInfo = context.watch<VotingViewModel>().votingSummary?.results[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: MyStyles.purple,
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

// class VotingResultsBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     if(context.watch<VotingViewModel>().room == null) {
//       Timer(Duration(seconds: 8), () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MenuPage())
//         );
//       });
//     } else {
//       Timer(Duration(seconds: 8), () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => RoomPage(context.watch<VotingViewModel>().room!)),
//         );
//       });
//     }
//     return Scaffold( // Kolor tła
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Voting results',
//               style: const TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             for (var voteInfo in context.watch<VotingViewModel>().votingSummary?.results ?? [])
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     voteInfo.username,
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Votes: ${voteInfo.voteCount}',
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       )
//     );
//   }
// }