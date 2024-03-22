import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/JoinPrivateRoomViewModel.dart';
import 'Room.dart';
import 'styles.dart';

class JoinPrivateRoomPage extends StatefulWidget {
  TextEditingController lobbyCodeController = TextEditingController();

  @override
  _JoinPrivateRoomState createState() => _JoinPrivateRoomState();
}

class _JoinPrivateRoomState extends State<JoinPrivateRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyStyles.backgroundColor,
      appBar: AppBar(
          backgroundColor: MyStyles.appBarColor,
        title:  Text('Join Room',style: MyStyles.backgroundTextStyle,)
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: widget.lobbyCodeController,
                style: MyStyles.buttonTextStyle,
                decoration: const InputDecoration(
                  hintText: 'Enter the Room Code',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String accessCode = widget.lobbyCodeController.text;
                final viewModel = context.read<JoinPrivateRoomViewModel>();
                await viewModel.joinRoom(accessCode,
                    () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RoomPage())
                      );
                    },
                    () {
                      if (viewModel.messageError.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(viewModel.messageError),
                          ),
                        );
                      }
                    }
                );
              },
              style: MyStyles.buttonStyle,
              child: Text('Join', style: MyStyles.buttonTextStyle,),
            ),
          ],
        ),
      ),
    );
  }
}
