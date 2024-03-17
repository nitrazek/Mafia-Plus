import 'package:flutter/material.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/views/VotingResults.dart';
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
          title: Text('Voting'),
        ),
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => VotingResultsPage()));
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
                      child: PlayerButton(
                        player: player,
                        onPressed: () => viewModel.vote(player.nickname),
                        votesCount: votesCount[player.nickname] ?? 0,
                          avatarIndex: index + 1
                      )),
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
  final int avatarIndex; // Dodajemy pole przechowujące indeks avatara

  PlayerButton({
    required this.player,
    required this.onPressed,
    required this.votesCount,
    required this.avatarIndex, // Przekazujemy indeks avatara
  });

  @override
  _PlayerButtonState createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedAlign(
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
        alignment: _isButtonPressed ? Alignment.centerLeft : Alignment.center,
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
          child: CircleAvatar(
            radius: 30.0,
            backgroundColor:
            _isButtonPressed ? Colors.blue : Colors.blue,
            backgroundImage: AssetImage(
              'assets/avatars/avatar_${widget.avatarIndex}.png', // Wybieramy avatar na podstawie indeksu
            ),
            child: _isButtonPressed
                ? Icon(Icons.check, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}
