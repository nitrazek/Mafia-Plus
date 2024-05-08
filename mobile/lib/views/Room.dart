import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/models/Room.dart';
import 'RoomSettings.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'UserRole.dart';
import 'styles.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  StreamSubscription<void>? _gameStartedSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameStartedSubscription ??= context.read<RoomViewModel>().gameStarted.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRolePage()));
      });
    });
  }

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
  void dispose() {
    _gameStartedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Room',
          style: MyStyles.backgroundTextStyle,),
          backgroundColor: MyStyles.appBarColor,
          actions: [
            if (context.watch<RoomViewModel>().isHost)
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomSettingsPage()),
                  );
                },
                child: const Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: MyStyles.purpleLowOpacity,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/mafialogo.png',
                        height: screenHeight * 0.06,
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'Invite your friends and start the game!',
                        style: TextStyle(fontSize: 28, color: MyStyles.appBarColor, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'Players: ${context.watch<RoomViewModel>().room?.accountUsernames.length}',
                        style: TextStyle(fontSize: 28, color: MyStyles.appBarColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      if (context.watch<RoomViewModel>().isHost)
                        ElevatedButton(
                          onPressed: () {
                            int roomId = context.read<RoomViewModel>().room?.id ?? 0;
                            context.read<RoomViewModel>().startGame(
                                roomId,
                                  (){},
                                  (messageError){
                                  if(messageError.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(messageError),
                                      ),
                                    );
                                  }
                                }
                            );
                          },
                          style: MyStyles.buttonStyle,
                          child: const Text('Start game'),
                        ),
                      SizedBox(height: screenHeight * 0.005),
                      ElevatedButton(
                        onPressed: () {
                          context.read<RoomViewModel>().leaveRoom(
                              () {
                                Navigator.pop(context);
                              },
                              (messageError) {}
                          );
                        },
                        style: MyStyles.buttonStyle,
                        child: const Text('Exit'),
                      ),
                      SizedBox(height: screenHeight * 0.0075),
                      if (context.read<RoomViewModel>().room?.roomSettings.isPublic == false)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Room is PRIVATE 🔐',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      if (context.read<RoomViewModel>().room?.roomSettings.isPublic == true)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Room is PUBLIC 🔓',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'AccessCode: ${context.read<RoomViewModel>().room?.accessCode}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          surfaceTintColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: MyStyles.purple,
                ),
                child: const Text(
                  'Players in room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Text(context.watch<RoomViewModel>().room!.hostUsername),
                    const Text(
                      ' 👑', // Emotikona korony
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                onTap: () {
                  // Obsługa naciśnięcia na gospodarza
                },
              ),
              ...context.watch<RoomViewModel>().room!.accountUsernames.where((uzytkownik) => uzytkownik != context.watch<RoomViewModel>().room!.hostUsername).map((uzytkownik) => ListTile(
                title: Text(uzytkownik),
                onTap: () {
                  // Obsługa naciśnięcia na innych graczy
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}