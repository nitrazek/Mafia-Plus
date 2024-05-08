import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/LoginViewModel.dart';
import 'Menu.dart';
import 'Register.dart';
import 'styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with RouteAware {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late double screenWidth;
  late double screenHeight;

  bool _isLoading = false;
  void _getIsLoadingValue(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
    setState(() {
      _isLoading = result;
    });
    }

  @override
  void initState() {
    super.initState();
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  @override
  void didChangeDependencies() {
    context.read<LoginViewModel>().reset();
    _loginController.clear();
    _passwordController.clear();
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    context.read<LoginViewModel>().reset();
    _loginController.clear();
    _passwordController.clear();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    MyStyles.purple,
                    MyStyles.lightestPurple
                  ]
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.012,),
              Center(
                child: Image.asset(
                  'assets/images/mafialogo.png',
                  height: screenHeight * 0.06,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Mafia+",style: TextStyle(color: Colors.white, fontSize: 35),),
                      Text("Login",style: TextStyle(color: Colors.white, fontSize: 20),)
                    ]
                ),
              ),
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyStyles.backgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.005,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(
                                color: MyStyles.purpleLowOpacity,
                                blurRadius: 20,
                                offset: const Offset(0, 10)
                              )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                  ),
                                  child: TextField(
                                    controller: _loginController,
                                    decoration: const InputDecoration(
                                      hintText: "Login",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                          SizedBox(height: screenHeight * 0.015,),
                          Consumer<LoginViewModel>(
                              builder: (context, viewModel, child) {
                                return ElevatedButton(
                                    style: MyStyles.buttonStyle,
                                    onPressed: _isLoading ? null : () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      bool isLogged = await viewModel.login(
                                          _loginController.text,
                                          _passwordController.text
                                      );
                                      if(isLogged) {
                                        Fluttertoast.showToast(
                                            msg: "Successful login",
                                            toastLength: Toast.LENGTH_SHORT
                                        );
                                        if(!context.mounted) return;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const MenuPage())
                                        );
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                        :Text(
                                        'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ))
                                );
                              }
                          ),
                          SizedBox(height: screenHeight * 0.0075),
                          const Text("Don't have an account?"),
                          SizedBox(height: screenHeight * 0.005),
                          ElevatedButton(
                            style: MyStyles.buttonStyle,
                            onPressed: _isLoading ? null : () => _getIsLoadingValue(context),
                            child:Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ))
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        )
    );
  }
}
