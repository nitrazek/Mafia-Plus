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
          MaterialPageRoute(builder: (context) => RoomPage(context.watch<VotingViewModel>().room!)),
        );
      });
    }
    return Scaffold( // Kolor tła
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Voting results',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              for (var voteInfo in context.watch<VotingViewModel>().votingSummary?.results ?? [])
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      voteInfo.username,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Votes: ${voteInfo.voteCount}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        )
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