import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';

import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/viewModels/RoomSettingsViewModel.dart';
import '../utils/CustomThumbShape.dart';
import 'styles.dart';

class RoomSettingsPage extends StatefulWidget {
  const RoomSettingsPage({super.key});

  @override
  RoomSettingsPageState createState() => RoomSettingsPageState();
}

class RoomSettingsPageState extends State<RoomSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [MyStyles.appBarColor, MyStyles.lightestPurple]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Room settings",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                color: MyStyles.backgroundColor,),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 45),
                      const Text(
                        'Max players:',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbColor: MyStyles.purple,
                          activeTrackColor: MyStyles.lightPurple,
                          activeTickMarkColor: MyStyles.lightPurple,
                          inactiveTrackColor: MyStyles.lightestPurple,
                          inactiveTickMarkColor: MyStyles.lightestPurple,
                          thumbShape: CustomThumbShape(),
                          showValueIndicator:
                          ShowValueIndicator.never,
                          valueIndicatorTextStyle: const TextStyle(fontSize: 25),
                        ),
                        child: Slider(
                          value: context.watch<RoomSettingsViewModel>()
                            .roomSettings!
                            .maxNumberOfPlayers
                            .toDouble(),
                          min: 4,
                          max: 10,
                          divisions: 6,
                          label: context.watch<RoomSettingsViewModel>()
                            .roomSettings!
                            .maxNumberOfPlayers
                            .toString(),
                          onChanged: context.read<RoomSettingsViewModel>()
                            .setMaxNumberOfPlayers,
                          ),
                        ),
                        const SizedBox(height: 90,),
                        const Text(
                          'Room type:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: LiteRollingSwitch(
                            value: context.watch<RoomSettingsViewModel>()
                              .roomSettings!
                              .isPublic,
                            width: 200,
                            textSize: 22,
                            textOn: 'Public',
                            textOff: 'Private',
                            colorOn: MyStyles.green,
                            colorOff: MyStyles.red,
                            textOnColor: MyStyles.backgroundColor,
                            textOffColor: MyStyles.backgroundColor,
                            iconOn: Icons.lock_open,
                            iconOff: Icons.lock,
                            onChanged: context.read<RoomSettingsViewModel>()
                              .setIsPublic,
                            onTap: () {},
                            onDoubleTap: () {},
                            onSwipe: () {},
                          )
                        ),
                        const SizedBox(height: 120),
                        ElevatedButton(
                          style: MyStyles.buttonStyle,
                          onPressed: () {
                            context.read<RoomSettingsViewModel>().saveRoomSettings(
                              () {},
                              (errorMsg) {
                                Fluttertoast.showToast(msg: errorMsg);
                              }
                            );
                          },
                          child: const Text("Save settings")
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
