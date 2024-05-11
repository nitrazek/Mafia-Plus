import 'package:flutter/cupertino.dart';
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
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MinigameViewModel>(
      builder: (context, minigameViewModel, child) {
        NumberMemoryMinigameViewModel viewModel = minigameViewModel as NumberMemoryMinigameViewModel;
        return viewModel.isNumberVisible ? Center(
          child: Text(viewModel.generatedNumber)
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