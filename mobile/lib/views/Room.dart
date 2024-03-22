import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/models/Room.dart';
import 'RoomSettings.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'UserRole.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  StreamSubscription<void>? _gameStartedSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    _gameStartedSubscription ??= context.read<RoomViewModel>().gameStarted.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserRolePage()));
      });
    });
  }

  @override
  void dispose() {
    _gameStartedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Room'),
          backgroundColor: Colors.blue,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // Ustawienia ogólne aplikacji
                },
                child: const Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Players: ${context.watch<RoomViewModel>().room?.accountUsernames.length}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (context.watch<RoomViewModel>().isHost)
                    ElevatedButton(
                      onPressed: () {
                        int roomId = context.read<RoomViewModel>().room?.id ?? 0;
                        context.read<RoomViewModel>().startGame(
                          roomId,
                          () {},
                          () {
                            if (context.read<RoomViewModel>().messageError.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.watch<RoomViewModel>().messageError),
                                ),
                              );
                            }
                          }
                        );
                      },
                      child: const Text('Start game'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (context.watch<RoomViewModel>().isHost)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomSettingsPage(),
                          ),
                        );
                      },
                      child: const Text('Settings'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RoomViewModel>().leaveRoom(
                              () {
                            Navigator.pop(context);
                          },
                              () {}
                      );
                    },
                    child: const Text('Exit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'AccesCode: ${context.read<RoomViewModel>().room?.accessCode}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  // Otwieranie chatu
                  print('Open chat');
                },
                child: const Icon(
                  Icons.chat,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
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
                      '👑', // Emotikona korony
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                onTap: () {
                  // Obsługa naciśnięcia na gospodarza
                },
              ),
              for (String uzytkownik in context.watch<RoomViewModel>().room!.accountUsernames)
                ListTile(
                  title: Text(uzytkownik),
                  onTap: () {
                    // Obsługa naciśnięcia na innych graczy
                  },
                ),
            ],
          ),
        ),
      )
    );
  }
}
