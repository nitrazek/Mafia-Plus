import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/viewModels/RoomSettingsViewModel.dart';
import 'styles.dart';

class RoomSettingsPage extends StatefulWidget {
  @override
  _RoomSettingsPageState createState() => _RoomSettingsPageState();
}

class _RoomSettingsPageState extends State<RoomSettingsPage> {
  bool _isPublic = true; // Default to public room
  int _numberOfPlayers = 6; // Default number of players

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                MyStyles.appBarColor,
                MyStyles.lightestPurple
              ]
            )
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40,),
            const Padding(
                padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Room settings",style: TextStyle(color: Colors.white, fontSize: 30),),
              ],
            ),)
          ],
        ),
      ),
    );
  }
}

