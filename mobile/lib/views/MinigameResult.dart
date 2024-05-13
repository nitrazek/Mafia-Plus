import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/models/Score.dart';
import 'package:mobile/viewModels/MinigameResultViewModel.dart';
import 'package:provider/provider.dart';

class MinigameResultPage extends StatefulWidget {
  const MinigameResultPage({super.key});

  @override
  State<MinigameResultPage> createState() => MinigameResultPageState();
}

class MinigameResultPageState extends State<MinigameResultPage> {

  bool isWinner = false;
  int rank = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var highestScore = context.watch<MinigameResultViewModel>().highestScore;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyStyles.purple,
              MyStyles.lightestPurple,
            ],
          )
        ),
        child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyStyles.backgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left:40.0, right: 40.0, top: 20.0),
                            child: Text(
                              isWinner ? 'Congratulations, You won!' : 'Somebody\nwas better!',
                              style: TextStyle(
                                color: isWinner ? MyStyles.green : MyStyles.red,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10, ),
                          Image.asset(
                              isWinner ? 'assets/images/Prize.png' : 'assets/images/SecondPrize.png',
                              width: 100
                          ),
                          SizedBox(height: 10,),
                          Text(
                            isWinner ? 'Your price is:' : 'Winner is richer by:',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                      SizedBox(height: 100,),
                      Container(
                          padding:EdgeInsets.only(top:15,bottom:5),
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.end, //add this line
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(radius: 45, backgroundColor: Color(0xFF8E44AD),
                              child: Text(
                                ''
                              ),
                              ),
                              SizedBox(width:20),
                              Padding(
                                padding:EdgeInsets.only(bottom:30),
                                child: CircleAvatar(radius: 60, backgroundColor: Color(0xFFA569BD),
                                  child: Text(
                                      highestScore == null ? "0" : highestScore.toString(),
                                  ),),
                              ),
                              SizedBox(width:20),
                              CircleAvatar(radius: 35, backgroundColor: Color(0xFF77176E),
                                child: Text(
                                    ''
                                ),),
                            ],
                          )
                      )
                      ],
                      )
                    ),
                  ),
                ),
        ),
      )
    );
  }
}
