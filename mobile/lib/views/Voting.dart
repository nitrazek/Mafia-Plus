import 'package:flutter/material.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mobile/views/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({Key? key}) : super(key: key);

  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final WebSocketClient webSocketClient = WebSocketClient();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<VotingViewModel>().votingFinished.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 1500),
          child: VotingResultsPage(),
        ));
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'What\'s your gut feeling?\nWho\'s the mafia?',
          style: TextStyle(fontSize: 28,),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xFF8E44AD),
                Color(0xFFc8a2d8),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8E44AD),
              Color(0xFFc8a2d8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x6D8E44AD),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Consumer<VotingViewModel>(
                builder: (context, viewModel, child) {
                  List<Player> players = viewModel.getPlayers();
                  Map<String, int> votesCount = viewModel.getVotesCount();

                  return ListView.builder(
                    itemCount: players.length - 1,
                    itemBuilder: (context, index) {
                      List<Widget> elements = [];
                      for (Player player in players) {
                        if (player.nickname == webSocketClient.username) continue;
                        elements.add(
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: PlayerButton(
                                    player: player,
                                    onPressed: () => viewModel.vote(player.nickname),
                                    votesCount: votesCount[player.nickname] ?? 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: elements,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerButton extends StatefulWidget {
  final Player player;
  final VoidCallback onPressed;
  final int votesCount;

  PlayerButton({
    required this.player,
    required this.onPressed,
    required this.votesCount,
  });

  @override
  _PlayerButtonState createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: widget.player.canVote &&
            widget.player.nickname !=
                context
                    .watch<VotingViewModel>()
                    .votedPlayer
                    ?.nickname
            ? () {
          setState(() {
            _isButtonPressed = !_isButtonPressed;
          });

          widget.onPressed();
        }
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              curve: Curves.fastOutSlowIn,
              duration: Duration(seconds: 1),
              alignment: _isButtonPressed ? Alignment.center : Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: _isButtonPressed ? Colors.red : MyStyles.buttonStyle.backgroundColor!.resolve({}),
                child: Icon(Icons.person, size: 35.0, color: Colors.white),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _isButtonPressed ? 0.0 : 1.0,
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.player.nickname,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}