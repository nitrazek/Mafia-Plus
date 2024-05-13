import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/viewModels/minigames/MinigameViewModel.dart';
import 'package:mobile/viewModels/minigames/NumberMemoryMinigameViewModel.dart';
import 'package:provider/provider.dart';

class NumberMemoryMinigamePage extends StatefulWidget {
  const NumberMemoryMinigamePage({super.key});

  @override
  NumberMemoryMinigamePageState createState() => NumberMemoryMinigamePageState();
}

class NumberMemoryMinigamePageState extends State<NumberMemoryMinigamePage> {
  bool _isNumberVisible = true;
  final TextEditingController _answerController = TextEditingController();

  void _showNumber() {
    setState(() {
      _isNumberVisible = true;
    });
  }

  void _hideNumber() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isNumberVisible = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    NumberMemoryMinigameViewModel viewModel = Provider.of<MinigameViewModel>(context) as NumberMemoryMinigameViewModel;
    viewModel.setHideNumberCallback(_hideNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MinigameViewModel>(
      builder: (context, minigameViewModel, child) {
        NumberMemoryMinigameViewModel viewModel = minigameViewModel as NumberMemoryMinigameViewModel;
        return viewModel.isNumberVisible ? Center(
          child: Text(
            viewModel.generatedNumber,
            style: const TextStyle(
              fontSize: 25
            ),
          )
        ) : Column(
          children: [
            Row(
              children: [
                TextField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "What was the number?"
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.submitAnswer(_answerController.text);
                    _showNumber();
                  },
                  child: const Text("Submit"),
                )
              ],
            )
          ],
        );
      }
    );
  }
}