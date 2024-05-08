import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/RegisterViewModel.dart';
import 'Menu.dart';
import 'Login.dart';
import 'styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> with RouteAware {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  bool _showErrorMessage = false;
  bool _passwordsMismatch = false;

  late double screenWidth;
  late double screenHeight;

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
    context.read<RegisterViewModel>().reset();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _loginController.clear();
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    context.read<RegisterViewModel>().reset();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _loginController.clear();
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
              MyStyles.appBarColor,
              MyStyles.lightestPurple
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.015,),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Register",style: TextStyle(color: Colors.white, fontSize: 30),),
                ],
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
                        SizedBox(height: screenHeight * 0.01,),
                        Container(
                          decoration: BoxDecoration(
                            color: MyStyles.backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(
                              color: MyStyles.purpleLowOpacity,
                              blurRadius: 20,
                              offset: const Offset(0,10)
                            )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                padding: const EdgeInsets.all(10),
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
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey))
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey))
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: "Confirm password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.015,),
                        Consumer<RegisterViewModel>(
                            builder: (context, viewModel, child) {
                              return ElevatedButton(
                                style: MyStyles.buttonStyle,
                                onPressed: () async {
                                  String login = _loginController.text;
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  String confirmPassword = _confirmPasswordController.text;

                                  if (email.isEmpty || password.isEmpty || login.isEmpty || confirmPassword.isEmpty) {
                                    setState(() {
                                      _showErrorMessage = true;
                                      _passwordsMismatch = false; // Reset password mismatch error
                                    });
                                  } else if (password == confirmPassword) {
                                    bool isRegistered = await viewModel.register(login, email, password);
                                    if(isRegistered) {
                                      Fluttertoast.showToast(
                                          msg: "Successful registration",
                                          toastLength: Toast.LENGTH_SHORT
                                      );
                                      if(!context.mounted) return;
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MenuPage())
                                      );
                                    }
                                    setState(() {
                                      _showErrorMessage = false; // Reset error message
                                      _passwordsMismatch = false; // Reset password mismatch error
                                    });
                                  } else {
                                    setState(() {
                                      _passwordsMismatch = true;
                                      _showErrorMessage = false; // Reset error message
                                    });
                                    print('Password mismatch');
                                  }

                                  if (_passwordsMismatch)
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Please make sure your passwords match",
                                          toastLength: Toast.LENGTH_SHORT);
                                    }
                                  if (_showErrorMessage)
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Add login, password and email",
                                          toastLength: Toast.LENGTH_SHORT);
                                    }
                                },
                                child: const Text(
                                    'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              );
                            }
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        const Text("Already have an account?"),
                        SizedBox(height: screenHeight * 0.005),
                        ElevatedButton(
                            style:MyStyles.buttonStyle,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ))
                        ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      )

    );
  }
}
