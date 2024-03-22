import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/JoinPrivateRoomViewModel.dart';
import 'Room.dart';
import 'styles.dart';

class JoinPrivateRoomPage extends StatefulWidget {
  @override
  _JoinPrivateRoomState createState() => _JoinPrivateRoomState();
}

class _JoinPrivateRoomState extends State<JoinPrivateRoomPage> {
  List<TextEditingController> codeControllers = List.generate(7, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xFF8E44AD), Color(0xFFc8a2d8)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40,),
            Center(
              child: Image.asset(
                'assets/images/mafialogo.png',
                width: MediaQuery.of(context).size.width * 0.40,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Join Room",
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(

                    children: <Widget>[
                      const Text(
                        "Enter the Room Code to join",
                        style: TextStyle(color: Color(0xFF8E44AD), fontSize: 20),
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          return SizedBox(
                            width: 40,
                            child: TextField(
                              controller: codeControllers[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.length == 1 && index < 6) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 27),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x6D8E44AD),
                          minimumSize: Size(MediaQuery.of(context).size.width - 150, 50),
                        ),
                        onPressed: () async {
                          String accessCode = codeControllers.map((controller) => controller.text).join();
                          final viewModel = context.read<JoinPrivateRoomViewModel>();
                          await viewModel.joinRoom(
                            accessCode,
                                () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomPage()));
                            },
                                () {
                              if (viewModel.messageError.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(viewModel.messageError),
                                ));
                              }
                            },
                          );
                        },
                        child: const Text(
                          'Join',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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