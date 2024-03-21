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
  late VotingViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = VotingViewModel();
    viewModel.connectWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('What\'s your gut feeling? \n      Who\'s the mafia?',
            style: TextStyle(fontSize: 28,),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          backgroundColor: MyStyles.appBarColor,
        ),
          backgroundColor: MyStyles.backgroundColor,
        body: VotingBody(),
      ),
    );
  }
}

class VotingBody extends StatelessWidget {
  final WebSocketClient webSocketClient = WebSocketClient();

  @override
  Widget build(BuildContext context) {
    if (context.watch<VotingViewModel>().votingFinished) {
      print("elo");
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 1500),
            child: VotingResultsPage(),
          ),
        );
      });
    }
    return Consumer<VotingViewModel>(
      builder: (context, viewModel, child) {
        List<Player> players = viewModel.getPlayers();
        Map<String, int> votesCount = viewModel.getVotesCount();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
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
                    Expanded( // Dodanie Expanded
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
          ),
        );
      },
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
            // Tekst gracza
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _isButtonPressed ? 0.0 : 1.0,
              child: Container(
                padding: EdgeInsets.all(8.0), // Opcjonalne wewnętrzne odstępy
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Kolor dolnego obramowania
                      width: 2.0, // Grubość dolnego obramowania
                    ),
                  ),
                ),
                child: Text(
                  widget.player.nickname,
                  textAlign: TextAlign.center,
                  style: MyStyles.backgroundTextStyle,
                )

                ),
              ),
          ],
        ),
      ),
    );
  }
}